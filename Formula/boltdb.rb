class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.14.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.14.0/boltDB-v8.14.0-darwin-arm64"
      sha256 "64d151fd199e3bbac56a69e5bef7c3e8c4a0dc8c8b12df87dbcc871fe3d4ca94"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.14.0/boltDB-v8.14.0-darwin-amd64"
      sha256 "7df2e0fef2984b6bd38e540f254a5226e2e1a974f01bc36623e8d2973f70366e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.14.0/boltDB-v8.14.0-linux-arm64"
      sha256 "69339c5419b7ccab09a408ed31cc9cfa2cbc33a523dd520a2cce96e7215575f5"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.14.0/boltDB-v8.14.0-linux-amd64"
      sha256 "109ed17b04f58dbf89c430f5a411829dce2b55ae1e925271bd968628335ac5bf"
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
