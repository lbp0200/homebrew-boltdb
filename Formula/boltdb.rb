class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.2.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.2/boltDB-v8.2.2-darwin-arm64"
      sha256 "2fb697a1ec49cd65756974699f2d9c7702dce97bab7a03a2a511d9a9a86d6638"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.2/boltDB-v8.2.2-darwin-amd64"
      sha256 "41ee79ffa887e24cb6da9f4d5996a014cb1c447bcc001f27546b736ae2939519"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.2/boltDB-v8.2.2-linux-arm64"
      sha256 "f517d8bb90085d1ceee712cf1f5a78ca02d95482d2d3d6ec7963f7e0b5025620"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.2/boltDB-v8.2.2-linux-amd64"
      sha256 "db0d533777c7fb98f2c4aeb29eeae94d906938360bd95e719efdf90a96f883e2"
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
