class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.39.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.0/boltDB-v8.39.0-darwin-arm64"
      sha256 "117573d47f3151ddc2b6e0c2e363907a2dc52c3d3fb6e587f4a962b2978bda58"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.0/boltDB-v8.39.0-darwin-amd64"
      sha256 "d024fdfef8db44b7b330fb446a247709b89305e681074c413d39394524d1c4b5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.0/boltDB-v8.39.0-linux-arm64"
      sha256 "4386ec5f15439e76cb9da19c04b0643a9e76c8487be965d71349e99b06d21713"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.0/boltDB-v8.39.0-linux-amd64"
      sha256 "f10f9861746f8680910e7bf9109e573cb3b078edb0e8ced1303131c03a7704b0"
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
