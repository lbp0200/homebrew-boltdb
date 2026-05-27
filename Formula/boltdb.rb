class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.17.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.17.0/boltDB-v8.17.0-darwin-arm64"
      sha256 "2290cad510722f585e42f19137ca096b6a812a2000e6bf25bd2783b1044547bf"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.17.0/boltDB-v8.17.0-darwin-amd64"
      sha256 "eee96debd5de7544d1bba0d8ec0b500837dcccd00ad255e02d4548ae626095da"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.17.0/boltDB-v8.17.0-linux-arm64"
      sha256 "ee239f917b6634eda10fbe1c013d0bb6e3a77b41b84b369a27c4ee6f6668bf01"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.17.0/boltDB-v8.17.0-linux-amd64"
      sha256 "7a4507dc9aafb73e8a4695b0db720a1c5e0b7cc2fb69f12ff2e399a72a6d4b52"
    end
  end

  def data_dir
    OS.mac? ? "#{ENV["HOME"]}/Library/Application Support/boltdb" : "#{ENV["HOME"]}/.local/share/boltdb"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir "#{data_dir}" -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir @formula.data_dir
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
