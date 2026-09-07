class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.58.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.1/boltDB-v8.58.1-darwin-arm64"
      sha256 "b1c2674af47296595a022f1e1065c301a479a428e814ef99c0249c02c38b4c70"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.1/boltDB-v8.58.1-darwin-amd64"
      sha256 "e74079f59e824ca277839c872d3aa50d1268c1357fce4303033c894501ac411f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.1/boltDB-v8.58.1-linux-arm64"
      sha256 "b0a3f9eaa102ff144b6e2ead938832138f697894962fae1a01a17d59dfd7de3e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.58.1/boltDB-v8.58.1-linux-amd64"
      sha256 "ddba99503b71ffe1df77922231fccdc288113eddbeaf6d999299c54ba3509481"
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
