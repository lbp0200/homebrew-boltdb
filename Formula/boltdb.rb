class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.51.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.1/boltDB-v8.51.1-darwin-arm64"
      sha256 "af60a05da6790bb47e46354d35a1d4d5eed9fc6005ffcc1a68386449b874c48b"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.1/boltDB-v8.51.1-darwin-amd64"
      sha256 "3414025a978a4b8c807a44a68967b79a678a2058283db4522b4bc6fdc8aa900e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.1/boltDB-v8.51.1-linux-arm64"
      sha256 "9f248df320115a8bd30595c2a81b27bd692e06762a4d6e38611d09d59fea99a8"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.1/boltDB-v8.51.1-linux-amd64"
      sha256 "a9528c2ba73cec061dd61b9d0b06934eb51cb6570c0ee2bbb315f5d06d2b388e"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
    dir = OS.mac? ? "${HOME}/Library/Application Support/boltdb" : "${HOME}/.local/share/boltdb"
      exec "#{bin}/boltdb" -dir "#{dir}" -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir Dir.home + (OS.mac? ? "/Library/Application Support/boltdb" : "/.local/share/boltdb")
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
