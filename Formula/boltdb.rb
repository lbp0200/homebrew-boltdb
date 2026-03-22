class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.7/boltDB-v8.0.7-darwin-arm64"
      sha256 "307145c185a07c65835629fa32d05cc4a25e7bdf106f0a59624e38ca4c5da2f1"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.7/boltDB-v8.0.7-darwin-amd64"
      sha256 "d8249c1d218325c83db2271bf6b0ef980fa2baa6de3b8b7a2ba5448244bd7351"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.7/boltDB-v8.0.7-linux-arm64"
      sha256 "427d923019825c5a01d3092d85cd957260f11c6f9d5d33aed7112a05cdc62d2a"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.7/boltDB-v8.0.7-linux-amd64"
      sha256 "741e0903dd962e4becec6ebdfd3c377029dc73e14059b017d923ced7955a44c2"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir "<%= OS.mac? ? '#{ENV["HOME"]}/Library/Application Support/boltdb' : '#{ENV["HOME"]}/.local/share/boltdb' %>" -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir "<%= OS.mac? ? '#{ENV["HOME"]}/Library/Application Support/boltdb' : '#{ENV["HOME"]}/.local/share/boltdb' %>"
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
