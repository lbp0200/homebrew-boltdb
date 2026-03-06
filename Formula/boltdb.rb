class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.0.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.5/boltDB-v8.0.5-darwin-arm64"
      sha256 "acff3f74ef4c6981b9e7ddc6ff13629f8ea509465cbe54c51ebb3ac8165bc692"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.5/boltDB-v8.0.5-darwin-amd64"
      sha256 "a426b2f2b34340a942f6e30d390f55cde514735d9e3087247d0929f40e5e51a6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.5/boltDB-v8.0.5-linux-arm64"
      sha256 "8e9da05db612dfc39535f4ab56a9375930d909fc5f934ce1b1c43e1409dd2337"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.0.5/boltDB-v8.0.5-linux-amd64"
      sha256 "337285e356465817677f08991297151ec96ecefe5ca1434cac7ac54f0858b8d4"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-#{version}-#{os}-#{arch}" => "boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir "<%= OS.mac? ? '#{ENV["HOME"]}/Library/Application Support/boltdb' : '#{ENV["HOME"]}/.local/share/boltdb' %>" -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir "<%= OS.mac? ? '#{ENV["HOME"]}/Library/Application Support/boltdb' : '#{ENV["HOME"]}/.local/share/boltdb' %>"
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
