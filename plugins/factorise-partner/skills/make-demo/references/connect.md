# Part 2: Connect

In order: the account explained, the address, the account steps, the login window, then three
checks (the connection, the environment, what must be set up first). Removing the saved login is at the end. The ground rules
and "How to call the API" are in SKILL.md.

## The account

**The API role** is the one the API guide's Access and environments page names: **ApiClient**.
Go by that page for the role, also where the User Management page's list of roles doesn't show
it. It says Factorise sets the account up. For a demo, the partner makes it themselves, with
only that role. An environment whose own role list has no ApiClient runs an older Factorise,
where the API role is **Webhook**: the partner picks that one there, and you say Webhook
wherever this file says ApiClient. The account never gets both, and never another role.

**If they've connected before**, because a run folder here has a `SEND-LOG.md` or they say so,
ask only for the environment's address and run "Check the connection" below with the login
that's saved. If it answers, say you're still connected with the account they made earlier, and
skip the account and the login window. If the address is also the host that run folder's
`SEND-LOG.md` names, the environment was checked and confirmed for that build: skip the two
checks after the connection as well. The address they gave, and their yes to the plan that names
it, confirm it this time. If the connection doesn't answer, carry on here.

**Explain the account**, in these words or close to them:

> To build the demo I need to write to your Factorise environment. For that, you make a separate
> Factorise account just for me, with the role **ApiClient**. The Factorise docs describe
> ApiClient as the role for other software that works through the API, which can't log in to the
> app or open any page. That way:
>
> - you never share your own login;
> - everything I create shows in Factorise as made by this account;
> - you can block or delete the account when we're done.
>
> You'll type its password into a pop-up window on your computer, not into this chat. It's saved in
> a small file that only your user on this computer can open, and I never open it. Use a
> password you don't use anywhere else.

If they ask whether it's safe, answer in these terms and don't promise more:

- you never open that file; the program that sends the data reads the login from it directly, so
  it never shows up in this chat;
- Claude Code asks them before it runs a command on their computer, unless they've told it to
  stop asking;
- you only add records with this demo's prefix, and change only records they name; you show the
  plan before anything is sent, with old and new values for every change; you delete nothing,
  except orders you made yourself, and only when they ask. Other removing happens in the app.

End that message with two questions: the address of their environment, and whether they're a
SysAdmin or an Administrator there.

## The address

Accept an address such as `acme.factorise-suite.com`, or a link to any Factorise page, and take
its host, without a port. Repeat the host back in bold in your next message, and go on: they
confirm it once, by typing it back after the environment check below. Nothing is written before
that.

The login goes to this address with the first read. So if the host doesn't end in
`.factorise-suite.com`, say that plainly before anything else: "This isn't an address on
factorise-suite.com. Only go on if you're sure it's your Factorise environment." Go on only
after a yes to that.

## The account steps

Give the steps for their role only, from the User Management page: "Where to find" for how to
get there, and "Create a user account" for the route. A SysAdmin makes the account in User
Management. An Administrator makes it from the record of a new employee, such as "Claude demo",
made with the steps of the Employees page; it shows in their employee list. If they're neither,
an administrator of their environment needs to do this: give them the steps to pass on.

Give every step of the route, such as **Update password** before saving the employee: an account
without a saved password can't connect. With these values:

- user name `claude-demo`, or one they choose;
- role **ApiClient**, and no other. Say what to do if their list of roles has no ApiClient: pick
  Webhook, and tell you;
- a local user, Active, not Blocked;
- a password without spaces, quotes, `#` or backslashes, because the login window can't save
  those.

Ask them to say "done" when the account is saved.

## The login window

Tell the partner what to expect, for their computer. The window may open behind other windows.
Before it opens, Claude Code may ask them to allow a command: that's fine.

- **Mac:** two small windows titled "Factorise login for <host>": type the user name and click
  **Next**, then the password and click **Save**. Each closes by itself after about 2½ minutes;
  if that happens, just tell me and I'll open it again.
- **Windows:** one window titled "Windows PowerShell credential request", which mentions the
  Factorise login, asking for the user name and password together. If it's still open after a
  timeout, ask them to close it before you open a new one.

Then run, with a 6-minute timeout:

- **Mac:** `bash "${CLAUDE_PLUGIN_ROOT}/skills/make-demo/scripts/connect-mac.sh" '<host>'`
- **Windows:** `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/skills/make-demo/scripts/connect-windows.ps1" '<host>'`

It prints one line. "Saved": go on. "Cancelled", or a timeout: ask whether to try again. "Not
saved": pass on its reason in plain words and help them fix it. Only the script's own "Saved"
counts. If the partner says they typed the password before the window opened, say nothing is
saved yet, and that if they typed it anywhere else, such as a chat, they should change it in
Factorise first.

## Check the connection

Make the read-only call that the Quick start makes first.

- **Answered:** connected. Say so in one line.
- **401:** the user name or password doesn't match. Ask them to check the account is Active, not
  Blocked, and has the API role, then run the connect script again.
- **403 or 404:** the account can't use the API here. Ask them to check the role: after an upgrade
  of Factorise, an account that has only Webhook is refused until an administrator gives it
  **ApiClient** instead. If it still fails, Factorise may need to switch on the API or give the
  account access: ask them to contact their Factorise partner manager, and stop.
- **No answer:** check the address with them.

## Check the environment is meant for demos

Most of what the API creates can only be removed by hand in the app, so this is the moment to
catch a wrong environment. Read what the docs say can be read back: the plant, products, orders,
measurements, checklists, instructions, employee groups and issue setup. Try each read once. What
answers, you can see. What answers 403, 404 or 405, this account can't see here: remember that
for the rest of the session. You need to know how much is there and whether it looks real, so
count records, and don't show lists of them to the partner.

- **Empty, or only demo content:** say so. For anything you couldn't see, ask them to check in
  the app that it's empty or used only for demos.
- **In use**, with many real-looking records: say in bold that this environment seems to be in
  use, and that demo records put there can mostly only be removed by hand in the app. Recommend
  building in an environment that's kept for demos instead, and go on here only if they choose
  to.

Either way, ask them to type the host name back to confirm it's meant for demos. Continue only
when it matches exactly.

## Check what must be set up first

Some things have to be done in the app before a first load: a one-time setup step on a new
environment, or records the build names that the API can't create. Find them in the Setting up
Master Data page, the Quick start's "Before you begin", and the guide of each group the scenario
needs. From what you just read back, work out which are still missing, such as the employee
groups an issue category names, if this account can neither read nor create them.

Give the partner the steps from the docs page, with who can do them, and wait for "done". If no
read can show whether a step was done, as with synchronising Model Reflection for KPIs and
trends, don't ask whether it was: they may not know. Give the steps to check it and do it. It's
far better to catch this now than halfway through the build.

Then start part 3.

## Removing the saved login

When the partner asks, delete `~/.factorise/netrc` on a Mac, or `.factorise\netrc` in their user
folder (`USERPROFILE`) on Windows, without opening it. Tell them to block the account in
Factorise too.
