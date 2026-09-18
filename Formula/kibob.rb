class Kibob < Formula
  desc "Git-inspired CLI tool for managing Kibana saved objects"
  homepage "https://github.com/VimCommando/kibana-object-manager"
  url "https://github.com/VimCommando/kibana-object-manager/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8172bea51be9dfd91cf65adba615dc4f770749ef2e077611fc648a82ea0cd722"
  license "Apache-2.0"

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
