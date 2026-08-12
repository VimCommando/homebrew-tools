class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/687b76b8a5ba183d6f2d1628b6c282b20ac681ff.tar.gz"
  version "0.5.0"
  sha256 "fc0e67e60480a9b21c29d857dd1dbb4533860da8a2daa499d6e0130ed5ccd7e0"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "89dcbe7e4bf46b1cdeba194a67c826efaa677e77823596d61577281ac8627b66"
    sha256 cellar: :any,                 x86_64_linux: "130c175e05b0dd2ebca9b703297646b193d56b9435ac038c70f93798803a8e29"
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
    assert_equal "{\"x\":1}\n", output
  end
end
