class Kibob < Formula
  desc "Git-inspired CLI tool for managing Kibana saved objects"
  homepage "https://github.com/VimCommando/kibana-object-manager"
  url "https://github.com/VimCommando/kibana-object-manager/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2ade53ff7193b9bb9008a1a0bcfa6d8d1a7c16c4ff64d7572ac436fb7f57ee37"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match "kibob", shell_output("#{bin}/kibob --help")
  end
end
