class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.56.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.56.0/boltDB-v8.56.0-darwin-arm64"
      sha256 "5038530f1297bf38fadee2a14bc7cc046fb79ab74bf87977319904a74a31c6bd"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.56.0/boltDB-v8.56.0-darwin-amd64"
      sha256 "e1b6a12f92e65d8741e1c9cdda8f6334b8c9f4239cc74e02406140a5e6e3ad73"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.56.0/boltDB-v8.56.0-linux-arm64"
      sha256 "e434a153399efeb522afc24d1d209e144f5d38d32d379c6484e5d504be596304"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.56.0/boltDB-v8.56.0-linux-amd64"
      sha256 "f6ba9c7fd76cb54e816a11d18fc76a2019e2e54152f6c9d608e6e72d4c8d0c86"
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
