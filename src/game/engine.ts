// BashQuest web engine: reproduces bashquest.sh's game rules (lives, XP,
// streaks, hints, skips, tier/level progression) against the level data
// extracted by scripts/extract-levels.mjs. This is a practice port: no
// accounts, no graduation certificate.
//
// The engine is pure state plus an emitted screen/lines of terminal text
// per turn; it knows nothing about xterm.js. src/game/terminal.ts drives it.

import levelsData from './data/levels.json';
import tiersData from './data/tiers.json';
import mentorData from './data/mentor.json';

export type CheckType = 'regex' | 'exact';

export interface Challenge {
    title: string;
    desc: string;
    hint: string;
    checkType: CheckType;
    checkValue: string;
    xp: number;
}

export interface LevelData {
    num: number;
    name: string;
    cmds: string;
    icon: string;
    intro: { title: string; desc: string; badge: string };
    tierComplete: { tierName: string; tierDesc: string; nextTier: string } | null;
    challenges: Challenge[];
}

export interface TierData {
    num: number;
    name: string;
    icon: string;
    startLevel: number;
    endLevel: number;
}

export interface Mentor {
    name: string;
    encourage: string[];
    correct: string[];
    wrong: string[];
    hint: string[];
    streak3: string[];
    streak5: string[];
    streak8: string[];
    levelComplete: string[];
    gameOver: string[];
    idle: string[];
}

const LEVELS = levelsData as LevelData[];
const TIERS = tiersData as TierData[];
const MENTOR = mentorData as Mentor;
export const TOTAL_LEVELS = LEVELS.length;

const SAVE_KEY = 'bashquest_web_save_v1';

export interface SaveState {
    level: number;
    xp: number;
    lives: number;
    bestStreak: number;
    totalHints: number;
    totalSkips: number;
    totalLivesLost: number;
}

function defaultSave(): SaveState {
    return { level: 1, xp: 0, lives: 3, bestStreak: 0, totalHints: 0, totalSkips: 0, totalLivesLost: 0 };
}

function loadSave(): SaveState {
    try {
        const raw = localStorage.getItem(SAVE_KEY);
        if (!raw) return defaultSave();
        const parsed = JSON.parse(raw);
        const d = defaultSave();
        for (const k of Object.keys(d) as (keyof SaveState)[]) {
            if (typeof parsed[k] === 'number' && Number.isFinite(parsed[k]) && parsed[k] >= 0) {
                (d[k] as number) = parsed[k];
            }
        }
        return d;
    } catch {
        return defaultSave();
    }
}

function writeSave(s: SaveState) {
    try {
        localStorage.setItem(SAVE_KEY, JSON.stringify(s));
    } catch {
        // localStorage unavailable (private mode etc.): progress just won't persist.
    }
}

function pick<T>(arr: T[]): T {
    return arr[Math.floor(Math.random() * arr.length)];
}

export function tierForLevel(num: number): TierData {
    return TIERS.find((t) => num >= t.startLevel && num <= t.endLevel) ?? TIERS[TIERS.length - 1];
}

export function levelByNum(num: number): LevelData | undefined {
    return LEVELS.find((l) => l.num === num);
}

// ---- output model ----------------------------------------------------

// A "screen" is a full render replacing the terminal body; a "line" is
// appended to the current scroll (used mid-challenge for correct/incorrect
// feedback so the challenge prompt itself doesn't get redrawn each try).
export type Emit = { kind: 'screen' | 'lines'; text: string[] };

export type Mode =
    | { kind: 'welcome' }
    | { kind: 'main_menu' }
    | { kind: 'tier_select' }
    | { kind: 'level_select'; tier: TierData }
    | { kind: 'level_intro'; level: LevelData }
    | { kind: 'challenge'; level: LevelData; index: number }
    | { kind: 'level_complete'; level: LevelData }
    | { kind: 'tier_complete'; level: LevelData }
    | { kind: 'game_over' }
    | { kind: 'graduated' }
    | { kind: 'reset_confirm' };

export class Engine {
    save: SaveState = loadSave();
    mode: Mode = { kind: 'welcome' };

    // per-run counters (not persisted, mirrors LEVEL_* bash vars)
    streak = 0;
    levelHints = 0;
    levelSkips = 0;
    levelLivesLost = 0;

    onEmit: (e: Emit) => void = () => {};

    private screen(...text: string[]) {
        this.onEmit({ kind: 'screen', text });
    }
    private lines(...text: string[]) {
        this.onEmit({ kind: 'lines', text });
    }

    persist() {
        writeSave(this.save);
    }

    mentorSays(line: string): string {
        return `  ${MENTOR.name} » ${line}`;
    }

    start() {
        this.renderWelcome();
    }

    private renderWelcome() {
        this.mode = { kind: 'welcome' };
        this.screen(
            'BASHQUEST, Practice Mode (Browser)',
            '',
            'This is the same 90-level, eighteen-tier command trainer as the real',
            'bashquest.sh, played by typing the command that answers each challenge.',
            '',
            'Progress here saves to this browser only (no account, no server).',
            `For the real, verified graduation certificate, play over SSH: ssh late.sh`,
            'or run the script locally, see the Installation docs.',
            '',
            this.mentorSays(pick(MENTOR.encourage)),
            '',
            "Type 'start' and press Enter.",
        );
    }

    private statusLine(): string {
        const s = this.save;
        const t = tierForLevel(s.level <= TOTAL_LEVELS ? s.level : TOTAL_LEVELS);
        return `Lv.${Math.min(s.level, TOTAL_LEVELS)}/${TOTAL_LEVELS} (Tier ${t.num}: ${t.name})   XP:${s.xp}   Lives:${'❤'.repeat(Math.max(s.lives, 0))}${'✗'.repeat(Math.max(3 - s.lives, 0))}   Best streak:${s.bestStreak}`;
    }

    private renderMainMenu() {
        this.mode = { kind: 'main_menu' };
        const s = this.save;
        const nextLevel = levelByNum(Math.min(s.level, TOTAL_LEVELS));
        const lines = [
            'BASHQUEST, Main Menu',
            this.statusLine(),
            '',
        ];
        if (s.level > TOTAL_LEVELS) {
            lines.push('  You have completed every level in practice mode.');
        } else if (nextLevel) {
            lines.push(`  Next up: Level ${nextLevel.num}: ${nextLevel.name}`);
        }
        lines.push(
            '',
            "  1) Continue",
            "  2) Select a level (by tier)",
            "  3) Reset progress",
            '',
            "Type a number, or 'quit' to leave the terminal idle.",
        );
        this.screen(...lines);
    }

    private renderTierSelect() {
        this.mode = { kind: 'tier_select' };
        const lines = ['Select a tier:', ''];
        for (const t of TIERS) {
            const unlocked = this.save.level >= t.startLevel || this.save.level > TOTAL_LEVELS;
            lines.push(`  ${String(t.num).padStart(2)}) ${t.icon} ${t.name}  (levels ${t.startLevel}-${t.endLevel})${unlocked ? '' : '  [locked]'}`);
        }
        lines.push('', "Enter a tier number, or '0' to go back.");
        this.screen(...lines);
    }

    private renderLevelSelect(tier: TierData) {
        this.mode = { kind: 'level_select', tier };
        const lines = [`Tier ${tier.num}: ${tier.name}, select a level:`, ''];
        for (let n = tier.startLevel; n <= tier.endLevel; n++) {
            const lvl = levelByNum(n)!;
            const locked = n > this.save.level && this.save.level <= TOTAL_LEVELS;
            lines.push(`  ${String(n).padStart(2)}) ${lvl.icon} ${lvl.name}${locked ? '  [locked]' : ''}`);
        }
        lines.push('', "Enter a level number, or '0' to go back.");
        this.screen(...lines);
    }

    private renderLevelIntro(level: LevelData) {
        this.mode = { kind: 'level_intro', level };
        this.screen(
            `LEVEL ${level.num}: ${level.name}`,
            level.intro.badge,
            '',
            level.intro.desc,
            '',
            this.mentorSays(pick(MENTOR.encourage)),
            '',
            'Press Enter to begin.',
        );
    }

    private renderChallenge(level: LevelData, index: number, opts?: { extra?: string[] }) {
        this.mode = { kind: 'challenge', level, index };
        const c = level.challenges[index];
        const lines = [
            `CHALLENGE ${index + 1}/${level.challenges.length}: ${c.title}`,
            this.statusLine(),
            '',
            c.desc,
            '',
        ];
        if (opts?.extra) lines.push(...opts.extra, '');
        lines.push("Type your answer. 'hint' for a clue, 'skip' to pass (-1 life).");
        this.screen(...lines);
    }

    private renderLevelComplete(level: LevelData) {
        this.mode = { kind: 'level_complete', level };
        const flawless = this.levelHints === 0 && this.levelSkips === 0 && this.levelLivesLost === 0;
        const lines = [
            `⭐ Level ${level.num} complete!`,
            `XP: ${this.save.xp}`,
        ];
        if (flawless) lines.push('✨ Flawless: no hints, no skips, no lives lost.');
        lines.push('', this.mentorSays(pick(MENTOR.levelComplete)), '', 'Press Enter to continue.');
        this.screen(...lines);
    }

    private renderTierComplete(level: LevelData) {
        this.mode = { kind: 'tier_complete', level };
        const tc = level.tierComplete!;
        this.screen(
            `🏁 TIER COMPLETE: ${tc.tierName}`,
            '',
            tc.tierDesc,
            '',
            `XP: ${this.save.xp}   Best streak: ${this.save.bestStreak}`,
            '',
            this.mentorSays(pick(MENTOR.levelComplete)),
            '',
            `Next up: ${tc.nextTier}`,
            '',
            'Press Enter to continue.',
        );
    }

    private renderGameOver() {
        this.mode = { kind: 'game_over' };
        this.screen(
            'GAME OVER',
            '',
            'You ran out of lives. Lives reset to 3, your level and XP are kept.',
            `Final XP: ${this.save.xp}   Level reached: ${Math.min(this.save.level, TOTAL_LEVELS)}`,
            '',
            this.mentorSays(pick(MENTOR.gameOver)),
            '',
            'Press Enter to continue.',
        );
    }

    private renderGraduated() {
        this.mode = { kind: 'graduated' };
        this.screen(
            'PRACTICE COMPLETE',
            '',
            `You've answered every challenge across all ${TOTAL_LEVELS} levels and eighteen tiers.`,
            `XP: ${this.save.xp}   Best streak: ${this.save.bestStreak}`,
            `Hint-free: ${this.save.totalHints === 0 ? 'yes' : 'no'}   Skip-free: ${this.save.totalSkips === 0 ? 'yes' : 'no'}   No lives lost: ${this.save.totalLivesLost === 0 ? 'yes' : 'no'}`,
            '',
            "This browser run has no account and issues no certificate, it's",
            'practice. For the real, tamper-resistant graduation certificate,',
            "play over SSH: ssh late.sh, or run bashquest.sh locally (see the",
            'Installation docs) and complete graduation_ceremony there.',
            '',
            this.mentorSays(pick(MENTOR.levelComplete)),
            '',
            "Type 'menu' to go back, or 'reset' to play again from level 1.",
        );
    }

    private renderResetConfirm() {
        this.mode = { kind: 'reset_confirm' };
        this.screen(
            'Reset ALL browser progress?',
            '',
            "Type 'yes' to confirm, anything else to cancel.",
        );
    }

    // ---- input handling -----------------------------------------------

    handleInput(raw: string) {
        const input = raw.trim();
        switch (this.mode.kind) {
            case 'welcome':
                this.renderMainMenu();
                return;
            case 'main_menu':
                return this.onMainMenu(input);
            case 'tier_select':
                return this.onTierSelect(input);
            case 'level_select':
                return this.onLevelSelect(this.mode.tier, input);
            case 'level_intro':
                return this.beginChallenges(this.mode.level);
            case 'challenge':
                return this.onChallengeInput(this.mode.level, this.mode.index, input);
            case 'level_complete':
                return this.afterLevelComplete(this.mode.level);
            case 'tier_complete':
                return this.renderMainMenu();
            case 'game_over':
                return this.renderMainMenu();
            case 'graduated':
                if (input.toLowerCase() === 'reset') return this.renderResetConfirm();
                return this.renderMainMenu();
            case 'reset_confirm':
                if (input.toLowerCase() === 'yes') {
                    this.save = defaultSave();
                    this.persist();
                }
                return this.renderMainMenu();
        }
    }

    private onMainMenu(input: string) {
        if (input === '1' || input.toLowerCase() === 'continue') {
            if (this.save.level > TOTAL_LEVELS) return this.renderGraduated();
            return this.enterLevel(this.save.level);
        }
        if (input === '2' || input.toLowerCase().startsWith('select')) return this.renderTierSelect();
        if (input === '3' || input.toLowerCase() === 'reset') return this.renderResetConfirm();
        return this.renderMainMenu();
    }

    private onTierSelect(input: string) {
        if (input === '0') return this.renderMainMenu();
        const num = Number(input);
        const tier = TIERS.find((t) => t.num === num);
        if (!tier) return this.renderTierSelect();
        return this.renderLevelSelect(tier);
    }

    private onLevelSelect(tier: TierData, input: string) {
        if (input === '0') return this.renderTierSelect();
        const num = Number(input);
        if (!Number.isInteger(num) || num < tier.startLevel || num > tier.endLevel) {
            return this.renderLevelSelect(tier);
        }
        return this.enterLevel(num);
    }

    private enterLevel(num: number) {
        const level = levelByNum(num);
        if (!level) return this.renderMainMenu();
        this.levelHints = 0;
        this.levelSkips = 0;
        this.levelLivesLost = 0;
        this.renderLevelIntro(level);
    }

    private beginChallenges(level: LevelData) {
        this.renderChallenge(level, 0);
    }

    private checkAnswer(c: Challenge, input: string): boolean {
        if (c.checkType === 'exact') return input === c.checkValue;
        try {
            return new RegExp(c.checkValue).test(input);
        } catch {
            return false;
        }
    }

    private onChallengeInput(level: LevelData, index: number, input: string) {
        const c = level.challenges[index];
        const lower = input.toLowerCase();

        if (lower === 'hint') {
            this.save.totalHints++;
            this.levelHints++;
            this.persist();
            this.renderChallenge(level, index, {
                extra: [this.mentorSays(pick(MENTOR.hint)), `💡 ${c.hint}`],
            });
            return;
        }

        if (lower === 'skip') {
            this.save.totalSkips++;
            this.levelSkips++;
            this.save.lives--;
            this.streak = 0;
            this.persist();
            if (this.save.lives <= 0) return this.gameOver();
            return this.afterChallengeResolved(level, index);
        }

        if (this.checkAnswer(c, input)) {
            this.streak++;
            if (this.streak > this.save.bestStreak) this.save.bestStreak = this.streak;
            this.save.xp += c.xp;
            this.persist();
            const extra = [`✓ Correct!  +${c.xp} XP (total ${this.save.xp})`, this.mentorSays(pick(MENTOR.correct))];
            if (this.streak === 3) extra.push(`🔥 ${pick(MENTOR.streak3)}`);
            if (this.streak === 5) extra.push(`🔥 ${pick(MENTOR.streak5)}`);
            if (this.streak === 8) extra.push(`🔥 ${pick(MENTOR.streak8)}`);
            this.lines(...extra);
            return this.afterChallengeResolved(level, index);
        }

        this.save.lives--;
        this.save.totalLivesLost++;
        this.levelLivesLost++;
        this.streak = 0;
        this.persist();
        if (this.save.lives <= 0) return this.gameOver();
        this.lines(
            `✗ Incorrect.  Lives remaining: ${this.save.lives}`,
            this.mentorSays(pick(MENTOR.wrong)),
            "Type 'hint' for help or 'skip' to skip.",
        );
    }

    private afterChallengeResolved(level: LevelData, index: number) {
        const next = index + 1;
        if (next < level.challenges.length) {
            this.renderChallenge(level, next);
        } else {
            this.completeLevel(level);
        }
    }

    private completeLevel(level: LevelData) {
        if (this.save.level <= level.num) {
            this.save.level = level.num + 1;
            this.persist();
        }
        if (level.tierComplete) {
            this.renderTierComplete(level);
        } else if (level.num >= TOTAL_LEVELS) {
            this.renderGraduated();
        } else {
            this.renderLevelComplete(level);
        }
    }

    private afterLevelComplete(level: LevelData) {
        this.renderMainMenu();
    }

    private gameOver() {
        this.save.lives = 3;
        this.streak = 0;
        this.persist();
        this.renderGameOver();
    }
}
