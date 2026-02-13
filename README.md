# Homebrew Tap for BoltDB

This repository contains the Homebrew formula for [BoltDB](https://github.com/lbp0200/BoltDB).

BoltDB is a high-performance, disk-persistent key-value database fully compatible with the Redis protocol.

## Installation

```bash
# Add the tap
brew tap lbp0200/boltdb

# Install BoltDB
brew install boltdb
```

## Usage

```bash
# Start BoltDB
boltdb --dir=/usr/local/var/boltdb

# Or with custom options
boltdb --addr=:6380 --dir=/usr/local/var/boltdb --log-level info
```

## Upgrading

```bash
# Update formulas
brew update

# Upgrade BoltDB
brew upgrade boltdb
```

## Uninstalling

```bash
# Remove BoltDB
brew uninstall boltdb

# Remove tap
brew untap lbp0200/boltdb
```

## Options

| Flag | Description | Default |
|------|-------------|---------|
| `--dir` | Data directory | `./data` |
| `--addr` | Listen address | `:6379` |
| `--log-level` | Log level | `warning` |
| `--cluster` | Enable cluster mode | `false` |

## For Maintainers

When releasing a new version:

1. Update `version` in `Formula/boltdb.rb`
2. Download the release binary and calculate SHA256:
   ```bash
   shasum -a 256 boltDB-1.0.x-darwin-arm64
   shasum -a 256 boltDB-1.0.x-darwin-amd64
   shasum -a 256 boltDB-1.0.x-linux-arm64
   shasum -a 256 boltDB-1.0.x-linux-amd64
   ```
3. Update the SHA256 hashes in the formula
4. Commit and push:
   ```bash
   git add Formula/boltdb.rb
   git commit -m "Update to v1.0.x"
   git push
   ```
