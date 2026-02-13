class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.2/boltDB-1.0.2-darwin-arm64"
      sha256 "c47e8060aec67d8bb6f9abe15ceed01adc5e1535a797b4e6fcbc3d33ed8d875f"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.2/boltDB-1.0.2-darwin-amd64"
      sha256 "REPLACE_WITH_ACTUAL_SHA256"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.2/boltDB-1.0.2-linux-arm64"
      sha256 "REPLACE_WITH_ACTUAL_SHA256"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.2/boltDB-1.0.2-linux-amd64"
      sha256 "REPLACE_WITH_ACTUAL_SHA256"
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
