let
  admin  = "age1m832py3uqrcuzcrwgs3ctjkxl9u929jqdpv09yq3lktah3u365sq8pzkcm";
  mech   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUQenEdndCrtNfiGyy7XUH6qxpFPr0jxgn7+9/KOiBY root@Mech";
  legion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVTbaOdXj3Xwzo6uu7T0mGakjudr6vjlyZxZyKod7dd root@Legion";
in
{
  # 规则按密文路径字母序排列；文件基名 = age.secrets.<name> = /run/agenix/<name>

  # 用户密码哈希
  "secrets/aohg-password.age".publicKeys = [ admin mech legion ];

  # GitHub API token（flake 输入解析 / nix flake update 的配额）
  "secrets/github-token.age".publicKeys = [ admin mech legion ];

  # mihomo 主配置
  "secrets/mihomo-config.age".publicKeys = [ admin mech legion ];
}
