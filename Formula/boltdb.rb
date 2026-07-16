class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.37.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.37.0/boltDB-v8.37.0-darwin-arm64"
      sha256 "2131df02465e8c989d3d4815e4064a0dec2c06929cfb0726d9389e567b2481f6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.37.0/boltDB-v8.37.0-darwin-amd64"
      sha256 "1e3bb9d9cdcb8e0993007dee64575608a9be9eaf32999c89ac0ea70224b6c178"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.37.0/boltDB-v8.37.0-linux-arm64"
      sha256 "29e99ab56465b779ffc87b60540aefe41b37b1c999a127156f272cae21cce837"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.37.0/boltDB-v8.37.0-linux-amd64"
      sha256 "bd2fd5a2748cfe58dcba73264b15539f1ddd01d035fbb5162c8765716375594b"
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
