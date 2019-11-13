# Contributing to Mia-Platform Terraform GKE Module

## Commit Style

This project is following the guidelines of [Conventional Commit] for the commit messages, so you are encouraged to read
them first and trying to follow them as much as possible, we can always fix them during the Merge Request process.

### Revert

If the commit reverts a previous commit, it should begin with `revert:`, followed by the header of the reverted commit.
In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit being reverted.

### Type

Must be one of the following:

- **ci**: Changes to our CI configuration files and scripts
- **docs**: Documentation only changes (add new sections, fixing typos, etc)
- **feat**: A new feature
- **fix**: A bug fix
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the templates features (indentation, formatting, missing quotes, etc)
- **test**: Adding missing tests or correcting existing tests

## Coding Style

The project contains an [`.editorconfig`](/.editorconfig) file for setting up your editor if you have installed the
appropriate [plugin].

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](/CODE_OF_CONDUCT.md), please read it and follow it
before contributing. If you find someone that is not respecting it please report its behaviour.

[Conventional Commit]: https://www.conventionalcommits.org (A specification for adding human and machine readable meaning to commit messages)
[plugin]: https://editorconfig.org/#download (EditorConfig is a file format and collection of text editor plugins for maintaining consistent coding styles between different editors and IDEs.)
