class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.60.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.60.0/boltDB-v8.60.0-darwin-arm64"
      sha256 "a2487459c46162a6e6f2f51e219d4c29f56336e5309ea78b39a9b0aa5a10e788"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.60.0/boltDB-v8.60.0-darwin-amd64"
      sha256 "766b08bceaa9e6722f1f0b95ce1a55e2760042d4f4a0341b86e8c39b8ee0dd16"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.60.0/boltDB-v8.60.0-linux-arm64"
      sha256 "6ebb3fc97c9fa298d50cb76fd69e33ed913b9407e0273df90a1f018183f8da90"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.60.0/boltDB-v8.60.0-linux-amd64"
      sha256 "6540645c048381c7c618d14894b78822a396fd5f5f216b7ea02df8d029f91884"
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
