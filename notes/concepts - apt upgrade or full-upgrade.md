
TLDR
- `apt upgrade` is less aggressive, it will never remove any existing package.
- `apt full-upgrade` is more aggressive, it will make sure to "do the right thing".

simple rule of thumb.
- by default, use`apt upgrade`
- only use `apt full-upgrade` when needed

either way, make sure to run `apt autoremove` too.