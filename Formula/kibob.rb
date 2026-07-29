class Kibob < Formula
  desc "Git-inspired CLI tool for managing Kibana saved objects"
  homepage "https://github.com/VimCommando/kibana-object-manager"
  url "https://github.com/VimCommando/kibana-object-manager/archive/440101a6af9340195fc4c4d0793f810df1411c7b.tar.gz"
  version "0.4.0"
  sha256 "12bebb6a3140aa0c5431284618c5d764bfa692bac1223269492d1b0db278544f"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d21eb065adbdca8182673c9ddfb9eafd2259fd4d230f127d7ef99ec8b10df1da"
    sha256 cellar: :any,                 x86_64_linux: "6b352c78c49f44eac6af7d4aa523de37d24941f61fd3850e316ab72929708d5e"
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
