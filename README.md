# homebrew-tools

Homebrew tap for VimCommando command-line tools.

## Use

```bash
brew tap VimCommando/tools
brew install espipe
brew install kibob
```

## Formulae

- [`espipe`](https://github.com/VimCommando/espipe) pipes NDJSON, JSON, or CSV documents into Elasticsearch from the command line. It is useful for quick indexing, loading test data, and simple document ingestion workflows without building a custom importer.
- [`kibob`](https://github.com/VimCommando/kibana-object-manager) is a Git-inspired CLI for managing Kibana saved objects. It helps you move dashboards and related assets through export, import, and versioned workflow steps more cleanly.

## Bottles

Copy `.env.example` to `.env` and set `LINUX_SSH_HOST` to a Linux x86_64 host with SSH certificate-based auth and Podman configured.

```bash
scripts/build-bottles.sh
```

The script builds Apple Silicon bottles locally, builds Linux x86_64 bottles remotely inside `homebrew/brew` with Podman, writes artifacts to `dist/bottles`, and merges the generated bottle blocks into the formulae. Upload the generated `*.bottle*.tar.gz` files to the release URL configured by `BOTTLE_ROOT_URL`.
