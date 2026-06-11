class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.21.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.21.0/boltDB-v8.21.0-darwin-arm64"
      sha256 "7e0279351ee469d9c5a902fb2d80a36fdec56ac8602b6c44a13cc95975a13e0e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.21.0/boltDB-v8.21.0-darwin-amd64"
      sha256 "3bba08a58052a946fbdf53d075a44e8947c34f9fe114d51daf742de64324e637"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.21.0/boltDB-v8.21.0-linux-arm64"
      sha256 "7d1496992485f1394eb24b7ec5db8f14a9bc4b2d67eac8b0efb74dff7f9b8a1e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.21.0/boltDB-v8.21.0-linux-amd64"
      sha256 "7e027e0a9f97b4f0081bfbde48ee107eb093d8a00cb04640398d833692df365c"
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
