class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.57.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.0/boltDB-v8.57.0-darwin-arm64"
      sha256 "0c300dfc52268168568d0b45b49765b60df5c0773e50cddf3b3f39839a885c23"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.0/boltDB-v8.57.0-darwin-amd64"
      sha256 "4ef93ecdbdf8581844d1a8b4b264a9c6a01f1e6e0924bf88d255333f19ca4c54"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.0/boltDB-v8.57.0-linux-arm64"
      sha256 "faa69ca7ce3fbb840e9273e11d7cf586cf6505feb4786a51060d715ca5f8316a"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.57.0/boltDB-v8.57.0-linux-amd64"
      sha256 "e4f389c9dd3fa6c532a88d48df95aff078b04f337ef9ccb5512a5b400f488851"
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
