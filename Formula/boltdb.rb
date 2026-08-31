class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.57.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.1/boltDB-v8.57.1-darwin-arm64"
      sha256 "89d9869879c38d4da92501ef054c879983c79f639a84c38283a0cc7c4c499eac"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.1/boltDB-v8.57.1-darwin-amd64"
      sha256 "3f0ee98f25aa2b9598af933725f7ae1460ce6bb5aadfc5a446c887de3c46141b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.1/boltDB-v8.57.1-linux-arm64"
      sha256 "40bfd75536958315b47231c148a5088d2b93029f24f6e27903ad324caea16fde"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.1/boltDB-v8.57.1-linux-amd64"
      sha256 "f33c43eab2b094a5cc009a8e7ad307c6790f5d3be5c01a4e999cedd69fe18c0b"
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
