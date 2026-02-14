class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.24"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.24/boltDB-v1.0.24-darwin-arm64"
      sha256 "e346b7fa2bdadcfc29668cc6c15af75d286c175843e90850ed4010d94965b191"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.24/boltDB-v1.0.24-darwin-amd64"
      sha256 "f750dd9c03f30442b7998f924a7446b27275afc1a981f28774f685964b94ff73"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.24/boltDB-v1.0.24-linux-arm64"
      sha256 "2bb090a2874863a3686a5d0523ac80d4b7fe07ef8936d545681821a52f948afc"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.24/boltDB-v1.0.24-linux-amd64"
      sha256 "723bf8bfb1a125c87ae4d2ce33e0be209c45d6a8bded6d9462a1752a6cf3dc37"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v1.0.24-#{os}-#{arch}" => "boltdb"
  end

  service do
    run bin/"boltdb"
    keep_alive true
    working_dir "/var/lib/boltdb"
    error_log_path "/var/log/boltdb.log"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
