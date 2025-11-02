# Quick Reference

## Common Commands

```bash
# Deploy configuration
nh os switch .#hostname

# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Clone with submodules
git clone --recursive <repo-url>

# Update all submodules
git submodule update --remote --merge

# Add new host submodule
git submodule add <url> hosts/hostname
```

## Repository Structure

```
nixos-config/              # Main repo 
├── flake.nix              # Orchestrates everything
├── common/                # Shared modules & users
│   ├── default.nix
│   └── users/             # ← User configs here!
│       └── perihelie.nix
└── hosts/                 # Git submodules
    └── hostname/          # Private host repo
        ├── flake.nix
        ├── configuration.nix
        ├── hardware-configuration.nix
        └── overrides/     # (Optional) Host-specific user tweaks
            └── perihelie.nix
```

## Workflow

1. **Edit host config:**
   ```bash
   cd hosts/hostname
   vim configuration.nix
   git commit -am "Update"
   git push
   ```

2. **Update main repo:**
   ```bash
   cd ../..
   git add hosts/hostname
   git commit -m "Update hostname"
   ```

3. **Deploy:**
   ```bash
   nh os switch .#hostname
   ```

4. **Edit shared user config:**
   ```bash
   vim common/users/perihelie.nix
   git commit -am "Update perihelie"
   # Affects ALL hosts using this user!
   nh os switch .#hostname
   ```

# Deployment Guide

## Initial Setup

### 1. Create Main Repository

```bash
mkdir nixos-config
cd nixos-config
git init

# Create directory structure
mkdir -p common/users hosts
```

### 2. Add Shared User Configurations

Create user configs in the main repo (shared across all hosts):

```bash
# Create shared user config
cat > common/users/perihelie.nix << 'EOF'
{ config, pkgs, inputs, ... }:
{
  home.username = "perihelie";
  home.homeDirectory = "/home/perihelie";
  home.stateVersion = "24.05";
  
  # Your shared user configuration...
  programs.git = {
    enable = true;
    userName = "perihelie";
    userEmail = "perihelie@example.com";
  };
  
  programs.home-manager.enable = true;
}
EOF
```

### 3. Add Main Flake

Create the main `flake.nix` in the root with the content provided.

### 3. Create Common Modules (Optional)

```bash
# Create common/default.nix with shared settings
touch common/default.nix
touch common/packages.nix
```

### 4. Create Host Repository (as Git Submodule)

Each host gets its own repository:

```bash
# Create host repo
mkdir ~/perikon-config
cd ~/perikon-config
git init

# Create host structure
touch flake.nix configuration.nix hardware.nix
mkdir users
touch users/youruser.nix

# Add files and commit
git add .
git commit -m "Initial host config"

# Optional: push to remote
git remote add origin <your-git-url>
git push -u origin main
```

### 5. Add Host as Submodule

Back in main repo:

```bash
cd ~/nixos-config

# Add host as submodule
git submodule add <perikon-repo-url> hosts/perikon

# Or for local testing:
git submodule add ~/perikon-config hosts/perikon

# Commit
git add .
git commit -m "Add perikon host"
```

### 6. Generate Hardware Configuration

On the target machine:

```bash
# Generate hardware config
nixos-generate-config --show-hardware-config > /tmp/hardware.nix

# Copy to your host repo
cp /tmp/hardware.nix ~/nixos-config/hosts/perikon/hardware.nix
```

## Deploying Configuration

### Using nh (Recommended)

```bash
# From main repo root
cd ~/nixos-config

# Build and switch
nh os switch .#perikon

# Just build (no activation)
nh os build .#perikon

# Test (reverts on reboot)
nh os test .#perikon
```

### Using nixos-rebuild

```bash
# From main repo root
sudo nixos-rebuild switch --flake .#perikon
```

## Managing Multiple Hosts

### Adding a New Host

1. **Create new host repository:**
```bash
mkdir ~/newhost-config
cd ~/newhost-config
git init

# Copy structure from existing host
cp -r ~/perikon-config/* .
# Edit files for new host
git add .
git commit -m "Initial config"
```

2. **Add as submodule:**
```bash
cd ~/nixos-config
git submodule add <newhost-repo-url> hosts/newhost
```

3. **Update main flake:**
```nix
# In flake.nix, add to hosts list:
hosts = [ "perikon" "newhost" ];
```

4. **Deploy:**
```bash
nh os switch .#newhost
```

## Using the Same User on Multiple Hosts

Since user configs are in the **main repo** (`common/users/`), you can easily use the same user across machines:

### Basic: Same Config Everywhere

In each host's `configuration.nix`:

```nix
# hosts/perikon/configuration.nix
users.users.perihelie = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" ];
};

home-manager.users.perihelie = homeModules.perihelie;  # ← Same shared config
```

```nix
# hosts/laptop/configuration.nix
users.users.perihelie = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" ];
};

home-manager.users.perihelie = homeModules.perihelie;  # ← Same shared config
```

Now `perihelie` has identical config on both machines!

### Advanced: Host-Specific Overrides

Create `overrides/perihelie.nix` in a host repo for machine-specific customizations:

```nix
# hosts/perikon/configuration.nix
home-manager.users.perihelie = {
  imports = [
    homeModules.perihelie           # Shared config
    ./overrides/perihelie.nix       # Host-specific additions
  ];
};
```

```nix
# hosts/perikon/overrides/perihelie.nix
{ config, pkgs, ... }:
{
  # Add packages only on this machine
  home.packages = with pkgs; [ obs-studio ];
  
  # Different monitor setup
  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,2560x1440@144,0x0,1"
  ];
}
```
### Updating a Host Configuration

```bash
# Navigate to host submodule
cd ~/nixos-config/hosts/perikon

# Make changes
vim configuration.nix

# Commit in submodule
git add .
git commit -m "Update config"
git push

# Update main repo to point to new commit
cd ~/nixos-config
git add hosts/perikon
git commit -m "Update perikon config"

# Deploy
nh os switch .#perikon
```

### Updating All Hosts

```bash
cd ~/nixos-config

# Update all submodules to latest
git submodule update --remote --merge

# Or update specific host
git submodule update --remote --merge hosts/perikon

# Commit and deploy
git add .
git commit -m "Update host configs"
nh os switch .#perikon
```

### Updating Shared User Config

Since user configs are in the main repo, updating them affects all hosts:

```bash
cd ~/nixos-config

# Edit shared user config
vim common/users/perihelie.nix

# Commit
git add common/users/perihelie.nix
git commit -m "Update perihelie config"

# Deploy to any/all hosts using this user
nh os switch .#perikon
nh os switch .#laptop
```

## Updating Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input hyprland

# Deploy updated config
nh os switch .#perikon
```

## Cloning on New Machine

```bash
# Clone with submodules
git clone --recursive <main-repo-url> ~/nixos-config

# Or if already cloned:
git submodule init
git submodule update

# Deploy
cd ~/nixos-config
nh os switch .#perikon
```

## Tips

### Keep Submodules Minimal
Each host submodule should only contain:
- `flake.nix` - Host flake definition
- `configuration.nix` - System configuration
- `hardware.nix` - Hardware config
- `overrides/` - (Optional) Host-specific user overrides

**Don't** put user configs in host repos - they go in `common/users/` in the main repo!

### Use Common Modules Sparingly
Only put truly shared configuration in `common/`. Most config should be host-specific.

### Private Repositories
For sensitive configs (secrets, API keys), keep host repos private:
```bash
git submodule add git@github.com:user/private-host.git hosts/perikon
```

### Deployment from Remote
```bash
# Deploy to remote host via SSH
nh os switch .#perikon --hostname user@perikon.local
```

### Development Shell
```bash
# Enter dev shell with tools
nix develop

# Now you have git, nh, nixos-rebuild available
```

## Troubleshooting

### Submodule not updating
```bash
git submodule update --init --recursive
```

### Host not found
Check that:
1. Host name is in `hosts = [ ... ]` list in main flake
2. Submodule exists at `hosts/hostname/`
3. Host flake exports correct configuration name

### Permission denied
```bash
# Ensure you have SSH keys set up for private repos
ssh-add ~/.ssh/id_ed25519
```
