class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.40.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.40.0/boltDB-v8.40.0-darwin-arm64"
      sha256 "d3e67f746d97081d8fb7f32fad5d04fa5344b93c2c51347305603139ac0410e0"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.40.0/boltDB-v8.40.0-darwin-amd64"
      sha256 "bd03c858b3e683573d57884e3e9a49d0c297cfb454d87df226b84431fb95ad38"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.40.0/boltDB-v8.40.0-linux-arm64"
      sha256 "542e85d2f24c30847337f6954a7a75b0db01673ddbbe6040909961cdad7bfbfb"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.40.0/boltDB-v8.40.0-linux-amd64"
      sha256 "fcb9dc713e7af0bb1d1d34fafa6b83d447f5337e025359ec7e23dc16f1e5edb2"
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
