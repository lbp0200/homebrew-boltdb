class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.22.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.22.0/boltDB-v8.22.0-darwin-arm64"
      sha256 "822635f962217028ae903cc6edc646159441cb8996494bf28fcb1cdc86637fbf"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.22.0/boltDB-v8.22.0-darwin-amd64"
      sha256 "77286f182932aacd72a9b988a3b9063d5667b299f51c636607c089ac1900a841"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.22.0/boltDB-v8.22.0-linux-arm64"
      sha256 "0855123c3c31dc61c1ba8b12a497a3b3b4dc0f8c124d93c91180c5663f62331e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.22.0/boltDB-v8.22.0-linux-amd64"
      sha256 "3f374e4abfbea8617a2b187b15fd08e231644e855affa76fdb9251659ed661fd"
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
