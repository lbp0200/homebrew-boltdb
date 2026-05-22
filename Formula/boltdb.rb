class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.6.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.6.1/boltDB-v8.6.1-darwin-arm64"
      sha256 "268b6a3ee876364224e1186fd8264937fb28c55581e435f5b2becea93510a262"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.6.1/boltDB-v8.6.1-darwin-amd64"
      sha256 "8dea3414fca995d38c9e28035b2ee6f11c7a815ef6f0622b023125aaf62df9fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.6.1/boltDB-v8.6.1-linux-arm64"
      sha256 "f738d418105dd50b7c11da065f3832a95667e0668c1a4787fdd740f8fe2b9e05"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.6.1/boltDB-v8.6.1-linux-amd64"
      sha256 "ff84610fb4ab434fe0a71e9fada8e196ea4188b1192415af72a4378e2646fba7"
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
