EAPI=8

inherit meson

DESCRIPTION="A Wayland compositor built on wlroots"
HOMEPAGE="https://github.com/noctalia-dev/umbriel"

COMMIT="94ab5961dce31cd53e5cdca76d2723d73fc2e189"
SRC_URI="https://github.com/noctalia-dev/umbriel/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="jemalloc lcms systemd +xwayland"
REQUIRED_USE="jemalloc? ( elibc_glibc )"

DEPEND="
	>=dev-libs/wayland-1.24.0
	>=dev-libs/libinput-1.29.0
	>=dev-libs/libei-1.3.0
	>=gui-libs/wlroots-0.20.1:0.20[libinput,session,X]
	>=media-libs/libdisplay-info-0.3.0
	>=media-libs/mesa-24.1.0[opengl]
	media-libs/libglvnd
	>=x11-libs/libdrm-2.4.129
	>=x11-libs/libxkbcommon-1.10.0
	>=x11-libs/pixman-0.43.0
	x11-libs/cairo
	x11-libs/pango
	x11-libs/libxcb
	x11-libs/xcb-util-wm
	dev-cpp/nlohmann_json
	dev-cpp/tomlplusplus
	jemalloc? ( dev-libs/jemalloc )
	lcms? ( media-libs/lcms:2 )
	systemd? ( >=sys-apps/systemd-243 )
"
RDEPEND="
	${DEPEND}
	xwayland? ( x11-base/xwayland )
"
BDEPEND="
	>=dev-build/meson-1.3.0
	>=dev-libs/wayland-protocols-1.47
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	default

	# GitHub source archives do not include .git metadata. Keep the packaged
	# commit visible in `umbriel --version` instead of reporting "unknown".
	sed -i "s/fallback: 'unknown'/fallback: '${COMMIT}'/" meson.build || die
}

src_configure() {
	local EMESON_BUILDTYPE=release
	local emesonargs=(
		-Dtests=disabled
		-Dharness=disabled
		-Dtracy=disabled
		$(meson_feature jemalloc)
		$(meson_feature systemd localed)
	)

	meson_src_configure
}
