# Connect

In order: which environment, the account, the login window, then three checks (the connection,
what the environment holds, what must be set up first). Saved logins are at the end. The ground
rules, "How to call the API" and the connect command are in SKILL.md.

## Which environment

Run the connect command with `list`. It prints the addresses a login is saved for on this
computer, and nothing else.

- **The partner named an address**, or gave a link to any Factorise page: take its host, such
  as `acme.factorise-suite.com`. An address that is a number, such as `10.20.30.40`, or that
  needs a port or plain http, can't be used: say so, ask whether the environment has an https
  name, and never try a variant of what they gave.
- **They named none, and logins are saved:** ask which environment, and offer the saved ones by
  address, next to "another one".
- **They named none, and none is saved:** ask for the address of their Factorise environment.
- **They gave a name, not an address**, such as "Acme's test environment": if one saved address
  clearly fits, propose it and let them say yes. Otherwise ask for the address. Never make one up.

Repeat the host back in bold in your next message, and go on. Nothing is written before they
confirm it, after the environment check below.

The login goes to this address with the first read. So if the host doesn't end in
`.factorise-suite.com`, say that plainly before anything else: "This isn't an address on
factorise-suite.com. Only go on if you're sure it's your Factorise environment." Go on only
after a yes to that. This skill connects over https only, because over plain http the login
would travel unprotected.

## The account

- **A login is saved for this host:** don't ask about the account or explain it. Run "Check the
  connection" below. If it answers, say you're still connected with the account they made
  earlier. If it doesn't, the login changed: say so, and go to "The login window".
- **None is saved:** ask one plain question, and nothing else yet: is there already a separate
  Factorise account for you, for Claude, in this environment? With a yes, go to "The login
  window". With a no, or when they aren't sure, the next section. Run no read before the
  connect command has said "Saved": without a saved login the command only gives an error.

## They have no account yet

**The API role** is the one the API guide's Access and environments page names: **ApiClient**.
Go by that page for the role, also where the User Management page's list of roles doesn't show
it. It says Factorise sets the account up. Here, an administrator of the environment makes it,
with only that role: the partner, if they're one. An environment whose own role list has no
ApiClient runs an older Factorise, where the API role is **Webhook**: they pick that one there,
and you say Webhook wherever this file says ApiClient. The account never gets both, and never
another role.

**One message holds all of it:** why the account, then the steps to make it, then the request to
say "done". Never say you'll explain how and leave the steps for later: read the pages first, and
send the explanation and the steps together.

Why the account, in these words or close to them:

> To work in your Factorise environment I need to write to it. For that, you make a separate
> Factorise account just for me, with the role **ApiClient**. The Factorise docs describe
> ApiClient as the role for other software that works through the API, which can't log in to the
> app or open any page. That way:
>
> - you never share your own login;
> - everything I create or change shows in Factorise as done by this account;
> - you can block or delete the account when we're done.
>
> You'll type its password into a pop-up window on your computer, not into this chat. It's saved in
> a small file that only your user on this computer can open, and I never open it. Use a
> password you don't use anywhere else.

The steps come from the User Management page: "Where to find" for how to get there, and "Create
a user account" for the route. Don't ask which kind of administrator they are. Give the route
from the record of a new employee, such as "Claude", as numbered steps: that page calls it the
normal way, and it works for an Administrator and a SysAdmin. Where that page and the Employees
page differ on a step, give the one that makes sure the password is saved. The employee is made with the
steps of the Employees page, and shows in their employee list. Under the steps, add in a line or
two that a SysAdmin can make the account in User Management instead, and how. If they turn out
to be neither, an administrator of the environment needs to do this: give them the steps to
pass on, and wait. That administrator gives the partner the password the way they'd hand over
any password, never through this chat, and the partner types it into the login window.

Give every step of the route, such as **Update password** before saving the employee: an account
without a saved password can't connect. With these values:

- the user name SKILL.md suggests, or one they choose;
- role **ApiClient**, and no other. Say what to do if their list of roles has no ApiClient: pick
  Webhook, and tell you;
- a local user, Active, not Blocked;
- a password without spaces, quotes, `#` or backslashes, because the login window can't save
  those.

End with: say "done" when the account is saved. Then go to "The login window".

If they ask whether it's safe, answer in these terms and don't promise more:

- you never open that file; the program that sends the data reads the login from it directly, so
  it never shows up in this chat;
- the login is only ever sent to the address it was saved for, over https;
- Claude Code asks them before it runs a command on their computer, unless they've told it to
  stop asking;
- you show the plan before anything is sent, with old and new values for every change, and
  change only records they name; you delete nothing, except orders you sent yourself, and only
  when they ask. Other removing happens in the app;
- the file isn't encrypted, so the account should have only this one role and a password used
  nowhere else, and they can block it in Factorise at any moment.

## The login window

Tell the partner what to expect, for their computer. The window may open behind other windows.
Before it opens, Claude Code may ask them to allow a command: that's fine.

- **Mac:** two small windows titled "Factorise login for <host>": type the user name and click
  **Next**, then the password and click **Save**. Each closes by itself after about 2½ minutes;
  if that happens, just tell me and I'll open it again.
- **Windows:** one window titled "Factorise login for <host>", asking for the user name and
  password together: type both and click **Save**. It closes by itself after about 5 minutes;
  if that happens, just tell me and I'll open it again.

Then run the connect command with the host, with a 6-minute timeout.

It prints one line. "Saved": go on. "Cancelled", or a timeout: ask whether to try again. If it
comes back "Cancelled" within seconds and they say they saw no window, don't keep opening it:
treat it as a window that couldn't open. "Not saved" or "Not done": pass on its reason in plain
words and help them fix it. If the window couldn't open, ask them to close the Claude desktop
app, open it again and say "go on": then try once more, and stop if it fails again. Only the script's own "Saved"
counts. If the partner says they typed the password before the window opened, say nothing is
saved yet, and that if they typed it anywhere else, such as a chat, they should change it in
Factorise first. If they've lost the password, an administrator sets a new one for the account
in Factorise, and you open the login window again: you can't look it up.

## Check the connection

Make the read-only call that the Quick start makes first, with the command in "How to call the
API", not the one on that page.

- **Answered:** connected. Say so in one line.
- **401:** the user name or password doesn't match. Ask them to check the account is Active, not
  Blocked, and has the API role, then run the connect command again.
- **403 or 404:** the account can't use the API here. Ask them to check the role: after an upgrade
  of Factorise, an account that has only Webhook is refused until an administrator gives it
  **ApiClient** instead. If it still fails, Factorise may need to switch on the API or give the
  account access: ask them to contact their Factorise partner manager, and stop.
- **No answer:** check the address with them.

**If the connection doesn't come about**, say plainly that you can't see or change the
environment yet. You may still read a file they gave you and tell them what it holds and what
you'd need to know, but show no plan and don't ask to send anything before you've connected
and read.

## See what the environment holds

Most of what the API creates can only be removed by hand in the app, so this is the moment to
catch a wrong environment. Read what the docs say can be read back: the plant and its lines and
machines, products, orders, measurements, checklists, instructions, employee groups and issue
setup. REST endpoints lists what answers a read. Try each read once. What
answers, you can see. What answers 403, 404 or 405, this account can't see here: remember that
for the rest of the session. The answers are in `factorise-reads`: the plan starts from them. If
`factorise-custom-api` in the current working folder has a folder for this host, see
custom-api.md.

Tell the partner in two or three lines what you see, so they recognise the environment: the
name of its site or sites, and roughly how much is there, such as "one site, Acme Rotterdam,
with 3 lines, about 240 products and orders up to last week". Count records, and don't show
lists of them. For anything you couldn't see, say so.

**When the request only reads**, such as a question about what the environment holds, that
summary is the start of your answer: ask nothing more. The rest of this section comes when
they first ask for something that is sent.

Then do what SKILL.md says under "After connecting", and ask them to type the host name back to
confirm it's the environment they mean. Continue only when the address they type is exactly
that host. A company often
has a test environment next to the live one, with the same plant in it: only the address tells
them apart.

**Skip the summary and the typing** when a run folder in the current working folder has a
`SEND-LOG.md` that names this host: the environment was confirmed for that run. The address
they gave, and their yes to a plan that names it, confirm it this time. Still read what the
plan needs.

## Check what must be set up first

Some things have to be done in the app before a load: a one-time setup step on a new
environment, or records the request needs that the API can't create. Check only what this
request touches. Find them in the Setting up
Master Data page, the Quick start's "Before you begin", and the guide of each group the plan
needs. From what you just read back, work out which are still missing.

Give the partner the steps from the docs page, with who can do them, and wait for "done". If no
read can show whether a step was done, as with synchronising Model Reflection for KPIs and
trends, don't ask whether it was: they may not know. Give the steps to check it and do it, in
plain words. It's far better to catch this now than halfway through a load. If they can't do
the step themselves, as in a customer's environment, go on, and say in the plan which part
Factorise may refuse until it's done.

Then go on with the part after connecting, as SKILL.md lists them.

## Saved logins

- **"Which environments am I connected to?"** Run the connect command with `list`, and give the
  addresses.
- **Remove a login:** their request is the yes. Run the connect command with `forget` and the
  host. It removes that environment's login and leaves the others. To remove all, do that for
  each address `list` gives. When a login was removed, tell them to block the account in
  Factorise too: that's what really ends its access.
