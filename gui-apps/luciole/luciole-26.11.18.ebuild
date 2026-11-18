# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit meson python-any-r1 xdg

DESCRIPTION="Native Wayland file manager with tabs, split views and file previews"
HOMEPAGE="https://github.com/noctalia-dev/luciole"

# Upstream has no releases or tags; use the selected commit's UTC date.
COMMIT="4f971440464ecc773160aa28b9950c6200f55f63"
SRC_URI="https://github.com/noctalia-dev/luciole/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="7zip +http +pdf samba +sftp test +video zeroconf"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/libarchive:=
	app-arch/xz-utils
	>=dev-cpp/tomlplusplus-3.4:0=
	>=dev-libs/glib-2.76:2
	>=dev-libs/libxml2-2.9:2=
	dev-libs/wayland
	gnome-base/librsvg:2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/harfbuzz:=
	media-libs/libglvnd
	media-libs/libpng:0=
	>=net-misc/curl-7.85.0
	sys-apps/acl
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.42:2
	x11-libs/libxkbcommon
	>=x11-libs/pango-1.50
"
DEPEND="
	${COMMON_DEPEND}
	dev-cpp/nlohmann_json
	>=dev-libs/stb-20240201
	test? ( media-libs/libwebp )
"
RDEPEND="
	${COMMON_DEPEND}
	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs[http?,samba?,sftp?,zeroconf?]
	sys-apps/dbus
	virtual/freedesktop-icon-theme
	virtual/ttf-fonts
	x11-misc/shared-mime-info
	7zip? ( app-arch/7zip )
	http? ( net-libs/glib-networking )
	pdf? ( app-text/poppler[png,utils] )
	video? (
		media-video/ffmpeg
		media-video/ffmpegthumbnailer[png]
	)
"
BDEPEND="
	>=dev-build/meson-1.1.0
	>=dev-libs/wayland-protocols-1.49
	dev-util/wayland-scanner
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		app-arch/7zip
		app-text/poppler[png,utils]
		dev-util/glib-utils
		>=media-video/ffmpeg-6.1[x264]
		sys-apps/dbus
	)
"

DOCS=( README.md PACKAGING.md docs/user/configuration.md )

# This suite requires Glycin-backed GdkPixbuf (not available in Gentoo),
# including PNG-compressed ICO support and additional image format loaders.
EMESON_SKIP_TESTS=( thumbnail )

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

src_configure() {
	local emesonargs=(
		-Dbenchmarks=false
		-Dbuild_revision="${COMMIT}"
		-Dnative_optimizations=false
		$(meson_feature test tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	# Keep the bundled font's copyright notice with the font. Gentoo records
	# the application's license through LICENSE instead of /usr/share/licenses.
	rm -r "${ED}/usr/share/licenses" || die
}
