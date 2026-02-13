class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.0/boltDB-1.0.0-darwin-arm64"
      sha256 "158c8f7f878ab5f1754eb9219c31ef936e47e44ddc351214ae6bb304bb8cfc7a"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.0/boltDB-1.0.0-darwin-amd64"
      sha256 "d4be0c6e17bcd549ccdb7855ede7a811ad4dd1b4f5f32af33ccca72db715312c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.0/boltDB-1.0.0-linux-arm64"
      sha256 "f26ef9752f4e4b9bf1519e39e371a743d2209be01dd84d7d2bab9b8d098026e3"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.0/boltDB-1.0.0-linux-amd64"
      sha256 "c47e8060aec67d8bb6f9abe15ceed01adc5e1535a797b4e6fcbc3d33ed8d875f"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-#{version}-#{os}-#{arch}" => "boltdb"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
