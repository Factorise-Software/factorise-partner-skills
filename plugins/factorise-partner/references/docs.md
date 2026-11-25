# Getting the docs pack

Read this when the docs check in SKILL.md answers anything but "Ready", or when you need a newer
pack. The docs command, and the rules for using the docs, are in SKILL.md.

## Ask first

A browser that opens by itself and downloads a file looks wrong to anyone who didn't expect
it. So before every download, say what will happen and wait for a yes. Never run the docs
command without `check` before that yes.

**On "Needed"**, there is no pack on this computer yet. Ask in these words or close to them, as
part of your opening message:

> Before we start, I need the Factorise docs on this computer, so that what I do fits how
> Factorise really works. May I get them? This is what happens:
>
> - your browser opens docs.factorise-suite.com. If it asks, you sign in with the Microsoft
>   account you use for the Factorise docs. I never see that login;
> - a file called factorise-docs-pack.zip downloads. I unpack its text pages into a folder
>   `factorise-docs` here, and remove the zip from your Downloads folder.
>
> Shall I open your browser for this? If you'd rather do it yourself, download
> https://docs.factorise-suite.com/downloads/factorise-docs-pack.zip in your browser, leave the
> file in Downloads, and tell me when it's there.

- **Yes:** go to "Download it".
- **They download it themselves:** when they say it's there, run the docs command with `check`
  again. It picks up a pack downloaded in the last hour without opening the browser.
- **No:** say, without pressing, that you can't work without the docs, because you'd be
  guessing how Factorise works, and that they can come back to it any time. Then stop.

**On "Renew"**, there is a pack, and it's more than two weeks old. Ask in one or two lines:

> The Factorise docs on this computer are from <date>. Shall I get the current ones? Your
> browser opens docs.factorise-suite.com and a new factorise-docs-pack.zip downloads, as before.
> Or I go on with the ones I have.

With a yes, go to "Download it". With a no, go on with the pack that's there, and don't ask
again in this session.

## Download it

Say in one line that the browser opens now, and that if they see anything other than a
download, such as an error or a message that they have no access, they just tell you what it
says.

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
the docs disagree. Ask first here too, in one line: say why you want a newer pack, and that
the browser opens and a new file downloads, as before.

## If they ask about the folder

The pack is a copy for this partner only. They can delete the `factorise-docs` folder at any
time, and shouldn't share it or the folder that holds it.
