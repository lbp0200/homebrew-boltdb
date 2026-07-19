class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.38.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.1/boltDB-v8.38.1-darwin-arm64"
      sha256 "573292a2a96106b27e3a773c7b2af0c3f4d1d6cd0057497c8dd24ac3905a721f"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.1/boltDB-v8.38.1-darwin-amd64"
      sha256 "f7b87da66a88da7234c72f4f0de306427c124a1c2b56b1f7d6f9f6f1590a43dc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.1/boltDB-v8.38.1-linux-arm64"
      sha256 "f486d121ee292418638425ed7b9592cc692737433b7163821b82dd2dff88641d"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.1/boltDB-v8.38.1-linux-amd64"
      sha256 "208c4358c338d996cc4bb0a5cb7a1219aee1eb760ca2a2c583f0928d34722a50"
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
