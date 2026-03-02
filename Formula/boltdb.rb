class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-darwin-arm64"
      sha256 "f420ffe17a5989e725724d835f5489396c84a9a756ebe604d7fa4d0f1c56c4c1"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-darwin-amd64"
      sha256 "59db628da34b57e0bf2eb2fce986c265dc0e5862dc37867e773b365a5108c7d6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-linux-arm64"
      sha256 "439a970e725bc0e02bac0fda120be1091a0b66ab72699264ff4d618035f6afe0"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-linux-amd64"
      sha256 "3cde1599c644a87ed2e662f84c8a9a3a47a267003064406ca28ef646cc8d8b03"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v#{version}-#{os}-#{arch}" => "boltdb"
  end

  service do
    if OS.mac?
      dir = "#{ENV["HOME"]}/Library/Application Support/boltdb"
    else
      dir = "/var/lib/boltdb"
    end
    run [bin/"boltdb", "-dir", dir]
    keep_alive true
    working_dir dir
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
