class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.59.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.59.0/boltDB-v8.59.0-darwin-arm64"
      sha256 "1f761596980f98561583e2607af980c801d0bcdc4fb5cadeb5a31e78c3aefce5"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.59.0/boltDB-v8.59.0-darwin-amd64"
      sha256 "9ae6fe3a6404a0901ffc268f8b1b93e0f23251e776f240c3587813d03dafb80f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.59.0/boltDB-v8.59.0-linux-arm64"
      sha256 "bb613118bf3ef4dee94a23915185707b8bbfe2486f1df2d0ad10f133a1fdd28b"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.59.0/boltDB-v8.59.0-linux-amd64"
      sha256 "ae1c5f5bfa9ef214e65bdf9fb6efd6b4d2ce15fdfb75e1bdf8906bdde778c36c"
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
