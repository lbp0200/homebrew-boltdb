class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.31.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.31.0/boltDB-v8.31.0-darwin-arm64"
      sha256 "bcc7d01ae87c651ccf1764a70dfc8bf20b54d55504ce8d9da141037760387a2c"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.31.0/boltDB-v8.31.0-darwin-amd64"
      sha256 "2cd4ee3576c2e6cfaf3221acb787ff8cbce2506c2141875b37d07e11d087cc37"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.31.0/boltDB-v8.31.0-linux-arm64"
      sha256 "48a9b1cd139c56e9eb10344362ccd87ac2fdace880bf4a7236234a7ac499ea2a"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.31.0/boltDB-v8.31.0-linux-amd64"
      sha256 "e0d86f1e63c84cbd6476416ad79678c8ab18215eb1ebd0ab4285bf7bb61a34c6"
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
