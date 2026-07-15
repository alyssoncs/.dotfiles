# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # Absolute path: configuration.nix is a symlink into the dotfiles repo, so a
      # relative ./ would resolve inside the repo. hardware-configuration.nix is
      # machine-specific and stays as a real, untracked file in /etc/nixos.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Fortaleza";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:swapcaps";
  };
  console.useXkbConfig = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alysson = {
    isNormalUser = true;
    description = "Alysson";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Ensure the bluetooth service starts on boot
  hardware.bluetooth.powerOnBoot = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ANDROID_HOME = "$HOME/Android/Sdk";
  };

  system.userActivationScripts.androidSymlinks = {
    text = ''
      # Ensure heavy toolchain target folders exist on your owned storage partition
      mkdir -p /storage/AndroidStudioProjects
      mkdir -p /storage/Android
      mkdir -p /storage/.android
      mkdir -p /storage/.gradle
      mkdir -p /storage/downloads

      # Create pristine symlinks using the dynamic target home path
      ln -sfT /storage/AndroidStudioProjects "$HOME/AndroidStudioProjects"
      ln -sfT /storage/Android "$HOME/Android"
      ln -sfT /storage/.android "$HOME/.android"
      ln -sfT /storage/.gradle "$HOME/.gradle"
      ln -sfT /storage/downloads "$HOME/downloads"
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Alysson";
        email = "alysson.cirilo@example.com"; # Update with your real email
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
  
  environment.variables.SUDO_EDITOR = "nvim";
  security.sudo.extraConfig = ''
    Defaults env_keep += "EDITOR VISUAL SUDO_EDITOR"
  '';

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    alacritty
    bemenu
    waybar
    awww
    google-chrome
    # `google-chrome` alias for `google-chrome-stable`
    (writeShellScriptBin "google-chrome" ''
      exec google-chrome-stable "$@"
    '')
    stow
    #openjdk25
    adwaita-icon-theme
    waybar
    font-awesome
    entr
    jq
    hyprlock
    hypridle
    qbittorrent
    readest
    lf
    xdg-utils
    mpv
    file
    unzip
    android-studio
    tree
    obs-studio
    imagemagick
    grimblast
    texliveFull
    gnumake
    sioyek
    gh
    github-copilot-cli
    wl-clipboard
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US
    just
    python3
  ];

  environment.shellAliases = {
    open = "xdg-open";
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = [ "sioyek.desktop" ];
  };

  security.pam.services.hyprlock = {};

  #programs.java = {
    #enable = true;
    #package = pkgs.openjdk25;
  #};
  programs.java = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "temurin-25-with-native-libs";
      paths = [ pkgs.temurin-bin-25 ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/java \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib   # libstdc++.so.6
          pkgs.zlib               # libz.so.1
          pkgs.libxcrypt-legacy   # libcrypt.so.1
        ]}
      '';
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Disable the old ALSA/PulseAudio services if they exist
  services.pulseaudio.enable = false;
  
  # Enable real-time kit for low-latency audio (essential for BT)
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications (optional)
    jack.enable = true;
  };

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  programs.nix-ld.enable = true;
     programs.nix-ld.libraries = with pkgs; [
     libxcrypt-legacy   # libcrypt.so.1 — exigida pelos binários *.kexe de teste do Kotlin/Native
   ];
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
