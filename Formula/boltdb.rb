class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.27"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.27/boltDB-v1.0.27-darwin-arm64"
      sha256 "b0f8e22d525c6d8f95b1fdb839ea7504d70d1363a61fbcc5dc446142850c45ac"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.27/boltDB-v1.0.27-darwin-amd64"
      sha256 "f7862d1490f7270ff6a5ccf0c25f177716abe84361215ae9938d3374c9406695"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.27/boltDB-v1.0.27-linux-arm64"
      sha256 "1fcc27df20844b619f71169daf7ddcc6fc90b2cf2307ebc4578e1b8fc4f6652e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.27/boltDB-v1.0.27-linux-amd64"
      sha256 "570fbe344a71cb79bc64fc52004b4aaf2af90f729ab8595472523fad86a4e7de"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-1.0.27--" => "boltdb"
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
