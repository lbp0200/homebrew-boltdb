class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.15.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.15.0/boltDB-v8.15.0-darwin-arm64"
      sha256 "c0b64d4d7aaeb62c958f72d9311721f14858c4df82315817db57e4f93a60d899"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.15.0/boltDB-v8.15.0-darwin-amd64"
      sha256 "f87d03d3a91dbc77ac518a3c1e24fead6456681ca4cf90f44f5d214db6f9c516"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.15.0/boltDB-v8.15.0-linux-arm64"
      sha256 "f0250e0e79b7f24184f4f02a19717cdd7c01277ada83476aa48d5127f9267ce5"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.15.0/boltDB-v8.15.0-linux-amd64"
      sha256 "1bd1e1c81404edfbbe262bb048952494f8f60b0bc4358aeb989cff0fc6c72efa"
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
