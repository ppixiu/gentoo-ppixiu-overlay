---
name: gentoo-overlay-package-maintenance
description: "Maintain source-based Gentoo overlay packages: inspect upstream projects, write and update ebuilds and metadata, generate Manifests, run QA/build checks, and prepare reviewable commits."
---

# Gentoo Overlay Package Maintenance

Use this skill when adding, updating, or removing packages in a Gentoo ebuild
overlay. Follow the repository's `AGENTS.md` first; these are the reusable
decisions that apply across overlays.

## Discover the upstream

- Read the upstream build files, packaging notes, supported platforms, runtime
  files, and license. Treat the upstream repository, not a package index, as
  the source of truth.
- Prefer a release or tag when one exists. If the project has no named
  versions and the overlay convention permits date versions, derive the
  version from the selected commit timestamp, pin the immutable commit hash,
  and document why the version is date-based.
- Derive dependencies from actual build-system probes and installed files.
  Map them to Gentoo atoms, distinguish build-time and runtime needs, and
  expose optional upstream features as USE flags only when they have a useful
  Gentoo-level meaning.

## Write the package

- Use the newest supported EAPI and existing local eclass patterns.
- Keep `KEYWORDS` testing-only (`~amd64`, `~arm64`, etc.) until that
  architecture has been built and tested. Remove an architecture that cannot
  be validated rather than claiming support.
- Add `metadata.xml` with an actual maintainer, upstream remote IDs, a useful
  description, and a description for every local USE flag. Use the upstream
  license; add a repository license file and `RESTRICT` rules when Gentoo does
  not already provide that license.
- Keep the package directory complete: ebuild, `metadata.xml`, and its
  `Manifest` belong in the same change. Do not add generated cache files.
- For source archives without Git metadata, preserve a meaningful revision in
  generated version output through a small, documented `src_prepare` patch if
  the project otherwise reports `unknown`.

## Validate

Install the current tooling (`dev-util/pkgdev`, which brings `pkgcheck`) and
run the repository's required checks:

```sh
pkgdev manifest
pkgcheck scan --commits --net
```

Build the package with the declared USE flags and test every declared keyword
architecture. Verify installed executables, session files, services, configs,
and documentation, not only compilation. If `pkgdev` or `pkgcheck` is
unavailable, use the best available Portage checks as a temporary fallback,
but say explicitly which required checks were not run.

If the repository has an autobump configuration (for example
`.github/workflows/overlay.toml`), register the package there only when the
upstream version model and dependency bundle are compatible with automation.
Commit-date snapshots and packages whose dependencies change with each commit
usually need a commented entry or manual maintenance instead.

## Commit and hand off

- Keep all files required for one package change in the same commit. Use
  `pkgdev commit` where available and follow the repository's message format,
  such as `category/package: add version, drop old version`.
- Review the staged diff, run `git diff --cached --check`, remove temporary
  source/build directories created for testing, and report any untested
  architectures or unavailable QA tools.

Reference: the gentoo-zh overlay contribution guide at
<https://gentoozh.org/overlay-contributing/>.
