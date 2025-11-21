# Debian Testing: Sway

Guia de instalação e pós instalação para Debian Testing com Sway.

## Instalação

Instalar um Debian mínimo (com no máximo os utilitários padrões) e particionando:
1. `/boot/efi`: 512 MiB
1. `/boot`: 2 GiB
1. `/`: 64 GiB
1. `/var`: 32 GiB
1. `/tmp`: 32 GiB
1. `/boot/efi`: 256 MiB
1. `/`: 92 GiB
1. `LUKS`
    1. `LVM`
        1. `/home`: *
        1. `SWAP`: 24 GiB

## Pós-instalação

### APT

Configurar o `apt` para usar o repositórios do _testing_:
1. Remova os repositórios de código-fonte
1. Remova os `*-backports`
1. Remova os `*-updates`
1. Troque todos os "`stable`" por "`testing`"
1. Adicione as _branchs_ `contrib` e `non-free`
1. Atualize o sistema completamente

### Pacotes

Login:
- `greetd`: Daemon de _display manager_
- `tuigreet`: _Display manager_ minimalista

Interface:
- `sway`: Compositor de janelas (inclui `wayland`)
- `swayidle`: Gerenciador de ociocidade
- `swaylock`: Gerenciador de bloqueio de tela
- `swaybg`: Gerenciador de papel de parede (_?_)
- `sway-notification-center`: Gerenciador de notificações
- `waybar`: Barra de status

Rede:
- `ssh`: Utilitário de conexão remota
- `network-manager`: Gerenciador de rede

Segurança:
- `gpg`: Utilitário de chaves GnuPG
- `ufw`: _Firewall_
- `gnome-keyring`: Chaveiro
- `seahorse`: Chaveiro GUI (_?_)

Trabalho:
- `terminator`: Emulador de terminal (_also kitty_)
- `google-chrome-stable`: Pacote _.deb_
- `zathura`: Visualizador de PDFs

Programação:
- `git`: Versionamento de arquivos
- `code`: Editor de código
- `build-essential`: Utilitários de compilação (_?_)
- `default-jre`: Binários Java para execução de _apps_ (_?_)
- `default-jdk`: Utilitários Java para desenvolvimento de _apps_ (_?_)

Media:
- `pipewire-media-session-`: _#remove_
- `pipewire-audio`: Sevidor de áudio (inclui `wireplumber`)
- `pipewire-jack`: Driver de dispositivos _jack_
- `pavucontrol`: Controlador GUI de áudio
- `mpv`: Mídia _player_ (_?_)
- `feh`: Visualizador de imagens
- `blueman`: Gerenciador de _bluetooth_ (_?_)

Tema:
- `qt5ct`: Utilitário do Qt5
- `qt6ct`: Utilitário do Qt6
- `libglib2.0-bin`: Utilitário `gsettings`

Compatibilidade:
- `xwayland`: Suporte para programas Xorg no Wayland (_?_)
- `qtwayland5`: Suporte para programas Qt no Wayland (_?_)

Protocolos:
- `wayland-protocols`: Protocolos do servidor gráfico
- `xdg-desktop-portal-wlr`: Protocolos para Wayland
- `xdg-desktop-portal-gtk`: Protocolos genéricos (_?_)

Drivers:
- `mesa-utils`: Ferramentas CLI de vídeo
- `mesa-va-drivers`: Aceleração de vídeo
- `mesa-vdpau-drivers`: Aceleração de vídeo
- `mesa-vulkan-drivers`: Renderização 3D
- `mesa-opencl-icd`: Processamento gráfico
- `intel-media-va-driver`: Aceleração de vídeo (especializado)

Diversos:
- `hunspell-<lang>`: Utilitário de verificação ortográfica (_?_)

#### Utilitários

Ferramentas:
- `vim-tiny-`: _#remove_
- `vim`: Editor em modo texto
- `htop`: Monitor do sistema TUI
- `tree`: Listagem de arquivo em árvore
- `ncdu`: Gerenciador de uso de disco
- `tmux`: Multiplexador de janelas
- `ranger`: Gerenciador de arquivos TUI
- `progress`: Utilitário de visualização de progresso
- `translate-shell`: Tradutor CLI
- `wev`: Visualizador de eventos (como teclado e _mouse_)
- `tealdeer`: Páginas de manuais simplificadas

Interface:
- `fyi`: Utilitário para enviar notificações de _desktop_
- `wdisplays`: Gerenciador de _displays_
- `kanshi`: Gerenciador automático de display
- `brightnessctl`: Contralador CLI de brilho

Mídia:
- `slurp`: Utilitário de seletor de área
- `grim`: Utilitário de _screenshot_
- `swappy`: Utilitário de edição de _screenshot_
- `wl-clipboard`: Utilitário de _clipboard_
- `hyprpicker`: Utilitário de _color picker_

Sistema:
- `resolvconf`: Utilitário de DNS
- `psmisc`: Utilitários para envio de SIGNALS à processos
- `keychain`: Gerenciador de chaves ssh
- `xdg-user-dirs`: Gerenciador de diretórios do usuário
- `xdg-utils`: Ferramentas CLI de integração _application x desktop_
- `preload`: Otimizador de _startup time_ de programas (_?_)
- `fwupd`: Gerenciador de atualizações de `firmware`
- `libwayland-dev`: Utilitários do Wayland

#### Complexos

List Wayland Toplevels:
1. `[sudo] apt install libwayland-dev`
1. `git clone [-b <version>] https://git.sr.ht/~leon_plickat/lswt`
1. `cd ./lswt/`
1. `make -j$(nproc)`
1. `[sudo] make install`

LibreOffice:
1. `[sudo] apt install libreoffice libreoffice-{gtk4|qt6} [hunspell-<lang>] [default-jre]`

### Configurações

Greetd:
- Substituir no `/etc/greetd/config.toml`:
    `command = "tuigreet --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd sway"`

Sway:
- Copiar arquivo de configuração para `~/.config/sway/` (_default_ `/etc/sway/config`)

Swaync:
- Copiar arquivo de estilização para `~/.config/swaync/` (_default_ `/etc/xdg/swaync/style.css`)

Waybar:
- Copiar arquivos de configuração para `~/.config/waybar/` (_default_ `/etc/xdg/waybar/*`)
- Copiar arquivo de módulo de para `~/.config/waybar/custom/` (_default_ `/usr/share/waybar/custom_modules/power_menu.xml`)

XDG:
- Executar `xdg-user-dirs-update`

LibreOffice:
- Opcional (`/etc/environment`): `SAL_USE_VCLPLUGIN={gtk4|kf6} libreoffice`

Ranger:
- Copiar arquivo de configuração para `~/.config/ranger/` (_default_ `ranger --copy-config=rc`)
- Para `image_preview`:
    - Caso esteja usando `kitty`, instale a dependência `python3-pil`
    - Caso esteja usando `terminator`, instale a dependência [`ueberzugpp`](https://software.opensuse.org/download.html?project=home%3Ajustkidding&package=ueberzugpp)
    - Caso esteja usando outro emulador de terminal: instale a dependência `w3m-img`

Git:
- Copiar arquivo de configuração para `~/`

Kitty:
- Copiar arquivo de configuração para `~/.config/kitty/kitty.conf`

Keychain:
- Copiar comando de inicialização (`~/.profile`)

Kanshi:
- Copiar arquivo de configuração para `~/.config/kanshi/`

VSCode:
- Necessário (manual/scriprs/aliases): `code --enable-wayland-ime`
- Necessário (manual/scriprs/aliases): `code --ozone-platform-hint=wayland`
- Necessário (manual/scripts/aliases): `code --enable-features=UseOzonePlatform --ozone-platform=wayland`
- Necessário (manual/scripts/aliases): `code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland`
- Necessário (`/etc/environment`): `ELECTRON_OZONE_PLATFORM_HINT=auto code`
- Caso os atalhos de teclado ainda não estejam com suporte via Wayland nativo:
    1. Com Wayland, salve um cópia de `Preferences: Open Default Keyboard Shortcuts (JSON)`
    1. Instale `xwayland` que habilita suporte do Xorg no Wayland
    1. Com Xwayland, salve um cópia de `Preferences: Open Default Keyboard Shortcuts (JSON)`
    1. Copare as duas versões e corrija os shortcuts via `Preferences: Open Keyboard Shortcuts` (gerando um `keybindings.json` de usuário)
    1. Caso funcione, basta copiar arquivo de _keybindings_ (pré-existent) para `~/.config/Code/User/`
- Caso não seja reconhecido automáticamente o chaveiro, inclua `"password-store": "gnome-libsecret"` em `~/.vscode/argv.json`

Google-chrome:
- Utilize o `cog` como intermediário somente para fazer o _download_ do Chrome
- Caso precise, configure os _emojis_:
    `[sudo] apt-get install fonts-noto-color-emoji; fc-cache -fv`

Network-manager:
- Remover o arquivo `/etc/network/interfaces`
- Desabilitar o daemon `networking.service`
- Reiniciar o daemon `NetworkManager.service`

UFW:
- Executar `[sudo] ufw enable`

Pipewire:
1. `cp -fv /usr/share/doc/pipewire/examples/systemd/user/pipewire-pulse.* /etc/systemd/user/`
1. `cp -fv /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/`
1. `cp -fv /usr/share/doc/pipewire/examples/ld.so.conf.d/pipewire-jack-*.conf /etc/ld.so.conf.d/`
1. `ldconfig`
1. `systemctl --user --now enable wireplumber.service`
1. `[sudo] systemctl --global disable fluidsynth.service`
1. `systemctl reboot || [sudo] reboot`
1. Copiar arquivo de configuração para `~/.config/pipewire/pipewire.conf.d/`

Tema:
1. Definir tema para GTK:
    ```sh
    for folder in ~/.config/gtk-{3,4}.0; do
        [ ! -d "$folder/" ] && mkdir -pv "$folder/"
        cat <<- eof | tee "$folder/settings.ini"
            [Settings]
            gtk-application-prefer-dark-theme = 1
            gtk-font-name = Sans 10
        eof
    done
    ```
1. Definir tema para Qt:
    1. Executar `qt5ct` e `qt6ct`
    1. Alterar diretamente nos arquivos de configuração (`~/.config/qt[56]ct/qt[56]ct.conf`):
        - Nome da fonte para **Sans**
        - Tamanho da fonte para **10**
1. Instalar Hack Nerd Font:
    1. Copiar font baixada, [baixar mais atual do site](<https://www.nerdfonts.com/font-downloads#hack:~:text=at%20common%20sizes-,Download,-Preview>) ou a [última versão fixa](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip) (que eu registrei)
    1. Descompactar o arquivo (se estiver comprimido)
    1. Criar a estrutura de pasta (se não existir):
        `mkdir -pv ~/.local/share/fonts/{true,open}type/`
    1. Copiar os arquivos de fontes desejados

Variáveis:
1. Definir variáveis de ambiente:
    ```sh
    cat <<- eof | tee -a /etc/environment
        EDITOR=vim
        XDG_SESSION_TYPE=wayland
        XDG_CURRENT_DESKTOP=sway
        GDK_BACKEND=wayland
        GDK_DARK_MODE=1
        QT_QPA_PLATFORM=wayland
        QT_QPA_PLATFORMTHEME=qt5ct
        MOZ_ENABLE_WAYLAND=1
        ELECTRON_OZONE_PLATFORM_HINT=auto
    eof
    ```
TMP:
1. Copiar arquivo de configuração para `/etc/tmpfiles.d/` (_default_ `/usr/lib/tmpfiles.d/tmp.conf`)
1. Desabilitar limpadores automáticos:
    `[sudo] systemctl disable --now systemd-tmpfiles-clean.service; [sudo] systemctl mask --now systemd-tmpfiles-clean.timer`

pCloud:
1. Adicionar nas exclusões: `.git;*.swp;*.pf;`
