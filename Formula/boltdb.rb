class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.4/boltDB-v8.0.4-darwin-arm64"
      sha256 "a53015e07a644f2d124d2d1c7ee02fd820a10f79b679889dd6ddf5eed49fa4a3"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.4/boltDB-v8.0.4-darwin-amd64"
      sha256 "98892b3e9e5998c9cf380112a04031339e6fe5dd685d397dba6ee1294593846c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.4/boltDB-v8.0.4-linux-arm64"
      sha256 "bd50b7a329708ed9e8363658f8f1ee8d0d5fe22269cfd499bb46af7d44ab8158"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.4/boltDB-v8.0.4-linux-amd64"
      sha256 "b4d0ce2fe1431c400873496443553da397ced3f102f4ab1af9ce0483d5bbe695"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir <%= OS.mac? ? '#{ENV["HOME"]}/Library/Application Support/boltdb' : '#{ENV["HOME"]}/.local/share/boltdb' %> -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir <%= OS.mac? ? '#{ENV["HOME"]}/Library/Application Support/boltdb' : '#{ENV["HOME"]}/.local/share/boltdb' %>
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
