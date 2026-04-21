# homebrew-tools

Homebrew tap for VimCommando command-line tools.

## Use

```bash
brew tap VimCommando/tools
brew install espipe
```

## Formulae

- `espipe`

## Notes

The initial `espipe` formula points at a specific public Git commit archive so the tap is usable before the first release tag is published.

Once `espipe` has a tagged release, update `Formula/espipe.rb` to use the versioned tag tarball URL and its corresponding `sha256`.
