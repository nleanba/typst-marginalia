# Marginalia
_Configurable margin-notes with smart positioning and matching wide blocks for Typst_

> [!NOTE]
> This is the readme file for the project repository and contains more development-oriented info.
> 
> [A more friendly readme for the published package can be found on Typst Universe.](https://typst.app/universe/package/marginalia).

## Docs

- [Current Published Version: v0.2.4](https://github.com/nleanba/typst-marginalia/blob/v0.2.4/Marginalia.pdf?raw=true)

- [Working Copy](https://github.com/nleanba/typst-marginalia/blob/main/Marginalia.pdf?raw=true)

  [![first page of the documentation](https://github.com/nleanba/typst-marginalia/raw/refs/heads/main/preview.svg)](https://github.com/nleanba/typst-marginalia/blob/main/Marginalia.pdf)


## Development

- Remember to `typst watch main.typ Marginalia.pdf` and `typst watch main.typ preview.svg --pages 1` while development to make these stay current.

### Tests

Use `tt run` to check for test regressions.

The tests don’t necessarily represent _ideal_ behavior. If the behavior improves, they should be updated.
Use `tt update <name>` to update the reference of a test, and `tt new <name>` to create a new test.

> [!IMPORTANT]
> Note that the tests need to have a modified `numbering` style as the GitHub CI runner does not have Inter.

### New Versions

1. Replace all occurrences of the old version number with the new one, except where it refers to specific changes made in that version.
  - Also replace placeholder `?.?.?` with the new number.
2. Commit and create a tagged release.
3. “Sync Fork” in https://github.com/nleanba/typst-packages
4. In `nleanba/typst-packages`, Pull and create new branch from main
5. Create folder `packages/preview/marginalia/<VERSION>` and copy `LICENSE`, `README.md`, `lib.typ`, and `typst.toml`
6. Commit and create a pull-request to `typst/packages`.
7. `main.typ`: reset `#let VERSION = "?.?.?"`.

### Contributing

This is a personal project of mine.
I welcome bug reports and feature requests, but I don’t consider this a community project and have no real interest in reviewing pull-requests etc.

## Feedback
Have you encountered a bug? [Please report it as an issue.](https://github.com/nleanba/typst-marginalia/issues)

Has this package been useful to you? [I am always happy when someone gives me a ~~sticker~~ star⭐](https://github.com/nleanba/typst-marginalia)