---
title: "Levels 62–67: Git & Version Control"
description: "Init and identity, staging and committing, history and diffs, branching and merging, remotes, and undoing mistakes safely."
---

## Level 62: Git Basics

| Command | What it does |
|---|---|
| `git init` | Turn the current directory into a git repository |
| `git config --global user.name "You"` | Set your global commit identity |
| `git config --global user.email "you@example.com"` | Set your global commit email |
| `git status` | See what's changed, staged, or untracked |
| `git status -s` | The same, in compact one-line-per-file form |

---

## Level 63: Staging & Committing

> *Git doesn't commit your whole working directory blindly. There's a staging area in between: a deliberate list of exactly what goes into the next commit.*

| Command | What it does |
|---|---|
| `git add file` | Stage one file |
| `git add .` (or `-A`) | Stage everything |
| `git commit -m "message"` | Commit staged changes |
| `git commit -am "message"` | Stage every tracked, modified file and commit, in one step |
| `git diff --staged` | Review exactly what's queued for the next commit |

---

## Level 64: History & Diffs

| Command | What it does |
|---|---|
| `git log` | Full commit history |
| `git log --oneline` | Compact, one line per commit |
| `git diff` | Unstaged working-directory changes |
| `git show <hash>` | Full details of one commit |
| `git blame file` | Who last changed each line, and when |

---

## Level 65: Branching & Merging

> *Branches are how git lets you work on something new without touching what already works.*

| Command | What it does |
|---|---|
| `git branch` | List branches |
| `git branch name` | Create a branch (doesn't switch to it) |
| `git switch name` (or `git checkout name`) | Switch to an existing branch |
| `git switch -c name` (or `git checkout -b name`) | Create and switch in one step |
| `git merge name` | Merge a branch into the current one |
| `git branch -d name` | Delete a branch that's already merged |

---

## Level 66: Remotes

| Command | What it does |
|---|---|
| `git clone url` | Copy a remote repo locally |
| `git remote add origin url` | Register a remote under a short name |
| `git remote -v` | List remotes and their URLs |
| `git push -u origin main` | Push and link the upstream tracking branch |
| `git pull` | Fetch and merge in one step |
| `git fetch` | Download without touching your working branch |

---

## Level 67: Undo & Ignore

> *Every mistake has a real, specific fix, and using the wrong one on shared history is exactly how a rescue turns into a real incident.*

| Command | What it does |
|---|---|
| `git restore --staged file` | Unstage a file, keep the edits |
| `git restore file` | Discard uncommitted edits entirely |
| `git reset --soft HEAD~1` | Undo the last commit, keep it staged |
| `git revert HEAD` | Undo a commit safely, with a new commit (fine for already-pushed history) |
| `git stash` | Shelve uncommitted changes to switch branches cleanly |
| `echo pattern >> .gitignore` | Stop tracking matching paths forever |

:::tip
`git reset` rewrites history and is fine on commits nobody else has seen. `git revert` doesn't rewrite anything, it just adds a new commit undoing the old one, which is the safe choice the moment something's already been pushed and possibly pulled by someone else.
:::

---

Finish this level and move on to [Docker & Containers](/bashquest/levels/14-docker-containers/): images, running containers, building your own, and cleaning up after them.
