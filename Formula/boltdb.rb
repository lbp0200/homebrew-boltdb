class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.18.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.18.0/boltDB-v8.18.0-darwin-arm64"
      sha256 "9dd42082da8e6bcb34f50128d8c5e84818ca1aac0650b11fd4f6cf01a02802d6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.18.0/boltDB-v8.18.0-darwin-amd64"
      sha256 "825607a0f6ddb42a67148f2dc4b4e6d21777596696c21258d1d0aff51fa64e45"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.18.0/boltDB-v8.18.0-linux-arm64"
      sha256 "fb61f95ea0b45d1deba69acaa8366f0ccacf0aa1bab80068962d6e46dc8c109d"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.18.0/boltDB-v8.18.0-linux-amd64"
      sha256 "2d03ffd0b372701e0a4e3ae20adab75ac7f22971f2d62dbba7de9313ee7ca166"
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
