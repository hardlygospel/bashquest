#!/usr/bin/env node
// Mechanically extracts BashQuest's level/challenge data out of bashquest.sh
// into JSON the browser game engine consumes. Every run_challenge/level_intro/
// tier_complete argument in the source is a static double- or single-quoted
// bash string literal (verified: no dynamic/variable args anywhere in the
// file), so this is pure text extraction, not bash evaluation.

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const SRC = join(__dirname, '..', 'bashquest.sh');
const OUT_DIR = join(__dirname, '..', 'src', 'game', 'data');

const text = readFileSync(SRC, 'utf8');

// --- low-level bash string-literal scanners -------------------------------

// Scans a bash double-quoted string starting at `i` (text[i] === '"').
// Returns { value, next } where `next` is the index just past the closing
// quote. Handles backslash-escaped characters generically (bash keeps the
// escaped char literally for anything except a few specials, which is fine
// here since we only care about \" \\ and \n).
function scanDouble(text, i) {
    if (text[i] !== '"') throw new Error(`expected " at ${i}: ...${text.slice(i, i + 40)}`);
    let out = '';
    let j = i + 1;
    while (j < text.length) {
        const c = text[j];
        if (c === '\\') {
            const n = text[j + 1];
            if (n === 'n') out += '\n';
            else if (n === '"' || n === '\\' || n === '$' || n === '`') out += n;
            else out += n;
            j += 2;
            continue;
        }
        if (c === '"') return { value: out, next: j + 1 };
        out += c;
        j += 1;
    }
    throw new Error(`unterminated " starting at ${i}`);
}

// Bash single-quoted strings have zero escapes: everything is literal until
// the next '.
function scanSingle(text, i) {
    if (text[i] !== "'") throw new Error(`expected ' at ${i}: ...${text.slice(i, i + 40)}`);
    const end = text.indexOf("'", i + 1);
    if (end === -1) throw new Error(`unterminated ' starting at ${i}`);
    return { value: text.slice(i + 1, end), next: end + 1 };
}

// Advances past whitespace, line-continuation backslash-newlines, and blank.
function skipGap(text, i) {
    while (i < text.length) {
        if (text[i] === '\\' && text[i + 1] === '\n') { i += 2; continue; }
        if (/\s/.test(text[i])) { i += 1; continue; }
        break;
    }
    return i;
}

function stripColorTokens(s) {
    return s.replace(/\$\{[A-Za-z_][A-Za-z0-9_]*\}/g, '');
}

// Reads one bash "word": one or more quoted segments (single or double)
// concatenated back-to-back with no whitespace between them, exactly like
// bash's own argument parsing. Needed because a few hint strings embed a
// literal single quote via the 'foo'"'"'bar' trick to show real quoting in
// an example command (see the awk hints), which switches quote style
// mid-argument.
function scanArg(text, i) {
    let out = '';
    let sawAny = false;
    while (i < text.length) {
        if (text[i] === '"') {
            const { value, next } = scanDouble(text, i);
            out += value;
            i = next;
            sawAny = true;
            continue;
        }
        if (text[i] === "'") {
            const { value, next } = scanSingle(text, i);
            out += value;
            i = next;
            sawAny = true;
            continue;
        }
        break;
    }
    if (!sawAny) throw new Error(`expected quoted arg at ${i}: ...${text.slice(i, i + 40)}`);
    return { value: stripColorTokens(out), next: i };
}

// Reads N bash-word args (see scanArg) in sequence, skipping gaps between.
function readDoubleArgs(text, i, count) {
    const args = [];
    for (let k = 0; k < count; k++) {
        i = skipGap(text, i);
        const { value, next } = scanArg(text, i);
        args.push(value);
        i = next;
    }
    return { args, next: i };
}

// --- per-call-site extraction ---------------------------------------------

function parseLevelIntro(body) {
    const m = body.match(/level_intro\s+(\d+)\s+/);
    if (!m) return null;
    let i = skipGap(body, m.index + m[0].length);
    const { args } = readDoubleArgs(body, i, 3);
    return { num: Number(m[1]), title: args[0], desc: args[1], badge: args[2] };
}

function parseTierComplete(body) {
    const m = body.match(/tier_complete\s+(\d+)\s+/);
    if (!m) return null;
    let i = skipGap(body, m.index + m[0].length);
    const { args } = readDoubleArgs(body, i, 3);
    return { num: Number(m[1]), tierName: args[0], tierDesc: args[1], nextTier: args[2] };
}

function parseChallenges(body) {
    const challenges = [];
    const re = /run_challenge\s+/g;
    let m;
    while ((m = re.exec(body))) {
        let i = skipGap(body, m.index + m[0].length);
        const { args, next } = readDoubleArgs(body, i, 3);
        const [title, desc, hint] = args;
        i = skipGap(body, next);
        const { value: checkExpr, next: next2 } = scanSingle(body, i);
        i = skipGap(body, next2);
        const numMatch = body.slice(i).match(/^-?\d+/);
        if (!numMatch) throw new Error(`expected xp number after check expr near ${i}: ...${body.slice(i, i + 40)}`);
        const xp = Number(numMatch[0]);
        i += numMatch[0].length;
        re.lastIndex = i;

        let checkType, checkValue;
        let cm = checkExpr.match(/^chk\s+"(.*)"$/s);
        if (cm) {
            checkType = 'regex';
            checkValue = cm[1];
        } else {
            cm = checkExpr.match(/^exact\s+"(.*)"$/s);
            if (!cm) throw new Error(`unrecognized check expr: ${checkExpr}`);
            checkType = 'exact';
            checkValue = cm[1];
        }
        challenges.push({ title, desc, hint, checkType, checkValue, xp });
    }
    return challenges;
}

// --- top-level structures ---------------------------------------------------

function parseArrayOfLines(varName) {
    const re = new RegExp(`^${varName}=\\(\\n([\\s\\S]*?)\\n\\)`, 'm');
    const m = text.match(re);
    if (!m) throw new Error(`array ${varName} not found`);
    const body = m[1];
    const lines = [];
    const lineRe = /"/g;
    let i = 0;
    while (i < body.length) {
        while (i < body.length && body[i] !== '"') i++;
        if (i >= body.length) break;
        const { value, next } = scanDouble(body, i);
        lines.push(stripColorTokens(value));
        i = next;
    }
    return lines;
}

function parseTiers() {
    const m = text.match(/^TIERS=\(\n([\s\S]*?)\n\)/m);
    if (!m) throw new Error('TIERS array not found');
    const rows = [];
    for (const line of m[1].split('\n')) {
        const mm = line.match(/"\s*(\d+)\|([^|]*)\|([^|]*)\|\s*(\d+)\|\s*(\d+)"/);
        if (!mm) continue;
        rows.push({
            num: Number(mm[1]),
            name: mm[2].trim(),
            icon: mm[3].trim(),
            startLevel: Number(mm[4]),
            endLevel: Number(mm[5]),
        });
    }
    return rows;
}

function parseLevelMeta() {
    const m = text.match(/^LEVELS=\(\n([\s\S]*?)\n\)/m);
    if (!m) throw new Error('LEVELS array not found');
    const rows = [];
    for (const line of m[1].split('\n')) {
        const mm = line.match(/"\s*(\d+)\|([^|]*)\|([^|]*)\|([^"]*)"/);
        if (!mm) continue;
        rows.push({
            num: Number(mm[1]),
            name: mm[2].trim(),
            cmds: mm[3].trim(),
            icon: mm[4].trim(),
        });
    }
    return rows;
}

// Split the file into one body-slice per run_level_N function.
function splitLevelFunctions() {
    const starts = [...text.matchAll(/^run_level_(\d+)\(\)\s*\{\s*$/gm)];
    const bodies = new Map();
    for (let k = 0; k < starts.length; k++) {
        const num = Number(starts[k][1]);
        const bodyStart = starts[k].index + starts[k][0].length;
        // function body ends at the next line that is exactly "}"
        const closeRe = /^\}\s*$/m;
        closeRe.lastIndex = bodyStart;
        const rest = text.slice(bodyStart);
        const closeMatch = rest.match(/\n\}\s*\n/);
        if (!closeMatch) throw new Error(`no closing brace found for run_level_${num}`);
        const bodyEnd = bodyStart + closeMatch.index;
        bodies.set(num, text.slice(bodyStart, bodyEnd));
    }
    return bodies;
}

// --- assemble --------------------------------------------------------------

const tiers = parseTiers();
const levelMeta = parseLevelMeta();
const levelBodies = splitLevelFunctions();

const levels = [];
for (const meta of levelMeta) {
    const body = levelBodies.get(meta.num);
    if (!body) throw new Error(`no run_level_${meta.num} function body found`);
    const intro = parseLevelIntro(body);
    const tierCompleteInfo = parseTierComplete(body);
    const challenges = parseChallenges(body);
    if (!intro) throw new Error(`level ${meta.num}: no level_intro call found`);
    if (challenges.length === 0) throw new Error(`level ${meta.num}: no challenges found`);
    levels.push({
        num: meta.num,
        name: meta.name,
        cmds: meta.cmds,
        icon: meta.icon,
        intro: { title: intro.title, desc: intro.desc, badge: intro.badge },
        tierComplete: tierCompleteInfo
            ? { tierName: tierCompleteInfo.tierName, tierDesc: tierCompleteInfo.tierDesc, nextTier: tierCompleteInfo.nextTier }
            : null,
        challenges,
    });
}

const mentor = {
    name: 'Tasmania',
    encourage: parseArrayOfLines('ROOT_ENCOURAGE'),
    correct: parseArrayOfLines('ROOT_CORRECT'),
    wrong: parseArrayOfLines('ROOT_WRONG'),
    hint: parseArrayOfLines('ROOT_HINT'),
    streak3: parseArrayOfLines('ROOT_STREAK_3'),
    streak5: parseArrayOfLines('ROOT_STREAK_5'),
    streak8: parseArrayOfLines('ROOT_STREAK_8'),
    levelComplete: parseArrayOfLines('ROOT_LEVEL_COMPLETE'),
    gameOver: parseArrayOfLines('ROOT_GAME_OVER'),
    idle: parseArrayOfLines('ROOT_IDLE'),
};

// --- sanity checks -----------------------------------------------------------

const totalChallengeCount = levels.reduce((n, l) => n + l.challenges.length, 0);
console.log(`tiers: ${tiers.length}`);
console.log(`levels: ${levels.length}`);
console.log(`total challenges: ${totalChallengeCount}`);
if (levels.length !== 90) throw new Error(`expected 90 levels, got ${levels.length}`);
if (tiers.length !== 18) throw new Error(`expected 18 tiers, got ${tiers.length}`);

mkdirSync(OUT_DIR, { recursive: true });
writeFileSync(join(OUT_DIR, 'tiers.json'), JSON.stringify(tiers, null, 2));
writeFileSync(join(OUT_DIR, 'levels.json'), JSON.stringify(levels, null, 2));
writeFileSync(join(OUT_DIR, 'mentor.json'), JSON.stringify(mentor, null, 2));
console.log(`wrote ${OUT_DIR}/{tiers,levels,mentor}.json`);
