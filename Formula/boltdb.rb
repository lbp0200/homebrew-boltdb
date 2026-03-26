class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.8/boltDB-v8.0.8-darwin-arm64"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.8/boltDB-v8.0.8-darwin-amd64"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.8/boltDB-v8.0.8-linux-arm64"
      sha256 "d8ed2662690721f736d61ea2295b6d8cc53180a6fc0e7c2eaf4e80ef8b3ac6a5"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.8/boltDB-v8.0.8-linux-amd64"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
