class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.4.0.tar.gz"
  version "0.4.0"
  sha256 "632f556e535fb6c6e1bae2c6116e7396697aea4b0cfd303f3b2434beb371fef0"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a51678d6ac0580395c0c22d0de611feff8a67c3518623c90ab9277799f74ccda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e9b4ed66d4f6026fa1e163552da815974f4789b93e01aad1ab45e15026a5cad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"docs.ndjson").write("{\"x\":1}\n")

    output = shell_output("#{bin}/espipe docs.ndjson -")
    assert_equal "{\"x\":1}\n", output
  end
end
