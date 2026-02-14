class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.26"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.26/boltDB-v1.0.26-darwin-arm64"
      sha256 "6d8a872bcdd79fb78036ef2207ec4e31c7e34bf2b003c01605e60278d3978af3"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.26/boltDB-v1.0.26-darwin-amd64"
      sha256 "f180ae157e3bb399d8bb28dd9d9ac7fe7e585fabf2762c04a00bdf94548d0df5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.26/boltDB-v1.0.26-linux-arm64"
      sha256 "8e6b277ac171154bd53e5c1cc85ae885055d437f188839b38ca672bda22d34e9"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.26/boltDB-v1.0.26-linux-amd64"
      sha256 "4ed9676e68d68de37a6fe573df55a032d6d72db52296f1d7de5fd785aa4f432e"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-1.0.26--" => "boltdb"
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
