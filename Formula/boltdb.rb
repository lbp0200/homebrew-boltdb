class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-darwin-arm64"
      sha256 "43f0f612d903c469a54ce03bb203b0114eb1a3f7d0a848944fe33413c0fbfc46"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-darwin-amd64"
      sha256 "a4c4d04a2e40b7f942608e4aa149fd6e9cc66d375fa0e448b1475beb3fcaff13"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-linux-arm64"
      sha256 "8a8887b804aafd0c89e98f6fa0a6166842a06b0907fb672edc3936ce592ca51d"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.2/boltDB-v8.0.2-linux-amd64"
      sha256 "e0feeddfa5f78e713339b000c5fec3653757e43b57b349864e023c94d02dc74b"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir <%= OS.mac? ? "#{ENV["HOME"]}/Library/Application Support/boltdb" : "#{ENV["HOME"]}/.local/share/boltdb" %> -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir <%= OS.mac? ? "#{ENV["HOME"]}/Library/Application Support/boltdb" : "#{ENV["HOME"]}/.local/share/boltdb" %>
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
