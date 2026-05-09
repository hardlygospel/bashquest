---
title: How to Play
parent: Getting Started
nav_order: 2
---

# How to Play
{: .no_toc }

<details open markdown="block">
  <summary>Contents</summary>
  {: .text-delta }
- TOC
{:toc}
</details>

---

## Account System

When you first launch BashQuest, you'll see a login screen styled after a real terminal login prompt.

**Create an account:**
- Choose a username (no spaces)
- Choose a password (minimum 4 characters)
- Your progress is saved to `~/.bashquest/yourusername.save`

**Login:**
- Username and password are checked against `~/.bashquest/users.db`
- Three failed attempts locks you out of that session (re-run the script to try again)
- Multiple players can have accounts on the same machine

---

## The Interface

Once logged in you'll see the main menu and a persistent **status bar** showing:

```
👤 alice   ⭐ Level 3   ✨ XP: 85   ❤  Lives: 3
```

| Element | Meaning |
|---|---|
| **Level** | Your current level (1–28) |
| **XP** | Total experience points earned |
| **Lives** | Remaining lives (start with 3, replenish on login) |

---

## Answering Challenges

Each challenge shows:
1. A description of the task (what to do and **why**)
2. A fake terminal prompt for your answer

```
bashquest@terminal:~$ _
```

Type your command and press Enter. The game checks whether your answer is correct using pattern matching — it accepts equivalent valid answers, not just one exact string.

---

## Special Commands

During any challenge, you can type:

| Command | Effect |
|---|---|
| `hint` | Shows a detailed hint for the current challenge |
| `skip` | Skips the challenge — costs 1 life |

---

## Lives & Game Over

- You start with **3 lives**
- Each wrong answer costs 1 life
- Skipping a challenge costs 1 life
- Reaching 0 lives triggers **Game Over** — your XP is kept but lives reset to 3

---

## XP & Scoring

XP is awarded for each correct answer. More difficult challenges give more XP:

| Difficulty | XP |
|---|---|
| Basic | 10–15 |
| Standard | 20–25 |
| Advanced | 25–30 |

XP accumulates permanently and is used for the **Leaderboard** ranking.

---

## Levels & Progression

- Levels unlock sequentially — complete level N to unlock N+1
- Use **Level Select** from the main menu to replay any unlocked level
- Replaying a completed level does not reduce your saved progress level

---

## Leaderboard

The leaderboard ranks all player accounts on the machine by total XP. Access it from the main menu — option 4.

---

## Tips

{: .tip }
Always read the challenge description carefully — it explains **why** the command exists, not just what to type. That context is the actual learning.

{: .tip }
If you're stuck, use `hint` before `skip`. Hints are free. Skips cost a life.

{: .note }
The game validates command **syntax and intent**, not exact strings. `ls -la` and `ls -al` are both accepted where either is correct.
