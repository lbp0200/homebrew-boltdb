class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.22"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.22/boltDB-v1.0.22-darwin-arm64"
      sha256 "e00e8f0fd81e1e757aa90e700a7e3f3a83f2b8d7e1ee494424eb3449a80c412c"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.22/boltDB-v1.0.22-darwin-amd64"
      sha256 "cd0781e9569aae88487bf133d5d270698877fa2b1f1dc97a532f8b264ac1259e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.22/boltDB-v1.0.22-linux-arm64"
      sha256 "8631df16dd0dd0c9845d210807e9fa63077d47e632f0562b5661548e6d1baaf0"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.22/boltDB-v1.0.22-linux-amd64"
      sha256 "474b8e493b7a326f3f28a365273dedc05e3ef1ecebf62c723279854806c00a26"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v1.0.22-#{os}-#{arch}" => "boltdb"
  end

  service do
    run bin/"boltdb"
    keep_alive true
    working_dir /var/lib/boltdb
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
