class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.1.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.5/boltDB-v8.1.5-darwin-arm64"
      sha256 "f9b8a464b1233945b8b0b44457a11dfe510450988939c7bf5fac510fb34bee3d"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.5/boltDB-v8.1.5-darwin-amd64"
      sha256 "f78609cf97973c4b3ce8e15be9aa0815e8474c84b89fcd3a4ffe0359ec3598be"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.5/boltDB-v8.1.5-linux-arm64"
      sha256 "e637e30b299cd3e45d501717f9b7a77f64b71171d1816258d32c4d2b87a62f99"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.5/boltDB-v8.1.5-linux-amd64"
      sha256 "fbc561602827d332910da4e399dfe8089f0b86b509a639f9cb8a09ca303ccc05"
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
