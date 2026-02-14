class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.20"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.20/boltDB-v1.0.20-darwin-arm64"
      sha256 "d01d45b2fcbbad3ec31f1a37bc114e0acefbedad12ef765338707bd6f79122a4"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.20/boltDB-v1.0.20-darwin-amd64"
      sha256 "cabc18b313fefbfa6ffe2d96e66503b5c511d0d10c3ec05d10373feaec8446ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.20/boltDB-v1.0.20-linux-arm64"
      sha256 "ee093eae9ff442e88ed12920b18f3569880c7176cd3b9fe61c7f07da5283420f"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.20/boltDB-v1.0.20-linux-amd64"
      sha256 "3acaba308324aa3bbcc4a7f63f73d3ab5d7a4ba490a1955677592b8b0d429a91"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v1.0.20-#{os}-#{arch}" => "boltdb"
  end

  service do
    run opt_bin/"boltdb"
    keep_alive true
    run_args << "-dir" << "var/lib/boltdb"
    log_path "var/log/boltdb.log"
    error_log_path "var/log/boltdb.err.log"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
