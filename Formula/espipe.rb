class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.6.0.tar.gz"
  version "0.6.0"
  sha256 "d811f6109995855e3a0e9794e062bd8a2a1deb886d66c1ccf75cd88c84fbe2cd"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "1a984277a72394de7668eb706347e4b8e87d6d138f5200452fc80cd98fdcee07"
    sha256 cellar: :any,                 x86_64_linux: "f5018b7cb4bdba757babaea79c3dcdaf4097d1bf865b9b21801f16c1ed0698bf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"docs.ndjson").write("{\"x\":1}\n")

    output = shell_output("#{bin}/espipe --quiet docs.ndjson -")
    assert_match(/"x":1/, output)
  end
end
