{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "AtomPC"; 
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "tr_TR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };
  
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono 
  ]; 
 
  services.xserver.enable = true;
  
  # --- GİRİŞ VE MASAÜSTÜ YÖNETİMİ ---
  services.displayManager.ly.enable = true; # Hafif TUI Giriş Ekranı aktif
  # services.desktopManager.plasma6.enable = true; # KDE Plasma'yı tamamen kapattık!
  programs.hyprland.enable = true; # Canavarımız aktif

  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  console.keyMap = "trq";
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."atom" = {
    isNormalUser = true;
    description = "Atom BAMya";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      mpv
      btop
      htop
      kitty
      vim
      tealdeer
      xclip
      bat
    ];
  };

  programs.firefox.enable = false;
  nixpkgs.config.allowUnfree = true;
  
  programs.steam = {
    enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.variables = {
    XCURSOR_SIZE = "24";
  };  

  environment.systemPackages = with pkgs; [
    git
    fastfetch
    deezer-desktop
    waybar
    rofi
    swww
    adwaita-icon-theme
    kdePackages.dolphin
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.helium.packages.${pkgs.system}.default    

    (prismlauncher.override {
      jdks = [
        jdk25
        jdk21
        jdk17
        jdk8
      ];
    })
  ];

  system.stateVersion = "26.05"; 

  environment.shellAliases = {
    nixup = "cd ~/atomic && git add . && sudo nixos-rebuild switch --flake ~/atomic/#AtomPC && git commit -m \"Sistem Guncellemesi: $(date +'%d-%m-%Y %H:%M')\" && git push origin master && cd -";
  };
}
