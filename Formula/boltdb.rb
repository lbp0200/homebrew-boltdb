class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.0/boltDB-v8.2.0-darwin-arm64"
      sha256 "0aed3f553fcabe74a234eb8a123dff7b64d6d1d23e3825db8edfc92334985a19"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.0/boltDB-v8.2.0-darwin-amd64"
      sha256 "9230e7ea5110517efac45140361d554257cad0587f88a0042b8a9db8498cd39d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.0/boltDB-v8.2.0-linux-arm64"
      sha256 "e11c258e3b3f6d8292e5d0359a42a56253ca71f8c68728408880ec178fa2ffe0"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.2.0/boltDB-v8.2.0-linux-amd64"
      sha256 "aaa57b4544ed8d7441ce294c2b4350b9e187987e008ed87656ee7f783fefc9a1"
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
