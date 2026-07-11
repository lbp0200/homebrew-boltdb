class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.36.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.36.0/boltDB-v8.36.0-darwin-arm64"
      sha256 "ac1d00ad52be7ff93fe54e3a0a1066d9682d08703a094ad761bb0042129a6c70"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.36.0/boltDB-v8.36.0-darwin-amd64"
      sha256 "421150eec31a16116a1749bee76b4cba49ff33a47350a32de89071d730e2857a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.36.0/boltDB-v8.36.0-linux-arm64"
      sha256 "087ab32938d0db26ae42203b75998933f223c9a759d75a57c9b01bf7dbdb5f9b"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.36.0/boltDB-v8.36.0-linux-amd64"
      sha256 "2acb32daafb1be77b172f2a2c0d76f9f4f2bb38e4b028682b31f9472707b85d3"
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
