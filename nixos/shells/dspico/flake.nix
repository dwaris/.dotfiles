{
  description = "DSPico Build Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        basePackages = with pkgs; [
          git
          wget
          curl
          gnumake
          cmake
          which
          file
          python3
          dotnet-sdk_9
          gcc-arm-embedded
          tree
        ];

        dspicoCli = pkgs.writeShellScriptBin "dspico" ''
          set -euo pipefail

          DSPICO_WORKDIR="''${DSPICO_WORKDIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
          DSPICO_TOOLS="$DSPICO_WORKDIR/tools"
          DSPICO_SOURCES="$DSPICO_WORKDIR/src"
          WONDERFUL_TOOLCHAIN="''${WONDERFUL_TOOLCHAIN:-$DSPICO_TOOLS/wonderful}"
          BLOCKSDS="''${BLOCKSDS:-$WONDERFUL_TOOLCHAIN/thirdparty/blocksds/core}"
          DLDITOOL="''${DLDITOOL:-$BLOCKSDS/tools/dlditool/dlditool}"
          PICO_SDK_PATH="''${PICO_SDK_PATH:-$DSPICO_SOURCES/dspico-firmware/pico-sdk}"

          export DSPICO_WORKDIR DSPICO_TOOLS DSPICO_SOURCES WONDERFUL_TOOLCHAIN BLOCKSDS DLDITOOL PICO_SDK_PATH
          if [ -d "$WONDERFUL_TOOLCHAIN/bin" ]; then
            export PATH="$WONDERFUL_TOOLCHAIN/bin:$PATH"
          fi

          cmd_setup() {
            echo "Setting up Wonderful Toolchain..."
            if [ -d "$WONDERFUL_TOOLCHAIN" ] && [ -x "$WONDERFUL_TOOLCHAIN/bin/wf-pacman" ]; then
              echo "Toolchain already installed at: $WONDERFUL_TOOLCHAIN"
              return 0
            fi

            mkdir -p "$DSPICO_TOOLS"
            cd "$DSPICO_TOOLS"

            echo "Downloading Wonderful Toolchain bootstrap..."
            wget -q --show-progress \
              https://wonderful.asie.pl/bootstrap/wf-bootstrap-x86_64.tar.gz

            mkdir -p wonderful
            tar -xzf wf-bootstrap-x86_64.tar.gz -C wonderful
            rm -f wf-bootstrap-x86_64.tar.gz

            cd "$WONDERFUL_TOOLCHAIN"
            bin/wf-pacman -Syu --noconfirm wf-tools
            bin/wf-config repo enable blocksds
            bin/wf-pacman -Syu --noconfirm
            bin/wf-pacman -S --noconfirm blocksds-toolchain

            echo "Toolchain setup complete."
          }

          cmd_clone() {
            echo "Cloning repositories into $DSPICO_SOURCES..."
            mkdir -p "$DSPICO_SOURCES"
            cd "$DSPICO_SOURCES"

            repos=(
              "https://github.com/Gericom/DSRomEncryptor.git"
              "https://github.com/LNH-team/dspico-bootloader.git"
              "https://github.com/LNH-team/dspico-dldi.git"
              "https://github.com/LNH-team/dspico-firmware.git"
              "https://github.com/LNH-team/pico-launcher.git"
              "https://github.com/LNH-team/pico-loader.git"
            )

            for url in "''${repos[@]}"; do
              name="$(basename "$url" .git)"
              if [ ! -d "$name" ]; then
                echo "=== Cloning $name ==="
                if [ "$name" = "dspico-firmware" ]; then
                  git clone "$url" "$name"
                  (cd "$name" && git submodule update --init pico-sdk)
                else
                  git clone --recurse-submodules "$url" "$name"
                fi
              else
                echo "$name already exists, skipping."
              fi
            done
            echo "Clone complete."
          }

          cmd_update() {
            echo "Updating repositories in $DSPICO_SOURCES..."
            dirs=(
              "DSRomEncryptor"
              "dspico-bootloader"
              "dspico-dldi"
              "dspico-firmware"
              "pico-launcher"
              "pico-loader"
            )

            for dir in "''${dirs[@]}"; do
              target="$DSPICO_SOURCES/$dir"
              if [ -d "$target" ]; then
                echo "=== Updating $dir ==="
                (
                  cd "$target"
                  git pull
                  if [ "$dir" = "dspico-firmware" ]; then
                    git submodule update --init pico-sdk
                    if [ -d "pico-sdk" ]; then
                      (cd pico-sdk && git submodule update --init)
                    fi
                  else
                    git submodule update --init --recursive
                  fi
                )
              else
                echo "Warning: $dir does not exist, skipping."
              fi
            done
            echo "Update complete."
          }

          cmd_clean() {
            echo "Cleaning DSPico build artifacts..."

            if [ -d "$DSPICO_WORKDIR/release" ]; then
              echo "Removing release/ directory..."
              rm -rf "$DSPICO_WORKDIR/release"
            fi

            if [ -d "$DSPICO_SOURCES/dspico-dldi" ]; then
              echo "Cleaning dspico-dldi..."
              make -C "$DSPICO_SOURCES/dspico-dldi" clean 2>/dev/null || true
            fi

            if [ -d "$DSPICO_SOURCES/dspico-bootloader" ]; then
              echo "Cleaning dspico-bootloader..."
              make -C "$DSPICO_SOURCES/dspico-bootloader" clean 2>/dev/null || true
              if [ -d "$DSPICO_SOURCES/dspico-bootloader/libs/libtwl" ]; then
                make -C "$DSPICO_SOURCES/dspico-bootloader/libs/libtwl" clean 2>/dev/null || true
              fi
            fi

            if [ -d "$DSPICO_SOURCES/DSRomEncryptor" ]; then
              echo "Cleaning DSRomEncryptor..."
              rm -rf "$DSPICO_SOURCES/DSRomEncryptor/build" \
                     "$DSPICO_SOURCES/DSRomEncryptor/DSRomEncryptor/bin" \
                     "$DSPICO_SOURCES/DSRomEncryptor/DSRomEncryptor/obj" \
                     "$DSPICO_SOURCES/DSRomEncryptor/DSRomEncryptor.Tests/bin" \
                     "$DSPICO_SOURCES/DSRomEncryptor/DSRomEncryptor.Tests/obj"
            fi

            if [ -d "$DSPICO_SOURCES/dspico-firmware" ]; then
              echo "Cleaning dspico-firmware..."
              rm -rf "$DSPICO_SOURCES/dspico-firmware/build" \
                     "$DSPICO_SOURCES/dspico-firmware/roms/default.nds"
            fi

            if [ -d "$DSPICO_SOURCES/pico-loader" ]; then
              echo "Cleaning pico-loader..."
              make -C "$DSPICO_SOURCES/pico-loader" clean 2>/dev/null || true
              if [ -d "$DSPICO_SOURCES/pico-loader/libs/libtwl" ]; then
                make -C "$DSPICO_SOURCES/pico-loader/libs/libtwl" clean 2>/dev/null || true
              fi
              rm -f "$DSPICO_SOURCES/pico-loader/data/"*.bin
              rm -rf "$DSPICO_SOURCES/pico-loader/tools/PicoLoaderConverter/PicoLoaderConverter/bin" \
                     "$DSPICO_SOURCES/pico-loader/tools/PicoLoaderConverter/PicoLoaderConverter/obj"
            fi

            if [ -d "$DSPICO_SOURCES/pico-launcher" ]; then
              echo "Cleaning pico-launcher..."
              make -C "$DSPICO_SOURCES/pico-launcher" clean 2>/dev/null || true
              if [ -d "$DSPICO_SOURCES/pico-launcher/libs/libtwl" ]; then
                make -C "$DSPICO_SOURCES/pico-launcher/libs/libtwl" clean 2>/dev/null || true
              fi
            fi

            echo "Clean complete."
          }

          cmd_firmware() {
            echo "Building DSPico Firmware..."

            if [ ! -f "$DSPICO_WORKDIR/biosnds7.rom" ] || [ ! -f "$DSPICO_WORKDIR/biosdsi7.rom" ]; then
              echo "Error: biosnds7.rom and biosdsi7.rom must be present in the root directory ($DSPICO_WORKDIR)." >&2
              exit 1
            fi

            NPROC="''${NPROC:-$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN || echo 4)}"

            echo "[1/4] Building dspico-dldi..."
            make -C "$DSPICO_SOURCES/dspico-dldi" -j"$NPROC"

            echo "[2/4] Building dspico-bootloader..."
            make -C "$DSPICO_SOURCES/dspico-bootloader" -j"$NPROC"

            echo "[3/4] Patching bootloader with DLDI..."
            "$DLDITOOL" \
              "$DSPICO_SOURCES/dspico-dldi/DSpico.dldi" \
              "$DSPICO_SOURCES/dspico-bootloader/BOOTLOADER.nds"

            echo "[4/4] Encrypting bootloader ROM & compiling firmware..."
            (
              cd "$DSPICO_SOURCES/DSRomEncryptor"
              dotnet build DSRomEncryptor/DSRomEncryptor.csproj -c Release -o build
              cp "$DSPICO_WORKDIR/biosnds7.rom" build/
              cp "$DSPICO_WORKDIR/biosdsi7.rom" build/
              mkdir -p "$DSPICO_SOURCES/dspico-firmware/roms"
              dotnet build/DSRomEncryptor.dll \
                "$DSPICO_SOURCES/dspico-bootloader/BOOTLOADER.nds" \
                "$DSPICO_SOURCES/dspico-firmware/roms/default.nds"
            )

            (
              cd "$DSPICO_SOURCES/dspico-firmware"
              chmod +x compile.sh
              ./compile.sh
            )

            echo "Firmware build complete."
          }

          cmd_loader() {
            echo "Building DSPico Loader..."
            NPROC="''${NPROC:-$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN || echo 4)}"
            make -C "$DSPICO_SOURCES/pico-loader" -j"$NPROC"
            echo "Loader build complete."
          }

          cmd_launcher() {
            echo "Building DSPico Launcher..."
            NPROC="''${NPROC:-$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN || echo 4)}"
            make -C "$DSPICO_SOURCES/pico-launcher" -j"$NPROC"
            echo "Launcher build complete."
          }

          cmd_bundle() {
            OUT="$DSPICO_WORKDIR/release"
            rm -rf "$OUT"
            mkdir -p "$OUT/_pico"

            if [ -f "$DSPICO_SOURCES/pico-launcher/LAUNCHER.nds" ]; then
              cp "$DSPICO_SOURCES/pico-launcher/LAUNCHER.nds" "$OUT/_picoboot.nds"
              echo "pico-launcher OK -> $OUT/_picoboot.nds"
            else
              echo "Warning: _picoboot.nds MISSING (build launcher not run?)"
            fi

            if [ -f "$DSPICO_SOURCES/pico-loader/picoLoader7.bin" ]; then
              cp "$DSPICO_SOURCES/pico-loader/picoLoader7.bin" "$OUT/_pico/"
              cp "$DSPICO_SOURCES/pico-loader/picoLoader9_DSPICO.bin" "$OUT/_pico/picoLoader9.bin"
              cp "$DSPICO_SOURCES/pico-loader/data/aplist.bin" "$OUT/_pico/"
              cp "$DSPICO_SOURCES/pico-loader/data/savelist.bin" "$OUT/_pico/"
              echo "pico-loader OK -> $OUT/_pico/"
            else
              echo "Warning: pico-loader files are MISSING (build loader not run?)"
            fi

            echo "Release bundle generated at $OUT:"
            if command -v tree >/dev/null 2>&1; then
              tree "$OUT"
            else
              ls -laR "$OUT"
            fi
          }

          cmd_build() {
            DO_CLEAN=0
            for arg in "$@"; do
              case "$arg" in
                --clean|-c) DO_CLEAN=1 ;;
              esac
            done

            if [ "$DO_CLEAN" -eq 1 ]; then
              cmd_clean
            fi

            cmd_setup
            cmd_clone
            cmd_firmware
            cmd_loader
            cmd_launcher
            cmd_bundle
            echo "Build completed successfully!"
          }

          subcmd="''${1:-help}"
          case "$subcmd" in
            setup) shift; cmd_setup "$@" ;;
            clone) shift; cmd_clone "$@" ;;
            update) shift; cmd_update "$@" ;;
            clean) shift; cmd_clean "$@" ;;
            firmware) shift; cmd_firmware "$@" ;;
            loader) shift; cmd_loader "$@" ;;
            launcher) shift; cmd_launcher "$@" ;;
            bundle) shift; cmd_bundle "$@" ;;
            build) shift; cmd_build "$@" ;;
            help|--help|-h)
              echo "DSPico CLI"
              echo ""
              echo "Usage: dspico <command> [options]"
              echo ""
              echo "Commands:"
              echo "  build [--clean]   Full pipeline build (optional: --clean first)"
              echo "  clean             Remove all build artifacts from all subprojects"
              echo "  setup             Bootstrap Wonderful toolchain & BlocksDS"
              echo "  clone             Clone all subproject repositories"
              echo "  update            Pull latest changes for all repositories"
              echo "  firmware          Build RP2040 firmware and encrypted ROM"
              echo "  loader            Build pico loader"
              echo "  launcher          Build pico launcher"
              echo "  bundle            Package final release into release/"
              ;;
            *)
              echo "Unknown command: $subcmd" >&2
              echo "Run 'dspico help' for available commands." >&2
              exit 1
              ;;
          esac
        '';

        fhs = pkgs.buildFHSEnv {
          name = "dspico-shell";
          targetPkgs = pkgs: basePackages ++ [dspicoCli];
          runScript = "bash --login";
        };
      in {
        default = pkgs.mkShell {
          packages = basePackages ++ [dspicoCli];

          shellHook = ''
            export DSPICO_WORKDIR="''${DSPICO_WORKDIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
            export DSPICO_TOOLS="$DSPICO_WORKDIR/tools"
            export DSPICO_SOURCES="$DSPICO_WORKDIR/src"
            export WONDERFUL_TOOLCHAIN="''${WONDERFUL_TOOLCHAIN:-$DSPICO_TOOLS/wonderful}"
            export BLOCKSDS="''${BLOCKSDS:-$WONDERFUL_TOOLCHAIN/thirdparty/blocksds/core}"
            export DLDITOOL="''${DLDITOOL:-$BLOCKSDS/tools/dlditool/dlditool}"
            export PICO_SDK_PATH="''${PICO_SDK_PATH:-$DSPICO_SOURCES/dspico-firmware/pico-sdk}"

            if [ -d "$WONDERFUL_TOOLCHAIN/bin" ]; then
              export PATH="$WONDERFUL_TOOLCHAIN/bin:$PATH"
            fi

            mkdir -p "$DSPICO_TOOLS" "$DSPICO_SOURCES"

            echo "DSPico Environment Loaded"
            echo "Run 'dspico help' for available commands."
          '';
        };

        fhs = pkgs.mkShell {
          packages = [fhs];
          shellHook = ''
            echo "Entering FHS environment wrapper (dspico-shell)..."
            exec dspico-shell
          '';
        };
      }
    );
  };
}
