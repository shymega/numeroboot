kind: autotools

build-depends:
- freedesktop-sdk.bst:components/libgcrypt.bst
- freedesktop-sdk.bst:components/lvm2-stage1.bst
- freedesktop-sdk.bst:components/openssl.bst
- freedesktop-sdk.bst:components/popt.bst
- freedesktop-sdk.bst:components/util-linux-full.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  conf-local: >-
    --disable-external-tokens
    --disable-ssh-token
    --enable-static
    --enable-veritysetup

config:
  build-commands:
  - |
    cd "%{build-root}/src"
    gcc  -Wall -O2 -o veritysetup veritysetup-utils_crypt.o veritysetup-utils_loop.o veritysetup-utils_tools.o veritysetup-veritysetup.o -lpopt -ldevmapper -lgcrypt -luuid ../.libs/libcryptsetup.a
  install-commands:
  - |
    install -Dm755 -t "%{install-root}%{bindir}" "%{build-root}/src/veritysetup"
  strip-commands:
  - |
    strip --strip-all "%{build-root}/src/veritysetup"

sources:
- kind: tar
  url: kernel_pub:linux/utils/cryptsetup/v1.7/cryptsetup-1.7.5.tar.gz
  ref: 7acfb3678e4f47c3fb32b671fd81ebffe4073d916c2844ce460256a9b0e9b799
