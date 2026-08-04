class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.51.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.2/boltDB-v8.51.2-darwin-arm64"
      sha256 "31b884060ea7072be4bfa010228b3e2057909f232447c09c5516f5d28ed56ce2"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.2/boltDB-v8.51.2-darwin-amd64"
      sha256 "58294ba3f5770b1e0dd4fdff216f9a1ac7ec8eec4c05c36030e0e51c6f3b1316"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.2/boltDB-v8.51.2-linux-arm64"
      sha256 "ddc7d0a50587685dd3ea0a1887831f7ee27fc50eede065ec7a1d3c57a99db8b9"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.51.2/boltDB-v8.51.2-linux-amd64"
      sha256 "f6d0353081c04a73ff5744e2e9b430b767629f902e5bbf32b6e9b116352d8010"
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
