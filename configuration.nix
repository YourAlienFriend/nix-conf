# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
   

  {
    # Your configuration settings go here
  
    #
    time.hardwareClockInLocalTime = true;
    #


    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
      ];

    # Bootloader
    boot.loader.systemd-boot.enable = false;
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    
    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Athens";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "el_GR.UTF-8";
      LC_IDENTIFICATION = "el_GR.UTF-8";
      LC_MEASUREMENT = "el_GR.UTF-8";
      LC_MONETARY = "el_GR.UTF-8";
      LC_NAME = "el_GR.UTF-8";
      LC_NUMERIC = "el_GR.UTF-8";
      LC_PAPER = "el_GR.UTF-8";
      LC_TELEPHONE = "el_GR.UTF-8";
      LC_TIME = "el_GR.UTF-8";
    };
    
    # Enable the X11 windowing system.
    
    services.xserver = {
      enable = true;
      layout = "us,gr";
      #xkbVariant = "simple";
      xkbOptions = "grp:alt_shift_toggle";
    
      desktopManager.plasma5.enable = true;
      desktopManager.xterm.enable = true; # Enable this if you want to use xterm as an alternative
      displayManager = {
        
        sddm.enable = true;                  
      };

      videoDrivers = [ "nvidia" ];
      };

        
      environment.sessionVariables = {
       WLR_NO_HARDWARE_CURSORS = "1";
        # Hint electron apps to use wayland
       NIXOS_OZONE_WL = "1";
      };

      hardware = {
        # opengl
        opengl.enable = true;

        #wayland compositor needs to be enabled
        nvidia = {
          modesetting.enable = true;

            # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          powerManagement.enable = false;
          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          powerManagement.finegrained = false;

          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          # Support is limited to the Turing and later architectures. Full list of 
          # supported GPUs is at: 
          # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
          # Only available from driver 515.43.04+
          # Currently alpha-quality/buggy, so false is currently the recommended setting.
          open = false;

          # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
          nvidiaSettings = true;

          # Optionally, you may need to select the appropriate driver version for your specific GPU.
      
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };

      #enabling hyprland on NixOS
        programs.hyprland = {
          enable = true;
          enableNvidiaPatches = true;
          xwayland.enable = true;
        };
	
    programs.waybar.enable=true;


    #Enable polkit
    security.polkit={
	enable = true;
	};

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    fileSystems."/mnt/linux data" = {
          device = "/dev/disk/by-uuid/4430b02a-bcc1-46ce-9e9e-cae380b2f617";
          fsType = "ext4"; # replace with your filesystem type if it's not ext4
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.nolito = {
      isNormalUser = true;
      description = "nolis";
      extraGroups = [ "networkmanager" "wheel" "docker"];
      packages = with pkgs; [
	polkit_gnome
        kate
        kmail
      ];
    };
    #enable steam
    programs.steam.enable = true;

    #enable docker
    virtualisation.docker.enable = true;

    #enable flatpak
    services.flatpak.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
	    vim
	    neovim
	    floorp
	    libreoffice
	    kitty
	    alacritty
	    wget
	    tree
	    git
	    gparted
	    htop
	    discord
	    spotify
	    yuzu-mainline
	   #hyprland
	    waybar
	    eww
	    mako 
	    swww
	    wofi
	    
	    polkit-kde-agent
	    networkmanagerapplet
	    #developement
	    docker
	    docker-compose
	    vscode
	    (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
	            bbenoist.nix
	            ms-python.python
	            ms-azuretools.vscode-docker
	            ms-vscode-remote.remote-ssh
	          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	            {
	              name = "remote-ssh-edit";
	              publisher = "ms-vscode-remote";
	              version = "0.47.2";
	              sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
	            }
	          ];
	    })
	   xdg-desktop-portal-gtk	    	   	
    ];


    xdg.portal = {
	enable =true;
	extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:
       systemd = {
	   user.services.polkit-gnome-authentication-agent-1 = {
	    description = "polkit-gnome-authentication-agent-1";
	    wantedBy = [ "graphical-session.target" ];
	    wants = [ "graphical-session.target" ];
	    after = [ "graphical-session.target" ];
	    serviceConfig = {
	        Type = "simple";
	        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
	        Restart = "on-failure";
	        RestartSec = 1;
	        TimeoutStopSec = 10;
	      };
	    };
    };
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
    system.stateVersion = "23.11"; # Did you read the comment?

  }
