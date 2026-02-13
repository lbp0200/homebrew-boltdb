class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.13"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.13/boltDB-1.0.13-darwin-arm64"
      sha256 "18b687403fc90685fc4385a40fea59ca7becf00f0badef90020b0255baea7480"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.13/boltDB-1.0.13-darwin-amd64"
      sha256 "10e58dcf7d10984f88a5ced38aadc2ec8e45bca92d40f6d15fd090cb843dc0b7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.13/boltDB-1.0.13-linux-arm64"
      sha256 "9a769a9c837c17eb762e17253e19fa27e8203e4d78bee266ff1ffea9daea66cd"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.13/boltDB-1.0.13-linux-amd64"
      sha256 "b9b08c99c323598ee8ee0a383f55d36fffab6c3b807d1a5057897b837b78c00f"
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
