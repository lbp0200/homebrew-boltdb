class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.1.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.3/boltDB-v8.1.3-darwin-arm64"
      sha256 "8cb4f5efaae3af99c28f6addebcd5ab4ca67f6c5ce7cb846f32b6d846e4596ff"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.3/boltDB-v8.1.3-darwin-amd64"
      sha256 "b10d352e91a6ca7e0309020a5b9b72590a8082f2b5a3a70c96b69deac03144c7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.3/boltDB-v8.1.3-linux-arm64"
      sha256 "7e3bb6d50c9826723daf9c44a6f837ebb7c0383c17816509bde446965c2e9031"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.3/boltDB-v8.1.3-linux-amd64"
      sha256 "73fe4e7271ecceac3b62cd46b108a44c34e5d5d481cb214ae433ff817f751376"
    end
  end

  def data_dir
    OS.mac? ? "#{ENV["HOME"]}/Library/Application Support/boltdb" : "#{ENV["HOME"]}/.local/share/boltdb"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir "#{data_dir}" -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir @formula.data_dir
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
