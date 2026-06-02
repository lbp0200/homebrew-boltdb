class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.19.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.19.0/boltDB-v8.19.0-darwin-arm64"
      sha256 "cf1cdc783798829da59bcc4485d700b8a6fd9047fdfa87a3c85430c0819387b9"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.19.0/boltDB-v8.19.0-darwin-amd64"
      sha256 "4a1ceb627a9c3cdca794561596cf54490849a951adfa691990861bcaf5a3c5ff"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.19.0/boltDB-v8.19.0-linux-arm64"
      sha256 "0efee3df1f1e8684a40a023110c4fd5f31ce746995bffc1529b65e4abb9b2c44"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.19.0/boltDB-v8.19.0-linux-amd64"
      sha256 "792e7d0c484d8fee6c9b03bbc9adc5ca3908dbe2300d195fd4f21f8e45416905"
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
