# Factorise for partners

Claude skills for Factorise partners. The first one is **make-demo**: describe a demo in a
sentence, and Claude helps you shape it and then builds it in your own Factorise environment.

> "Make a demo: a dairy plant with two filling lines that struggles with changeover losses."

## What make-demo does

1. **Gets the docs.** The first time, your browser opens and downloads the Factorise docs for
   Claude to read. Sign in with your Microsoft account for the Factorise docs if it asks.
2. **Shapes your idea.** Claude asks a few short rounds of questions: who watches the demo, what
   story it tells, what the plant looks like. Every question comes with a recommended answer, so
   you can say "yes" and move on, or "just build it" at any time.
3. **Connects to your environment.** You make a Factorise account just for Claude and type its
   password into a pop-up window on your computer. Claude never sees it.
4. **Builds the demo** after you've seen the plan and said yes: plant, lines, machines, products,
   production orders, KPIs with weeks of history, a work instruction, a checklist and issues.
5. **Hands over** what's there, the few things to finish in the app, and a step-by-step demo
   script.

Later, ask Claude to change a demo you built, such as "rename line 2" or "make the bad week
worse". It shows each change, old and new, before it sends anything.

## What you need

- The **Claude desktop app** on a Mac or Windows computer, with a paid Claude plan. make-demo runs
  in its **Code** tab. On Windows, Claude Code also needs
  [Git for Windows](https://git-scm.com/download/win); the app tells you if it's missing.
- **Access to the Factorise docs** at docs.factorise-suite.com, with your own Microsoft account.
  Open that address in your browser to check. No access yet? Ask your partner manager at
  Factorise.
- A **Factorise environment for demos**, where you're a SysAdmin or Administrator, so you can
  create a user account. Claude adds records that can only be removed by hand in the app, so don't
  use an environment that's in use.

## Install

1. Open the Claude desktop app, go to the **Code** tab, choose **Local**, and open a folder for
   your demos, such as `Documents/Factorise demos`.
2. Type these two lines into the chat, one at a time:

   ```text
   /plugin marketplace add Factorise-Software/factorise-partner-skills
   ```

   ```text
   /plugin install factorise-partner@factorise
   ```

   The first line tells Claude where to find Factorise's plugins, the second installs this one.
   Each answers with a short confirmation.
3. Describe the demo you want, or type `/make-demo` and your idea.

While building, Claude asks before it runs a command on your computer. The commands look
technical: the docs download and the login window start with `bash` (Mac) or `powershell`
(Windows), and each send or read starts with `curl` and ends with your environment's address. Allow those. If a command names an
address that isn't your Factorise environment, choose No and tell Claude.

## About the account Claude uses

Claude asks you to create a Factorise user, such as `claude-demo`, with only the **Webhook** role.
Webhook is Factorise's role for other software that sends data in, for example machines. It can't
log in to the app or open any page. So you never share your own login, everything Claude creates
is marked as made by that account, and you can block or delete it when you're done.

The password goes from a pop-up window straight into a small file on your computer that only your
user can open. It never goes into the chat, and Claude never sees it. The file isn't encrypted, so
use a password you use nowhere else. To remove it, ask Claude to "remove my saved Factorise
login", and block the account in Factorise.

## About the docs

The Factorise docs are for customers and partners only, so they aren't part of this plugin.
Claude opens the download in your own browser, and you sign in there as you always do. Claude
never sees that login. The pages are saved in a folder `factorise-docs` inside your demos folder.
Don't share that folder. You can delete it at any time: Claude asks for a new download when it
needs one.

## Help

Questions, or a demo that didn't come out the way you expected: contact your partner manager at
Factorise Software. It helps to send the run folder Claude made, `factorise-demo-…`. It holds what
was sent, never your password.
