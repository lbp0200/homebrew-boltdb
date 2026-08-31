class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.57.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.3/boltDB-v8.57.3-darwin-arm64"
      sha256 "350ed258e4481be049d900d289f0fb9ec451dd1e3efb562bca27fde967e3a84a"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.3/boltDB-v8.57.3-darwin-amd64"
      sha256 "ed1bbfb91995f644e52eac561de2ea9267e25cb70f3385b5824a5d43953f4292"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.3/boltDB-v8.57.3-linux-arm64"
      sha256 "f632248244a6af0adeb57fd9223518c3bd398ab491607f47cf890bfddc49b860"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.3/boltDB-v8.57.3-linux-amd64"
      sha256 "a1e4397db5efb9237e5ee1390380805f4c528d38ec3f0a777f27acc8bf0954ec"
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
