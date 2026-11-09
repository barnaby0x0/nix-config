# nix-config
Nix configurations workspace.


## Utiliser les modules Home Manager dans son propre flake

Les modules Home Manager de ce dépôt sont exposés par la sortie `homeModules`. Un utilisateur peut
les consommer depuis son propre flake et garder sa configuration en local, sans passer par la
configuration NixOS.

### Modules partageables

| Module | Rôle |
|---|---|
| `homeModules.args` | fournit `mkVim` aux modules (`_module.args`) |
| `homeModules.options` | déclare les options `my.user.*` (par exemple `my.user.git`) |
| `homeModules.profiles.base` | profil de base (shell, git, vim...) |
| `homeModules.profiles.desktop` | profil bureau |
| `homeModules.programs.*` | modules de programmes individuels |

> `homeModules.users` n'est **pas** à utiliser dans ce mode. Il sert uniquement de colle entre
> `hosts/<host>/users.nix` et les options `my.user.*` quand NixOS gère le home.

### Exemple de flake utilisateur

```nix
{
  inputs = {
    nix-config.url = "github:barnaby0x0/nix-config/develop";
    nixpkgs.follows = "nix-config/nixpkgs";
    home-manager.follows = "nix-config/home-manager";
  };

  outputs = { nix-config, nixpkgs, home-manager, ... }: {
    homeConfigurations."user@k8" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      modules = [
        nix-config.homeModules.args
        nix-config.homeModules.profiles.base
        nix-config.homeModules.profiles.desktop
        ./home.nix
      ];
    };
  };
}
```

`home.nix` contient la configuration propre à l'utilisateur :

```nix
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "26.05";

  my.user.git = {
    name = "Victor";
    email = "victor@mail.net";
  };

  programs.alacritty = {
    enable = true;
    theme = "solarized_dark";
  };
}
```

### Appliquer

```bash
home-manager switch --flake .#"user@k8"
# ou, sans le CLI installé :
nix run home-manager -- switch --flake .#"user@k8"
```

Pour récupérer les dernières modifications des modules partagés :

```bash
nix flake update nix-config
```

Pour éviter qu'un changement incompatible casse le build, il est possible de fixer une révision :
`github:barnaby0x0/nix-config/<rev>`.

### Côté configuration NixOS

Pour qu'un utilisateur gère lui-même son home, NixOS ne doit plus le gérer.
Dans `hosts/<host>/users.nix` :

```nix
user = {
  homeManager = false;
  # ...
};
```

Le compte, les droits et la **persistance** restent gérés côté système.

### Limites à connaître

- **Persistance (impermanence)** : les montages `bind` sont créés par le module NixOS
  d'impermanence, pas par Home Manager. `home.persistence` ne fonctionne pas en standalone. Les
  dossiers persistants se déclarent côté système avec
  `environment.persistence."/nix/persist".users.<nom>`, et en ajouter un demande un déploiement
  système (`colmena apply`).
- **Racine en tmpfs** : sans le service `home-manager-<nom>` du module NixOS, les liens
  Home Manager situés hors des chemins persistés disparaissent au redémarrage. Il faut relancer
  `home-manager switch` au démarrage, ou prévoir un service de réactivation de la dernière
  génération.
- **Un seul gestionnaire par utilisateur** : ne pas activer en même temps le home via NixOS
  (`homeManager = true`) et en standalone, sinon les deux écrivent les mêmes fichiers.