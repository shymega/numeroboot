kind: autotools

build-depends:
- freedesktop-sdk.bst:components/gzip.bst
- freedesktop-sdk.bst:components/llvm.bst
- freedesktop-sdk.bst:components/nasm.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  # Limine's BIOS port is architecture-agnostic (it only concerns itself
  # with the 16/32-bit boot trampoline, not the eventual kernel's
  # bitness), so limine_arch only affects which UEFI port gets enabled.
  (?):
  - limine_firmware == "bios":
      conf-local: --enable-bios
  - limine_firmware == "uefi" and limine_arch == "x86_64":
      conf-local: --enable-uefi-x86-64
  - limine_firmware == "uefi" and limine_arch == "i686":
      conf-local: --enable-uefi-ia32

sources:
- kind: tar
  url: codeberg:Limine/Limine/releases/download/v11.2.1/limine-11.2.1.tar.gz
  ref: 1d0ab886b8ee213418f626b5cf8a4a89df35f967d7f421945124147ef04f3e01
