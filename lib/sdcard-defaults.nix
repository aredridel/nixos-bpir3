            {lib, ...}: {
             system.stateVersion = lib.mkDefault "22.11";
              networking.hostName = "bpir3";

              networking.useDHCP = false;
              networking.bridges = {
                br0 = {
                  interfaces = [ "wan" "lan0" "lan1" "lan2" "lan3" ];
                };
              };
              networking.interfaces.br0.useDHCP = true;

              services.openssh.enable = true;
              # For initial setup
              users.users.root.password = "bananapi";
              services.openssh.settings.PermitRootLogin = "yes";
            }
