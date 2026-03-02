class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-darwin-arm64"
      sha256 "9f8d2b05b365b11c07555c411958a9adc44698c23f5839800f12c6c330fff4db"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-darwin-amd64"
      sha256 "48fa6ab61023a36017783cb99979acc343518c56a24f1199bbc8a0735aab77a3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-linux-arm64"
      sha256 "6ea7dbd58670c75f0613fd875f3f3a9f4cceb261b88cde5b9e1a5854cf6e01e9"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.1/boltDB-v8.0.1-linux-amd64"
      sha256 "804b2f80627b1707f1f4b1c8c7061c42b1e1404ef58f6c0c2659ff45434374ec"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-8.0.1--" => "boltdb"
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
