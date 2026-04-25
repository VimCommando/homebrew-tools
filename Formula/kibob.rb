class Kibob < Formula
  desc "Git-inspired CLI tool for managing Kibana saved objects"
  homepage "https://github.com/VimCommando/kibana-object-manager"
  url "https://github.com/VimCommando/kibana-object-manager/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2ade53ff7193b9bb9008a1a0bcfa6d8d1a7c16c4ff64d7572ac436fb7f57ee37"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "cb5b4038068738da833a7b8e94940a5485ae1b3828026500783cfcf6b47b968d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "623b9e5f57f5b2f2745268ae533e5e8516310784648c3e90de4557b274671e87"
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
    assert_match "kibob", shell_output("#{bin}/kibob --help")
  end
end
