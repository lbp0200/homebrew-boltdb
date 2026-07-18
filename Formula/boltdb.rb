class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.38.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.0/boltDB-v8.38.0-darwin-arm64"
      sha256 "7a62f37b41a1e392fcc334aad61fb6fb2f4bbf580ac55d7477b0b9cb104de815"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.0/boltDB-v8.38.0-darwin-amd64"
      sha256 "a86793c1f0e2823eb2ac262497f94dc5af6dea98e441ea9cda972f9c2fbf4c7f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.0/boltDB-v8.38.0-linux-arm64"
      sha256 "cbbdc77dc2d6eec957a99443416e7115738d18a25e1ec6e756029abe0d35b89b"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.0/boltDB-v8.38.0-linux-amd64"
      sha256 "a4f26c6f9f91d7981e33f9998ff00b603ca9099fdcfd9fbc7bf9d103a8d61898"
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
