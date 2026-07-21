class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.38.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.3/boltDB-v8.38.3-darwin-arm64"
      sha256 "f08060713682a11486b0aa1a783dc03d1b97435115fcda2a9cbef8a4c4e8d660"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.3/boltDB-v8.38.3-darwin-amd64"
      sha256 "325665a25888b0772043612e5d4599543495d3c50a3ce6e69448b3dcf23bc997"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.3/boltDB-v8.38.3-linux-arm64"
      sha256 "a985e56ea1abc33c190f07b384fb2cce54b142827b22ae7d76af1da042ce5cd7"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.3/boltDB-v8.38.3-linux-amd64"
      sha256 "0e4d5fa797cc8d0af9cc22f8a080791492777fa676e6f7eeb991e8c2b9724a6e"
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
