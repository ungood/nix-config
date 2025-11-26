{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "obsidian-cli";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "Yakitrak";
    repo = "obsidian-cli";
    rev = "v${version}";
    hash = "sha256-oIEiIzdbtwCeuBTii+BdvTmfi3YuMSSngXMDFuelJVc=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Interact with Obsidian in the terminal. Open, search, create, update, move, delete and print notes";
    homepage = "https://github.com/Yakitrak/obsidian-cli";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "obsidian-cli";
  };
}
