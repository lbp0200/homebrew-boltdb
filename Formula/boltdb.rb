class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.30.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.30.0/boltDB-v8.30.0-darwin-arm64"
      sha256 "651df741ed6fa3325a4084c9bc9323854bea14de5dcad966f32f13cdbf0d9e63"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.30.0/boltDB-v8.30.0-darwin-amd64"
      sha256 "745e54926e62c5b43926cff1e0af52a0a20f50e7b1875ebefec559e025bb667e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.30.0/boltDB-v8.30.0-linux-arm64"
      sha256 "b8aecb4cd8b014d248cf2ef7ed4a3dc1c903250e05d22758f3c5c4795ec434eb"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.30.0/boltDB-v8.30.0-linux-amd64"
      sha256 "31d49a9af9890ca72dd8a80b3a75cb5ec09c3ce5ff16ed2643546c4be8588b3f"
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
