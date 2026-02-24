kind: autotools
description: |
  GRUB bootloader

build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/freetype.bst
- freedesktop-sdk.bst:components/git-minimal.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patch.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  autogen: >
    ./bootstrap
    --no-git
    --gnulib-srcdir=%{build-root}/gnulib

  conf-local: >
    --with-platform=pc
    --libdir=%{prefix}/lib
    --libexecdir=%{prefix}/lib
    --enable-grub-mkfont

  # Enable selected extras from grub-extras.git.
  grub-extras: "915resolution ntldr-img"

  # Override the default Freedesktop SDK CFLAGS to disable things we can't use in GRUB:
  #
  #   * No control-flow protection as it doesn't work on i686
  #   * No stack protector, it requires linking a library, but the bootloader is special
  #   * Avoid certain -Werror build failures (this is an old version of GRUB)
  configure: |
    CFLAGS="$CFLAGS -fcf-protection=none -fno-stack-protector -Wno-error=maybe-uninitialized" %{conf-cmd} %{conf-args} %{conf-local}

  # GRUB does its own stripping.
  strip-binaries: ""

environment:
  GRUB_CONTRIB: ./grub-extras-enabled

config:
  configure-commands:
    (<):
    - |
      mkdir ./grub-extras-enabled
      for extra in %{grub-extras}; do
        echo "Enabling grub-extra: $extra"
        cp -a ./grub-extras/$extra ./grub-extras-enabled
      done

sources:
- kind: git_repo
  url: savannah:grub.git
  track: grub-*
  exclude:
  - '*rc*'
  ref: grub-2.14-0-gd38d6a1a9b79427848976f53d474392cd29c2a71
- kind: git_repo
  directory: grub-extras/
  url: savannah:grub-extras.git
  track: master
  ref: 8a245d5c1800627af4cefa99162a89c7a46d8842
- kind: git_repo
  directory: gnulib
  url: savannah:gnulib.git
  # Track the exact commit from variable GNULIB_REVISION in bootstrap.conf
  ref: 9f48fb992a3d7e96610c4ce8be969cff2d61a01b
