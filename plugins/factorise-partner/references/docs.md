# Getting the docs pack

Read this when the docs check in SKILL.md answers anything but "Ready", or when you need a newer
pack. The docs command, and the rules for using the docs, are in SKILL.md.

## Download it

Tell the partner what to expect, in these words or close to them:

> First I need the Factorise docs, so what I do fits how Factorise really works. Your browser
> opens now. Sign in with the Microsoft account you use for the Factorise docs, if it asks. A
> file called factorise-docs-pack downloads by itself: you don't need to open it, and I tidy it
> away. I never see your login. If you see anything other than a download, such as an error or
> a message that you have no access, just tell me what it says.

Then run the docs command without `check`, with a 4-minute timeout. It prints one line:

- **"Ready: docs pack of <date>":** go on, and don't mention the docs again unless they ask. If
  the line adds that a new one didn't arrive, say in one line that the docs on this computer may
  be a little behind, and that you'll try again next time.
- **"Not downloaded":** ask what they saw in the browser, and go by their answer. Never open or
  read the sign-in page yourself.
  - *Still signing in, or the file is there now:* run the command again. It picks up a pack
    downloaded in the last hour without opening the browser.
  - *The browser asked where to save, or saved somewhere else:* ask them to put the file in
    their Downloads folder or the current working folder, then run it again.
  - *No access, or no account for the docs:* say "Your account doesn't have access to the
    Factorise docs yet. Your partner manager at Factorise can arrange that. Tell me when it's
    done and we'll pick up here." and stop.
  - *Anything else:* say the docs pack couldn't be reached, ask them to try again later or
    contact their partner manager, and stop.
- **"Not ready":** pass on its reason in plain words. A file or folder it names is the partner's
  to move or delete: never move, delete, read or unpack it yourself. Run the command again when
  they've done it. If it says this version can't read the pack, ask them to update the plugin,
  and stop.

Never go on without the docs.

## A newer pack

To replace a pack that's there, run the docs command with `refresh` in place of `check`. Do
this at most once in a session, when the index has no page on something or the environment and
the docs disagree.

## If they ask about the folder

The pack is a copy for this partner only. They can delete the `factorise-docs` folder at any
time, and shouldn't share it or the folder that holds it.
