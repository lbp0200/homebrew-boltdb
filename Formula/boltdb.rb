class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.9/boltDB-v8.0.9-darwin-arm64"
      sha256 "dd26eea7cb32a061531da0e12dc5ae986f6bdf65443f9d34e27c7049ad72bacf"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.9/boltDB-v8.0.9-darwin-amd64"
      sha256 "3d6bceb66b62412984ebeeeb5da59b0215080515e7806f67c4f27b9aaede9bd8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.9/boltDB-v8.0.9-linux-arm64"
      sha256 "fe11acfa125aeeddcd930bbcd7c466f19ebac6fba767fc6bebf45a9294c0fa8f"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.9/boltDB-v8.0.9-linux-amd64"
      sha256 "9ba8f5db4f7d9c57e45423580f80c9203d1b77b11c8809493810d3b92e93b5ab"
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
