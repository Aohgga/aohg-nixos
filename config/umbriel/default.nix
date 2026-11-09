settings:
(builtins.foldl' (acc: file: acc // (import file)) { } [
  ./appearance.nix
  ./general.nix
  ./include.nix
  ./input.nix
  ./keybinds.nix
  ./layer-rules.nix
  ./layout.nix
  ./overview.nix
  ./security-rules.nix
  ./window-rules.nix
  ./workspaces.nix
])
// {
  output = settings;
}
