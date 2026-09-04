# alexcoll/homebrew-tap

Homebrew tap for tools by [Alex Collier](https://github.com/alexcoll).

## Installing

```bash
brew tap alexcoll/tap
brew install bandcamp-dl-rb
```

The `bandcamp_dl_rb` command will be on your `PATH`.

## Updating

```bash
brew update
brew upgrade bandcamp-dl-rb
```

## Formula

| Formula                    | Description                                                    |
|----------------------------|----------------------------------------------------------------|
| `bandcamp-dl-rb`           | Download your Bandcamp purchases and organize them for Plex     |

## How it works

The formulae install the underlying Ruby gem on your machine (building native
extensions as needed), isolated into the keg with `GEM_HOME=libexec`, so they
don't interfere with your system Ruby or other gems.

## Checking

Source: https://github.com/alexcoll/bandcamp-dl-rb

License: GPL-3.0-only