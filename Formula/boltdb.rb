class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.58.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.0/boltDB-v8.58.0-darwin-arm64"
      sha256 "174c3ebb3b3cd862b54e272c4590c1f7a51bdf6a8ae52e94c2d60a708a32f6c1"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.0/boltDB-v8.58.0-darwin-amd64"
      sha256 "29ccf9bcceaae5144930562357a4e1b013945a192ce2a5c9e53f8c60b3aeb46b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.0/boltDB-v8.58.0-linux-arm64"
      sha256 "bfcdb4723dc35ff3835566c1ebf66986229ef83d4b068f58830d6037ac64e0b6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.0/boltDB-v8.58.0-linux-amd64"
      sha256 "d2941f06f19ef67714f1e07995fa919dc98bf8282be7972fea619f85e2c7e0b6"
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
