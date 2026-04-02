class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "8.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.1/boltDB-v8.1.1-darwin-arm64"
      sha256 "ca374b8fadba665ed374ffc40c958e99ac76c370c39a804ed94a751a82d49cde"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.1/boltDB-v8.1.1-darwin-amd64"
      sha256 "71806286c3fb94a84731fde7fb16c6526e85eb8a63fedcbfc75569bccb2dce49"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.1/boltDB-v8.1.1-linux-arm64"
      sha256 "3fa630d666c483e77c09443c001049802950fcdcc8bad0db2af6839ad28a482b"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v8.1.1/boltDB-v8.1.1-linux-amd64"
      sha256 "a73cbd3416fd657e49593ca899857f5783305d78bc6cab5b65402001bf4de80d"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v#{version}-#{os}-#{arch}" => "boltdb"
    data_dir = OS.mac? ? "#{ENV["HOME"]}/Library/Application Support/boltdb" : "#{ENV["HOME"]}/.local/share/boltdb"
    (bin/"boltdb-run").write <<~EOS
      #!/bin/bash
      exec "#{bin}/boltdb" -dir "#{data_dir}" -skip-startup-cleanup
    EOS
    chmod "+x", bin/"boltdb-run"
  end

  service do
    run bin/"boltdb-run"
    keep_alive true
    working_dir data_dir
  end

  test do
    assert_predicate bin/"boltdb", :exist?
  end
end
