class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.6.1.tar.gz"
  version "0.6.1"
  sha256 "3b27e5dc34c5fb661ecae28bc5ce4e960e6dc067e7982b462bc48f9e70341f7f"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "728fe9b4a98dc100e52e165e068ffd00eefa3a7b21d608bc2aff296f15cdf320"
    sha256 cellar: :any,                 x86_64_linux: "c412ef6cc08200e3721f12a5fa924b722eec4274e93e4b503a4d634a85a67ce2"
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
