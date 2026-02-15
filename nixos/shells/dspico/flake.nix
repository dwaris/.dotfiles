{
  description = "DSPico Build Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {inherit system;};

        fhs = pkgs.buildFHSEnv {
          name = "dspico-shell";

          targetPkgs = pkgs:
            with pkgs; [
              git
              wget
              curl
              cacert
              unzip
              gnumake
              cmake
              which
              file
              python3
              dotnet-sdk_9
              gcc-arm-embedded
              zlib
              libpng
              ncurses
              openssl
              glib
              libkrb5
              icu

              tree
            ];

          profile = ''
            # ------------------------------------------------------------------
            # Root Layout
            # ------------------------------------------------------------------

            export DSPICO_WORKDIR="$PWD"
            export DSPICO_TOOLS="$DSPICO_WORKDIR/tools"
            export DSPICO_SOURCES="$DSPICO_WORKDIR/src"
            export WONDERFUL_TOOLCHAIN="$DSPICO_TOOLS/wonderful"

            mkdir -p "$DSPICO_TOOLS"
            mkdir -p "$DSPICO_SOURCES"

            export BLOCKSDS="$WONDERFUL_TOOLCHAIN/thirdparty/blocksds/core"
            export DLDITOOL="$BLOCKSDS/tools/dlditool/dlditool"
            export PATH="$WONDERFUL_TOOLCHAIN/bin:$PATH"

            # ------------------------------------------------------------------
            # Toolchain Setup
            # ------------------------------------------------------------------

            setup-toolchain() {
                echo "Setting up Wonderful Toolchain..."

                if [ -d "$WONDERFUL_TOOLCHAIN" ]; then
                    echo "Toolchain already installed."
                    return
                fi

                cd "$DSPICO_TOOLS"

                wget -q --show-progress \
                  https://wonderful.asie.pl/bootstrap/wf-bootstrap-x86_64.tar.gz

                mkdir -p wonderful
                tar -xzf wf-bootstrap-x86_64.tar.gz -C wonderful
                rm wf-bootstrap-x86_64.tar.gz

                cd "$WONDERFUL_TOOLCHAIN"

                wf-pacman -Syu --noconfirm wf-tools
                wf-config repo enable blocksds
                wf-pacman -Syu --noconfirm
                wf-pacman -S --noconfirm blocksds-toolchain

                cd $DSPICO_WORKDIR
                echo "Toolchain setup complete."
            }

            # ------------------------------------------------------------------
            # Clone Repositories
            # ------------------------------------------------------------------

            clone-repos() {
                echo "Cloning repositories..."

                repos=(
                    "https://github.com/Gericom/DSRomEncryptor.git"
                    "https://github.com/LNH-team/dspico-bootloader.git"
                    "https://github.com/LNH-team/dspico-dldi.git"
                    "https://github.com/LNH-team/dspico-firmware.git"
                    "https://github.com/LNH-team/pico-launcher.git"
                    "https://github.com/LNH-team/pico-loader.git"
                )

                cd "$DSPICO_SOURCES"

                for url in "''${repos[@]}"; do
                    name=$(basename "$url" .git)

                    if [ ! -d "$name" ]; then
                        if [ "$name" == "dspico-firmware" ]; then
                            git clone "$url" "$name"

                            cd "$name"
                            git submodule update --init pico-sdk
                            cd ..
                        else
                            git clone --recurse-submodules "$url" "$name"
                        fi
                    else
                        echo "$name already exists."
                    fi
                done

                cd $DSPICO_WORKDIR
            }

            # ------------------------------------------------------------------
            # Update Repositories
            # ------------------------------------------------------------------

            update-repos() {
                echo "Updating repositories..."

                dirs=(
                    "DSRomEncryptor"
                    "dspico-bootloader"
                    "dspico-dldi"
                    "dspico-firmware"
                    "pico-launcher"
                    "pico-loader"
                )

                for dir in "''${dirs[@]}"; do
                    if [ -d "$DSPICO_SOURCES/$dir" ]; then
                        cd "$DSPICO_SOURCES/$dir"
                        echo -ne "$dir"
                        git pull

                        if [ "$dir" == "dspico-firmware" ]; then
                            git submodule update --init pico-sdk
                            cd pico-sdk
                            git submodule update --init
                            cd ..
                        else
                            git submodule update --init --recursive
                        fi
                    fi
                done

                cd $DSPICO_WORKDIR
                echo "Update complete."
            }

            # ------------------------------------------------------------------
            # Build Firmware
            # ------------------------------------------------------------------

            build-firmware() {
                echo "Building DSPico Firmware..."

                if [ ! -f "$DSPICO_WORKDIR/biosnds7.rom" ] || \
                   [ ! -f "$DSPICO_WORKDIR/biosdsi7.rom" ]; then
                    echo "Place BIOS files in the root directory."
                    return 1
                fi

                make -C "$DSPICO_SOURCES/dspico-dldi" -j"$(nproc)"

                make -C "$DSPICO_SOURCES/dspico-bootloader" -j"$(nproc)"

                "$DLDITOOL" \
                    "$DSPICO_SOURCES/dspico-dldi/DSpico.dldi" \
                    "$DSPICO_SOURCES/dspico-bootloader/BOOTLOADER.nds"

                cd "$DSPICO_SOURCES/DSRomEncryptor"
                dotnet build -c Release -o build

                cp "$DSPICO_WORKDIR/biosnds7.rom" build/
                cp "$DSPICO_WORKDIR/biosdsi7.rom" build/

                build/DSRomEncryptor \
                    "$DSPICO_SOURCES/dspico-bootloader/BOOTLOADER.nds" \
                    "$DSPICO_SOURCES/dspico-firmware/roms/default.nds"

                cd "$DSPICO_SOURCES/dspico-firmware"

                chmod +x compile.sh
                ./compile.sh

                cd $DSPICO_WORKDIR
                echo "Firmware build complete."
            }

            # ------------------------------------------------------------------
            # Build Loader
            # ------------------------------------------------------------------

            build-loader() {
                make -C "$DSPICO_SOURCES/pico-loader" -j"$(nproc)"

                cd $DSPICO_WORKDIR
                echo "Loader build complete."
            }

            # ------------------------------------------------------------------
            # Build Launcher
            # ------------------------------------------------------------------

            build-launcher() {
                make -C "$DSPICO_SOURCES/pico-launcher" -j"$(nproc)"

                cd $DSPICO_WORKDIR
                echo "Launcher build complete."
            }

            bundle-release() {
                cd $DSPICO_WORKDIR

                OUT=$DSPICO_WORKDIR/release
                rm -rf "$OUT"
                mkdir -p "$OUT/_pico"

                cd $DSPICO_SOURCES
                if [ -f "pico-launcher/LAUNCHER.nds" ]; then
                    cp "pico-launcher/LAUNCHER.nds" "$OUT/_picoboot.nds"
                    echo "pico-launcher OK"
                else
                    echo "_picoboot.nds MISSING"
                fi

                if [ -f "pico-loader/picoLoader7.bin" ]; then
                    cp "pico-loader/picoLoader7.bin" "$OUT/_pico/"
                    cp "pico-loader/picoLoader9_DSPICO.bin" "$OUT/_pico/picoLoader9.bin"
                    cp "pico-loader/data/aplist.bin" "$OUT/_pico/"
                    cp "pico-loader/data/savelist.bin" "$OUT/_pico/"
                    echo "pico-loader OK"
                else
                    echo "pico-loader files are MISSING"

                fi

                echo "Bundle Complete!"
                tree "$OUT"
            }
            # ------------------------------------------------------------------
            # Build All
            # ------------------------------------------------------------------

            build-all() {
                setup-toolchain
                clone-repos
                build-firmware
                build-loader
                build-launcher
                echo "All builds complete."
            }
          '';

          runScript = "bash";
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [fhs];
          shellHook = ''
            echo "DSPico Development Environment (dspico-shell)"
            echo ""
            echo "run: dspico-shell"
            echo ""
            echo "Commands:"
            echo "  setup-toolchain"
            echo "  clone-repos"
            echo "  update-repos"
            echo "  build-firmware"
            echo "  build-loader"
            echo "  build-launcher"
            echo "  build-all"
            echo "  bundle-release"
          '';
        };
      }
    );
}
