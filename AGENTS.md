# gentoo-ppixiu Agent Guide

## Repository identity

- This is the personal `gentoo-ppixiu` Gentoo overlay.
- The repository name is `gentoo-ppixiu`; its master repository is `gentoo`.
- The canonical repository metadata is in `metadata/layout.conf` and
  `profiles/repo_name`.
- Git uses branch `main` and thin Manifests. Package changes should include
  their `Manifest` in the same commit as the ebuild and metadata.
- Package categories should follow the normal Gentoo tree. Add
  `profiles/categories` only for a category that is not present in Gentoo.

## Package workflow

For every package change:

1. Inspect the upstream homepage, source repository, build files, packaging
   documentation, license, latest version or commit, supported architectures,
   and installed file layout.
2. Use EAPI 8 and local Gentoo eclass patterns. Keep dependencies grounded in
   the upstream build system; expose meaningful optional features as USE flags
   and document them in `metadata.xml`.
3. Add an actual maintainer to `metadata.xml`, an upstream `remote-id`, a
   useful description, and descriptions for all package-local USE flags.
4. Use testing keywords only (`~amd64`, `~arm64`, etc.). Every declared
   architecture must be built and tested before it is advertised.
5. Generate the thin Manifest with `pkgdev manifest`.
6. Run `pkgcheck scan --commits --net` and build/install the package with its
   declared USE flags. Verify runtime files such as launchers, desktop/session
   entries, systemd units, configs, and docs.
7. Review `git diff --cached --check`, clean temporary test artifacts, and use
   `pkgdev commit` or the repository's established commit format.

The upstream Gentoo-zh contribution guide is the policy reference:
<https://gentoozh.org/overlay-contributing/>. Its important rules include
testing-only keywords, maintainer metadata, thin Manifests, per-keyword
testing, and `pkgcheck scan --commits --net` before review.

## Current package state

This personal repository currently has no `overlay.toml` or autobump workflow.
Do not invent an automation entry. If automated version updates are added,
document the workflow and register only packages whose upstream version and
dependency model can be updated safely.

## Skill

The reusable packaging workflow is in
`skills/gentoo-overlay-package-maintenance/SKILL.md`. Read it for general
upstream inspection, dependency mapping, metadata, Manifest, QA, architecture,
and commit guidance; this file supplies the repository-specific constraints.
