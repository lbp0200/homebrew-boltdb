class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.50.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.50.0/boltDB-v8.50.0-darwin-arm64"
      sha256 "12fb3cc7a3ac46dd11f592ec63717ef8c4ffd45d5673bb181b8ad53b464c5c09"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.50.0/boltDB-v8.50.0-darwin-amd64"
      sha256 "66e55055a6ae1e927ba55c101b3b632af0c639ee80b1a4b482a9c7b2f76177fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.50.0/boltDB-v8.50.0-linux-arm64"
      sha256 "62ce95aa172f3b4316d0d2a87414d3704ddcd3f2a91e7a3da5b270d3d19e22a3"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.50.0/boltDB-v8.50.0-linux-amd64"
      sha256 "4f5f3a6af64540e3ec85aa98d867e6aa024fc44debc938e988bf6a8637784a7b"
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
