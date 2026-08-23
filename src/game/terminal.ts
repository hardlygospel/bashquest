// Wires the Engine's screen/line output to an xterm.js Terminal, and turns
// raw xterm key events into line-buffered input. xterm.js gives you
// keystrokes, not a readline, so this is BashQuest's own minimal line
// editor: printable chars, backspace, and Enter.

import { Terminal } from '@xterm/xterm';
import { FitAddon } from '@xterm/addon-fit';
import { Engine, type Emit } from './engine';

const PROMPT = 'bashquest@web:~$ ';

const CODE_BACKSPACE = 0x7f;
const CODE_CTRL_H = 0x08;
const CODE_CTRL_C = 0x03;
const CODE_SPACE = 0x20;

export function mountGame(container: HTMLElement) {
    const term = new Terminal({
        cursorBlink: true,
        fontFamily: '"SF Mono", "Fira Code", Menlo, Consolas, monospace',
        fontSize: 14,
        theme: {
            background: '#0b1120',
            foreground: '#d1f7ff',
            cursor: '#06b6d4',
            selectionBackground: '#164e63',
        },
    });
    const fit = new FitAddon();
    term.loadAddon(fit);
    term.open(container);
    fit.fit();
    window.addEventListener('resize', () => fit.fit());

    const engine = new Engine();
    let buffer = '';

    function writeWrapped(text: string) {
        // xterm.js does not soft-wrap on word boundaries; do it ourselves at
        // the current column count so long challenge descriptions stay readable.
        const cols = Math.max(term.cols - 2, 20);
        for (const rawLine of text.split('\n')) {
            if (rawLine.length === 0) {
                term.writeln('');
                continue;
            }
            let line = rawLine;
            while (line.length > cols) {
                let cut = line.lastIndexOf(' ', cols);
                if (cut <= 0) cut = cols;
                term.writeln(line.slice(0, cut));
                line = line.slice(cut).trimStart();
            }
            term.writeln(line);
        }
    }

    function renderPrompt() {
        term.write(`\r\n${PROMPT}`);
    }

    engine.onEmit = (e: Emit) => {
        if (e.kind === 'screen') {
            term.write('\x1b[2J\x1b[H'); // clear + home, like clear_screen in bashquest.sh
            term.writeln('\x1b[1;36m═══════════════════════════════════════════════════════════════\x1b[0m');
            for (const line of e.text) writeWrapped(line);
            term.writeln('\x1b[1;36m═══════════════════════════════════════════════════════════════\x1b[0m');
        } else {
            term.writeln('');
            for (const line of e.text) writeWrapped(line);
        }
        renderPrompt();
    };

    term.onData((data) => {
        for (const ch of data) {
            const code = ch.charCodeAt(0);

            if (ch === '\r') {
                term.write('\r\n');
                const submitted = buffer;
                buffer = '';
                engine.handleInput(submitted);
                return;
            }

            if (code === CODE_BACKSPACE || code === CODE_CTRL_H) {
                if (buffer.length > 0) {
                    buffer = buffer.slice(0, -1);
                    term.write('\b \b');
                }
                continue;
            }

            if (code === CODE_CTRL_C) {
                buffer = '';
                term.write('^C');
                renderPrompt();
                continue;
            }

            if (code >= CODE_SPACE && code !== CODE_BACKSPACE) {
                buffer += ch;
                term.write(ch);
            }
        }
    });

    engine.start();
    term.focus();

    return { term, engine };
}
