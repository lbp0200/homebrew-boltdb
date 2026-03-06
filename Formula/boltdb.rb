class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.6/boltDB-v8.0.6-darwin-arm64"
      sha256 "bf9c95a80955f7e191b23039bfa513254430d1a22bd5446926d2c27aeb33ec6d"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.6/boltDB-v8.0.6-darwin-amd64"
      sha256 "f060c97b849df736da8901b2bdb113ce633f40ae7d65b6c750a036b626956131"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.6/boltDB-v8.0.6-linux-arm64"
      sha256 "3a8bbc6765c96bb0af46646d1d80a99c8d5fff8334def7ef297eb7dc3f8a3aaa"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.6/boltDB-v8.0.6-linux-amd64"
      sha256 "60a7f5c2088abb0a70311cf6b00dd420ab069ce7c3f143a4df646e5a4ff23bfa"
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
