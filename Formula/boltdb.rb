class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.23"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.23/boltDB-v1.0.23-darwin-arm64"
      sha256 "e0422a6f30b96d5a429c43aeefdb6b49a3a8432778e7b86adcdd6c51c41c9747"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.23/boltDB-v1.0.23-darwin-amd64"
      sha256 "8a76e045a00d0f5e2f7cb6d01d50431765871f773b9458433649ee4d3d438bf3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.23/boltDB-v1.0.23-linux-arm64"
      sha256 "0ed1d86c71a22c90729b59944eb2307dfa512caac17dc78f706f89226e9d2e97"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.23/boltDB-v1.0.23-linux-amd64"
      sha256 "b4fc13c4dd9aed8b10348bc35d9cb30a9d92662d208430584a1732c43659ab77"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v1.0.23-#{os}-#{arch}" => "boltdb"
  end

  service do
    run bin/"boltdb"
    keep_alive true
    working_dir "/var/lib/boltdb"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
