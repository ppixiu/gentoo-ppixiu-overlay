# gentoo-ppixiu

Personal Gentoo ebuild overlay for `app-*` packages and other packages that
are useful on my systems.

## Repository layout

Packages follow the standard Gentoo tree layout:

```text
app-category/
└── package-name/
    ├── Manifest
    ├── metadata.xml
    └── package-name-version.ebuild
```

The overlay uses the Gentoo repository as its master and thin Manifests for
Git-based development. Add a `profiles/categories` entry only if a package
uses a category that does not already exist in the Gentoo repository.

## Enable locally

Create `/etc/portage/repos.conf/gentoo-ppixiu.conf` with:

```ini
[gentoo-ppixiu]
location = /home/ppixiu/WorkDir/Codes/gentoo-ppixiu
```

Add a numeric `priority` if this overlay must override packages from another
repository. The default repository named `gentoo` must remain configured
separately.

Verify that Portage sees the repository:

```sh
eselect repository list
```

## Developing packages

For a new package, add an ebuild and `metadata.xml` under its category and
generate its Manifest with `pkgdev manifest` (or `ebuild <file>.ebuild
manifest`). Run `pkgcheck scan` before committing changes.
