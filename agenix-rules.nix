let
  admin  = "age1m832py3uqrcuzcrwgs3ctjkxl9u929jqdpv09yq3lktah3u365sq8pzkcm";
  mech   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUQenEdndCrtNfiGyy7XUH6qxpFPr0jxgn7+9/KOiBY root@Mech";
  legion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVTbaOdXj3Xwzo6uu7T0mGakjudr6vjlyZxZyKod7dd root@Legion";
in
{
  "secrets/aohg-password.age".publicKeys = [ admin mech legion ];
  "secrets/github-token.age".publicKeys = [ admin mech legion ];
  "secrets/mihomo-config.age".publicKeys = [ admin mech legion ];
}
