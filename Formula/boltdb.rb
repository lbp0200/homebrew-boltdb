class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.3/boltDB-v8.0.3-darwin-arm64"
      sha256 "748ec2d9a7783111a867083d786906c02e03497eed049e7b06afedafafd1d199"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.3/boltDB-v8.0.3-darwin-amd64"
      sha256 "13f713a671ce426408273b457691d0f3a5e2e3f24540f5c2b37985420feb8fd0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.3/boltDB-v8.0.3-linux-arm64"
      sha256 "21094c1007bb547bf388621b3b8fee82fe2687cf34394a55b8c02c16df9dcb7e"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.3/boltDB-v8.0.3-linux-amd64"
      sha256 "9deff5c5b987bf52a485c1376ddb794659244c8eb7ef05980b37bbc1ebf0de35"
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
