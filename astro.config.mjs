// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://hardlygospel.github.io',
	base: '/bashquest',
	integrations: [
		starlight({
			title: 'BashQuest',
			description:
				'Interactive terminal game teaching Linux and Bash: 86 levels from ls to kernel builds, Docker, git, tmux, and desktop ricing',
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/hardlygospel/bashquest' },
			],
			customCss: ['./src/styles/custom.css'],
			sidebar: [
				{
					label: 'Get Started',
					items: [
						{ label: 'Overview', slug: 'getting-started' },
						{ label: 'Installation', slug: 'getting-started/installation' },
						{ label: 'How to Play', slug: 'getting-started/how-to-play' },
					],
				},
				{
					label: 'Levels',
					items: [
						{ label: 'Overview', slug: 'levels' },
						{ label: 'Levels 1–4: Beginner', slug: 'levels/01-beginner' },
						{ label: 'Levels 5–8: Intermediate', slug: 'levels/02-intermediate' },
						{ label: 'Levels 9–14: Pipes & Patterns', slug: 'levels/03-pipes-and-patterns' },
						{ label: 'Levels 15–20: Power Tools', slug: 'levels/04-power-tools' },
						{ label: 'Levels 21–28: Expert', slug: 'levels/05-expert' },
						{ label: 'Levels 29–34: Storage & Filesystems', slug: 'levels/06-storage-filesystems' },
						{ label: 'Levels 35–39: File Editing & Sharing', slug: 'levels/07-file-editing-sharing' },
						{ label: 'Levels 40–45: Networking', slug: 'levels/08-networking' },
						{ label: 'Levels 46–49: Storage Networking & SAN', slug: 'levels/09-storage-networking-san' },
						{ label: 'Levels 50–54: Boot Process & Kernel', slug: 'levels/10-boot-kernel' },
						{ label: 'Levels 55–57: Media Management', slug: 'levels/11-media-management' },
						{ label: 'Levels 58–61: Desktop Ricing', slug: 'levels/12-desktop-ricing' },
						{ label: 'Levels 62–67: Git & Version Control', slug: 'levels/13-git-version-control' },
						{ label: 'Levels 68–73: Docker & Containers', slug: 'levels/14-docker-containers' },
						{ label: 'Levels 74–77: Universal Packages', slug: 'levels/15-universal-packages' },
						{ label: 'Levels 78–81: Terminal Multiplexing', slug: 'levels/16-terminal-multiplexing' },
						{ label: 'Levels 82–86: TUI Toolbelt', slug: 'levels/17-tui-toolbelt' },
					],
				},
				{
					label: 'Reference',
					items: [{ label: 'Command Reference', slug: 'reference' }],
				},
			],
		}),
	],
});
