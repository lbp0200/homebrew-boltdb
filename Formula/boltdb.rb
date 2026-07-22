class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.39.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.1/boltDB-v8.39.1-darwin-arm64"
      sha256 "9d097f06ed137ac25effc440eb69b7ba84d16594c68c5b283c05ecb7acc342d8"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.1/boltDB-v8.39.1-darwin-amd64"
      sha256 "8c8cf3cce18ef46f403b33e048617d883098c13da0142ab1f011a4bbe5f524bd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.1/boltDB-v8.39.1-linux-arm64"
      sha256 "999a9642aed81efa5bb81122a694f129a748d9d6ec02a15c825bf6cbfe070312"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.39.1/boltDB-v8.39.1-linux-amd64"
      sha256 "287e7d355b51b6312da398dd5e2f3948585b7ad62cb19a017ad97cf643e95333"
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
