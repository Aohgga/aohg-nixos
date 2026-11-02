let
  admin  = "age1upy7s2qnaj9pq59vtngeqknwxr78wqfu4nndfqvx0nskevn5ty8syxzw4k";
  mech   = "age1tpjug4v5wkex76uuejhzc8ymmak2lp7skl842vr34uwhh8cvgfrq2g74gu";
  legion = "age1tszl6j9qu5fj8thxmwjard8s60vwpkkktkx2sx74kvlm5u7rxfxqqghn6d";
in
{
  # 用户密码哈希
  "secrets/passwords/aohg-password.age".publicKeys = [ admin mech legion ];

  # mihomo 主配置
  "secrets/mihomo/config.yaml.age".publicKeys = [ admin mech legion ];
}
