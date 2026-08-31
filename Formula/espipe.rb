class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.7.0.tar.gz"
  version "0.7.0"
  sha256 "9df50c3419cdb593d22b16909dec7be6bf0114d4d01fe7578b602ef971f3cd36"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f7b8474c63c4564c8b47dd8787be0b8d225018f08d5147e8404da292242adc8a"
    sha256 cellar: :any,                 x86_64_linux: "382860040e647b632cc558dab55a2973018492b5764a574e918c4c8ffe831381"
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
