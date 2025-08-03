{ config, lib, pkgs, ... }:

let
  # Add modprobe configurations for Intel AX200/AX201/AX210 Wi-Fi cards
  extraModprobeConfig = ''
    # Keep Bluetooth coexistence disabled for better BT audio stability
    options iwlwifi bt_coex_active=0

    # Enable software crypto (helps BT coexistence sometimes)
    options iwlwifi swcrypto=1

    # Disable power saving on Wi-Fi module to reduce radio state changes that might disrupt BT
    options iwlwifi power_save=0

    # Disable Unscheduled Automatic Power Save Delivery (U-APSD) to improve BT audio stability
    options iwlwifi uapsd_disable=1

    # Disable D0i3 power state to avoid problematic power transitions
    options iwlwifi d0i3_disable=1

    # Set power scheme for performance (iwlmvm)
    options iwlmvm power_scheme=1
  '';
in
{
  # Enable Bluetooth support and power on at boot
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
        ControllerMode = "bredr"; # Fix Bluetooth audio dropouts for Intel cards
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true; # Automatically enable Bluetooth when devices are present
      };
    };
  };

  # If using a GUI for Bluetooth management (Blueman)
  services.blueman.enable = true;

  # Add the extra modprobe configuration for Wi-Fi/Bluetooth coexistence and performance
  boot.extraModprobeConfig = extraModprobeConfig;
}

