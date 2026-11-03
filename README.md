# azeemhassni/tap

Homebrew formulae for my own software.

```bash
brew install azeemhassni/tap/scribe
```

| Formula | |
|---|---|
| [scribe](Formula/scribe.rb) | [Meeting notes for macOS that never leave your Mac](https://github.com/azeemhassni/scribe) |

Install with the full `azeemhassni/tap/<formula>` name, not `brew tap` and then
a bare name. Homebrew will not load a formula from a tap it does not trust, and
spelling out the full name on an `install` command line is what tells it this
one is wanted. It records that, so `brew upgrade` works normally afterwards.

Everything here is built from source on your Mac. Nothing is bottled, so a
formula compiles on install and on every `brew upgrade`.
