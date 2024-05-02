{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.browsing;

  inherit (config.home) username;
in {
  options.profiles.browsing = {
    enable = lib.mkEnableOption "browsing profile";
  };

  config = lib.mkIf cfg.enable {
    programs.schizofox = {
      enable = true;
      misc.drm.enable = false;
      extensions = {
        # find extension id using search: https://addons.mozilla.org/api/v5/addons/search/?q=refined-github
        # https://mozilla.github.io/addons-server/topics/api/index.html
        # alternatively, download the `xpi` file and look at `manifest.json`
        extraExtensions = {
          "addon@darkreader.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          "	{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "jid1-BoFifL9Vbdl2zQ@jetpack".install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
          "{d7a1061c-6d18-48fb-a42c-3f1c73b0cdf9}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/fio/latest.xpi";
          "@testpilot-containers".install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          "{28d62d88-823e-4327-9d7c-cb621d63bb7d}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/pmmg-extended/latest.xpi";
          "{3c078156-979c-498b-8990-85f7987dd929}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
          "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        };
      };
      package = pkgs.firefox-unwrapped;
      search = {
        addEngines = [
          {
            Name = "Kagi";
            Method = "GET";
            URLTemplate = "https://kagi.com/search?q={searchTerms}";
          }
        ];
        defaultSearchEngine = "Kagi";
        removeEngines = [
          "Google"
          "Bing"
          "Amazon.com"
          "eBay"
          "Twitter"
          "Wikipedia"
        ];
      };
      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };
      settings = {
        "browser.fullscreen.autohide" = false;
        "browser.send_pings" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "media.autoplay.enabled" = false;
        "network.http.sendRefererHeader" = 0;
        "pdfjs.enableScripting" = false;
        "privacy.firstparty.isolate" = true;
        "security.ssl.require_safe_negotiation" = true;
      };
    };

    home.packages = with pkgs; [
      brave
    ];
  };
}
