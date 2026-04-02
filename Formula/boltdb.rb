class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.2/boltDB-v8.1.2-darwin-arm64"
      sha256 "4979035dd2067b919625792a0994d9dd8a0b81e0acaaa5560c192237fa186ddb"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.2/boltDB-v8.1.2-darwin-amd64"
      sha256 "5e2c98f6d9fbf3f5dff9a7c75039ea360f5c6bba36f67f9329993b35f9b2047c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.2/boltDB-v8.1.2-linux-arm64"
      sha256 "60149d905f3c385d8d0a0747a7203a17c5428f2ae2dff1ea2e3f99334de0e6f4"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.2/boltDB-v8.1.2-linux-amd64"
      sha256 "c61f2d79d485cc6766536b35a4648c059cc0ca7105d9e94f0731f7fd8e759d2d"
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
    working_dir data_dir
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
