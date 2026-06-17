class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.25.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.25.0/boltDB-v8.25.0-darwin-arm64"
      sha256 "dcdee26d24765991d5f6186105263373197b5e6e77a3078965349b6cc7a3a0a3"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.25.0/boltDB-v8.25.0-darwin-amd64"
      sha256 "1135a4a8823c8f992808e487ce20ebae564b465a7359742016ccde01f9343c46"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.25.0/boltDB-v8.25.0-linux-arm64"
      sha256 "ff73db43e659b767e6bc8c71651685af0253f53d10edc31361e3c01742754d1c"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.25.0/boltDB-v8.25.0-linux-amd64"
      sha256 "5f46a01b6b563f6c6778a1ba3a080c328d6f929b428459cf01984193c38166d5"
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
