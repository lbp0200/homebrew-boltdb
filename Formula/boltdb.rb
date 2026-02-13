class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.17"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.17/boltDB-1.0.17-darwin-arm64"
      sha256 "4c824e422fb5f7d2427619bf8497625369dee7f9a703e03f5e5708bef222534d"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.17/boltDB-1.0.17-darwin-amd64"
      sha256 "f53624445ee55212a52eb3e35d300578b953043ec1454e9dfb51350e71575b0c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.17/boltDB-1.0.17-linux-arm64"
      sha256 "9882562a3fd69dc8c3965f5de84150dd4d9db3a24d14721605547c1721b768ea"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.17/boltDB-1.0.17-linux-amd64"
      sha256 "772a846bf971e4f79647127e842eb4fd54e42c59ec731956096402e9a5d560b0"
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
