{
  stdenv,
  lib,
  fetchFromGitHub,
  docbook_xml_dtd_43,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  python3,
  shared-mime-info,
  nixosTests,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "libxmlb";
  version = "0.3.21";

  outputs = [
    "out"
    "lib"
    "dev"
    "devdoc"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libxmlb";
    rev = version;
    hash = "sha256-+gs1GqDVnt0uf/0vjUj+c9CRnUtaYfngBsjSs4ZwVXs=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
  ];

  buildInputs = [
    glib
    xz
    zstd
  ];

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/libexec"
    "-Dgtkdoc=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  preCheck = ''
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${shared-mime-info}/share
  '';

  doCheck = true;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.libxmlb;
    };
  };

  meta = with lib; {
    description = "Library to help create and query binary XML blobs";
    mainProgram = "xb-tool";
    homepage = "https://github.com/hughsie/libxmlb";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
