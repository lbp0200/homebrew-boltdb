class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.57.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.2/boltDB-v8.57.2-darwin-arm64"
      sha256 "32085032547daa46926f70b0e3b9b847d763ad2ede59bc0e4d95f81aaf6e6523"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.2/boltDB-v8.57.2-darwin-amd64"
      sha256 "767cc32f54b513d05518a9d1ce6e359874aaa47773cfec8fe0dc0b6ea386e89f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.2/boltDB-v8.57.2-linux-arm64"
      sha256 "602333a0bdd6bd522c8ad082f222e18e56d219325ed5061ff9b984bd928f0490"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.2/boltDB-v8.57.2-linux-amd64"
      sha256 "88b6e882a63a347b9cd14a45a009d221e93a1ce6978e5f232e7e933da8087de6"
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
