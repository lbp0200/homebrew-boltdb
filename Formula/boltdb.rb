class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.19"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.19/boltDB-v1.0.19-darwin-arm64"
      sha256 "e3b379399e5abd6dd5d80575a7791b94ca346c248e494217da85c0e911c5a3ec"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.19/boltDB-v1.0.19-darwin-amd64"
      sha256 "c08130eb968a78d75077e79b69317ca0f7fa4a9a3c9a757b562af1ec709c9a2a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.19/boltDB-v1.0.19-linux-arm64"
      sha256 "a979c721fbbf349146ada27c5aedb6af042c09b92ed8ef6cf34696120a68aca3"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.19/boltDB-v1.0.19-linux-amd64"
      sha256 "a47fb802d3f8b199603415874421ab9d4a68e742e2f322cc9ce851e08b249544"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v1.0.19-#{os}-#{arch}" => "boltdb"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
