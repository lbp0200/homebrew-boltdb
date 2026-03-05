class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-darwin-arm64"
      sha256 "81024f3bd6b12867a043297412efb7487a68ac13b4cc155db68683cc44e7a718"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-darwin-amd64"
      sha256 "ca21cd8b29da3b6a54d3b4f25a1b703c1d5cfeed080c9e9f766f02e7c05391cb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-linux-arm64"
      sha256 "829d8c1ef8dc0800e2eba3141cc350140fdb4fb3ed452c7cadf6f242e76866fb"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-linux-amd64"
      sha256 "951cf33b8d396b861e31d52f4b80f7f95923dfffc513bea45a4fe35c3b17b13f"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v8.0.2-#{os}-#{arch}" => "boltdb"
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
