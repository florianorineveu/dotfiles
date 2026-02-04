# Dotfiles

Configuration personnelle pour un environnement de développement universel et efficace.

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/florianorineveu/dotfiles/main/install.sh | bash
```

### Installation personnalisée

```bash
# Cloner le dépôt
git clone https://github.com/florianorineveu/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Installation minimale (git, zsh, curl)
./install.sh --profile=minimal

# Installation complète
./install.sh --profile=full

# Prévisualiser sans exécuter
./install.sh --dry-run

# Sauvegarder la config actuelle avant installation
./install.sh --backup
```

## Packages installés

### Profil minimal

| Package | Description |
|---------|-------------|
| `git` | Contrôle de version |
| `zsh` | Shell moderne interactif |
| `curl` | Transfert de données |

### Profil complet

| Package | Description |
|---------|-------------|
| `bat` | Cat avec coloration |
| `btop` | Moniteur système élégant |
| `eza` | Ls moderne coloré |
| `fd` | Find ultra rapide |
| `fzf` | Fuzzy finder interactif |
| `git-delta` | Diff Git amélioré |
| `htop` | Gestionnaire de processus |
| `jq` | Processeur JSON CLI |
| `neovim` | Éditeur Vim moderne |
| `ripgrep` | Grep ultra performant |
| `thefuck` | Correction commandes auto |
| `tree` | Arborescence de fichiers |
| `wget` | Téléchargement HTTP/FTP |
| `zoxide` | Navigation répertoires intelligente |

## Configurations incluses

### Zsh

- **Prompt**: [Pure](https://github.com/sindresorhus/pure) — minimaliste et async
- **Plugins** (via [Zinit](https://github.com/zdharma-continuum/zinit)):
  - `zsh-autosuggestions` — suggestions basées sur l'historique
  - `fast-syntax-highlighting` — coloration syntaxique temps réel
  - `zsh-completions` — completions supplémentaires
- **Aliases** pour `git`, `eza`, `docker`, `fd`, `rg`...
- **Fonctions** utilitaires (`mkcd`, `dev`, `nobrainextract`)
- **Keybindings** mode vi

### Git

- Éditeur: `neovim`
- Stratégie pull: `rebase`
- Pager: `delta` avec thème Catppuccin Mocha
- Rerere activé (réutilisation des résolutions de conflits)
- Config locale supportée (`~/.config/git/config.local`)

### Bat

- Thème: Dracula
- Affichage: numéros de ligne, grille, indicateurs de changements

### SSH

- Ajout automatique des clés à l'agent
- Support Keychain macOS
- Config locale supportée (`~/.ssh/config.local`)

## Structure du projet

```
dotfiles/
├── bin/                 # Scripts utilitaires
├── config/              # Fichiers de configuration
│   ├── bat/            # Configuration bat
│   ├── git/            # Configuration git
│   ├── ssh/            # Configuration SSH
│   └── zsh/            # Configuration Zsh + plugins
├── lib/                # Fonctions shell partagées
│   ├── os.sh           # Détection OS
│   ├── packages.sh     # Gestion des packages
│   ├── symlinks.sh     # Gestion des symlinks
│   └── utils.sh        # Utilitaires communs
├── os/                 # Configs spécifiques par OS
│   ├── arch/           # Arch/Manjaro
│   ├── debian/         # Debian/Ubuntu
│   └── macos/          # macOS (Brewfile)
├── test/               # Tests automatisés (Docker)
└── install.sh          # Script d'installation principal
```

## Plateformes supportées

| OS | Gestionnaire | Status |
|----|--------------|--------|
| macOS | Homebrew | ✅ |
| Debian/Ubuntu | apt | ✅ |
| Arch/Manjaro | pacman | ✅ |
| WSL2 | apt/pacman | ✅ |

## Options d'installation

```
Options:
  --profile=PROFILE    Profil d'installation (minimal, full)
  --backup            Sauvegarder la configuration actuelle
  --no-packages       Créer uniquement les symlinks
  --dry-run           Prévisualiser sans exécuter
  --rollback          Restaurer la dernière sauvegarde
  -y, --yes           Mode non-interactif (CI)
  -h, --help          Afficher l'aide
```

## Configuration locale

Les fichiers `.local` permettent d'étendre la configuration sans modifier les dotfiles:

- `~/.zshrc.local` — configuration Zsh personnelle
- `~/.config/git/config.local` — user.name, user.email, signing key
- `~/.ssh/config.local` — hosts et clés SSH privés

## Licence

[WTFPL](http://www.wtfpl.net/) — Do What The Fuck You Want To Public License

---

Une petite ⭐ sur le repo fait toujours plaisir si ce dernier a pu t'être utile !
