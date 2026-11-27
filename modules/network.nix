{
  config,
  lib,
  pkgs,
  ...
}: let
  uctEap = {
    eap = "peap;";
    identity = "mntjac003@wf.uct.ac.za";
    phase2-auth = "mschapv2";
    ca-cert = "${../uct-eduroam-ca.pem}";
    domain-match = "*.uct.ac.za;nac.uct.ac.za";
    password = "$EDUROAM_PASSWORD";
  };
in {
  # Correct regulatory domain; the kernel default is the restrictive "00"
  # world domain. (Note: the AX210 reports a self-managed domain and flags
  # 5 GHz channels "No IR" -- this does NOT block station-mode association,
  # so don't go down that rabbit hole. Weak signal looks identical in the
  # logs. Check `cat /proc/net/wireless` for level/retry/missed-beacon first:
  # anything worse than about -70 dBm is an antenna or placement problem.)
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ZA"
  '';

  networking.networkmanager = {
    enable = true;
    # Desktop on mains power: powersave only buys dropped 5 GHz links.
    wifi.powersave = false;
    logLevel = "INFO";

    ensureProfiles.environmentFiles = ["/etc/nixos/secrets/eduroam.env"];

    ensureProfiles.profiles = {
      eduroam = {
        connection = {
          id = "eduroam";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
          proto = "rsn;";
          pairwise = "ccmp;";
          group = "ccmp;";
        };
        "802-1x" = uctEap;
        ipv4.method = "auto";
        ipv6.method = "auto";
      };

      uct-wired = {
        connection = {
          id = "uct-wired";
          type = "ethernet";
          autoconnect-priority = 100;
          autoconnect-retries = 3;
        };
        "802-1x" =
          uctEap
          // {
            optional = false;
            auth-timeout = 10;
          };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = [pkgs.iw];
}
