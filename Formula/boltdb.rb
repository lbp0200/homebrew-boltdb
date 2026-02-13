class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.8/boltDB-1.0.8-darwin-arm64"
      sha256 "e2f410ab2d55b87597113d34baa74d83b19a68682ac6e1e0389c609db716fc52"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.8/boltDB-1.0.8-darwin-amd64"
      sha256 "f6be20802d66eefb92f75716ec37e529385af5278ee7adb42356876f503b6a6a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.8/boltDB-1.0.8-linux-arm64"
      sha256 "9e45cd396fa2086e9ca1498548ab3fcd8aaf833ee1d90b42a09dc3697accb491"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.8/boltDB-1.0.8-linux-amd64"
      sha256 "bf24119deb1e82ad415451abca6759fd82c41b561fe1bc07d1a98ed988a4ed30"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-#{version}-#{os}-#{arch}" => "boltdb"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
