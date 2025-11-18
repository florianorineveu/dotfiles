# dotfiles
I've got the power ! 🎶

Script helping me to import my configuration and different tools easily on a MacOS or Linux system.
Files are sorted by category for better readability.

## What's inside
- **bin/** : Directory for executables, added to `$PATH` ;
- ***category*/*.zsh** : Any files ending in `.zsh` get loaded into your environment.
- ***category*/path.zsh** : Files named `path.zsh` are loaded first to setup `$PATH`.
- ***category*/completion.zsh** : All files named `completion.zsh` are loaded last.
- ***category*/*.symlink** : All file ending in `*.symlink` gets symlinked into your `$HOME`.

## Installation
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/florianorineveu/dotfiles/main/getpower.sh)"
```

⚠️ Warning ! I highly recommend review before applying my settings. Especially if you are on MacOS.
For the *./macos/askforpassworddelay.mobileconfig* file, **you must replace the occurrences of "0ri" with your own session name**.


## Coming soon (I guess)
- Backups for existing configuration
- Generation of gitconfig.local
- Upgrade updater
- ...


