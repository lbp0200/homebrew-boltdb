class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.18"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.18/boltDB-v1.0.18-darwin-arm64"
      sha256 "c0499e4663382730967359cdc36115a8092b0b00458e79fe492aee133e8d34a7"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.18/boltDB-v1.0.18-darwin-amd64"
      sha256 "2397fcb228980c9277adb8ac19c8efe1e8784b2e707271b51a4ea1e7435f77e5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.18/boltDB-v1.0.18-linux-arm64"
      sha256 "b7a1e0ae266c4a2f34594be56d50fac6a8b13dabba4573f4625abfb1315306c6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.18/boltDB-v1.0.18-linux-amd64"
      sha256 "95db82c44e464becf380ae2cfb7da944bc5b8d6477e539131192d217d3a9dfdd"
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
