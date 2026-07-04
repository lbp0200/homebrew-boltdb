class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.35.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.35.0/boltDB-v8.35.0-darwin-arm64"
      sha256 "a0b8de2c7f637f61fc4499280c298d41ade8aff66fc1a6d7fb8c057f4df215a6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.35.0/boltDB-v8.35.0-darwin-amd64"
      sha256 "a0d46fb7a9d082f70d6e7deec7a3024f3ba10dd395119169089ecae08c7af433"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.35.0/boltDB-v8.35.0-linux-arm64"
      sha256 "f0fac893837644c847202ec329b3dc5078cc4f6921047d8a587b85e6971f7aff"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.35.0/boltDB-v8.35.0-linux-amd64"
      sha256 "74c79a41d37637b3f38d7a512af72b36ca87dc46528764ba9f2c0734802074b4"
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
