class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.38.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.2/boltDB-v8.38.2-darwin-arm64"
      sha256 "ed412e150d5a59b92c8863ad490bcc86921ff9eaa46b6da7a7271cd93f784ef6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.2/boltDB-v8.38.2-darwin-amd64"
      sha256 "728adba321d477ab875c2dabd454ef12d880582eda4f65aab9f4bb350a8c79df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.2/boltDB-v8.38.2-linux-arm64"
      sha256 "aeee80925ab313763d01a3abc678a75af75e371a64bbe298b1d9f422b28b2b83"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.38.2/boltDB-v8.38.2-linux-amd64"
      sha256 "54799b7cfcd9ccce514ae61d6d10785c76b473a11a93c037b64f3048f2eb74a0"
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
