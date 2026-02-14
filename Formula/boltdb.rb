class Boltdb < Formula
  desc "Redis-compatible key-value database with 100TB storage"
  homepage "https://github.com/lbp0200/BoltDB"
  version "1.0.21"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.21/boltDB-v1.0.21-darwin-arm64"
      sha256 "9c30bf6363e951e438b9824099138ef6d59e294ef4b1085191494a25b8c35a59"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.21/boltDB-v1.0.21-darwin-amd64"
      sha256 "0a4274c48d447806ab4087246317fdf61879474fd3642cf86008d93bfc69bba2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.21/boltDB-v1.0.21-linux-arm64"
      sha256 "c609d96d1f271cce88a305ba69a3ee548126421f813ccc2a87e21249447f20f6"
    else
      url "https://github.com/lbp0200/BoltDB/releases/download/v1.0.21/boltDB-v1.0.21-linux-amd64"
      sha256 "8b15431e9c39f433de56d3b6b7953b6a5adf7588fe3aaee0504bd07358fe6990"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "boltDB-v1.0.21-#{os}-#{arch}" => "boltdb"
  end

  service do
    run opt_bin/"boltdb"
    keep_alive true
    run_args ["-dir", "#{var}/lib/boltdb"]
    log_path "#{var}/log/boltdb.log"
    error_log_path "#{var}/log/boltdb.err.log"
  end

  test do
    system "#{bin}/boltdb", "--version"
  end
end
