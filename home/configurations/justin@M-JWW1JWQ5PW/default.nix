inputs: {
  pkgs,
  flakeRootPath,
  ...
}: {
  config = {
    activeProfiles = ["development"];

    home = {
      packages = with pkgs; [
        pkgs.tokei
        inputs.nix-go.packages.${pkgs.system}.go
        pkgs.awscli2
        pkgs.kind
        inputs.nixpkgs-2405.legacyPackages.${pkgs.system}.kops_1_26
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.podman
        pkgs.sops
        pkgs.terraform
        pkgs.vfkit
        pkgs.yq
      ];

      sessionPath = ["$HOME/go/bin"];

      stateVersion = "24.05";
    };

    programs.zsh.initExtra = ''
      awsprofile() {
        unset AWS_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
        if (( $# != 2 )); then
          echo 'Usage:' >&2
          echo '  awsprofile <source profile> <target profile>' >&2
          echo >&2
          echo 'e.g.:' >&2
          echo '  awsprofile sso admin' >&2
          echo '  awsprofile sso-ro prod-ro' >&2
          return
        fi
        eval $(aws sts assume-role --profile $1                 \
          --role-session-name $(whoami)                         \
          --role-arn $(aws configure get role_arn --profile $2) |
            jq -r '.Credentials                                 |"
              export AWS_ACCESS_KEY=\(.AccessKeyId)
              export AWS_ACCESS_KEY_ID=\(.AccessKeyId)
              export AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)
              export AWS_SESSION_TOKEN=\(.SessionToken)
          "')
        export AWS_ACCOUNT=$2
      }
    '';
  };
}
