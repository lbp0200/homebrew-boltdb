class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.0/boltDB-v8.0.0-darwin-arm64"
      sha256 "de163d02ec37e869c9fb224b2fdc326392ae4b55b45b33e98068eaa05c4c925e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.0/boltDB-v8.0.0-darwin-amd64"
      sha256 "ff85b41b18dcd660b71aba644ad89c94d4dd727b0e0147853a074a8be44df867"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.0/boltDB-v8.0.0-linux-arm64"
      sha256 "cbc0bb83fa2c3dd32221de5a0ded4a691e1547763919f2da2ab8b0c4fea926e6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.0/boltDB-v8.0.0-linux-amd64"
      sha256 "602ec9bedf3723d242274e1aadc9f83da7821bb80920fcaa296c6964587fc73f"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-8.0.0--" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir /var/lib/boltdb -addr 0.0.0.0:6379
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir "/var/lib/boltdb"
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
