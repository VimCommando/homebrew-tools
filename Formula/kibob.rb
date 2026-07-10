class Kibob < Formula
  desc "Git-inspired CLI tool for managing Kibana saved objects"
  homepage "https://github.com/VimCommando/kibana-object-manager"
  url "https://github.com/VimCommando/kibana-object-manager/archive/eba97b0f3ded433392997ab896510149495e8072.tar.gz"
  version "0.3.1"
  sha256 "d0e9af8ad72611ad97c0bad7b7701be45fd4b3be1ab83b3323c0daee8021fa57"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e63e64650219f46bcb4e190cd417f42c5114bf66fe3eea75fec041edf49c6855"
    sha256 cellar: :any,                 x86_64_linux: "74058e4032581f15e3e5ce5a28e895538283f71b8ad59bdbcfe264efddfe55ee"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/kibana-object-manager")
  end

  test do
    assert_match "kibob", shell_output("#{bin}/kibob --help")
  end
end
