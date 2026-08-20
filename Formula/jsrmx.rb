class Jsrmx < Formula
  desc "Split, merge, bundle, and unbundle JSON and NDJSON files"
  homepage "https://github.com/VimCommando/jsrmx"
  url "https://github.com/VimCommando/jsrmx/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "30aa516a8e2a252b59693d30faec4a424b307357974416186a1cfba7b7adde33"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/VimCommando/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b2fb33e8bfc49fb51921927deb516d92e259b912453edc8473c68fc49b8a4158"
    sha256 cellar: :any,                 x86_64_linux: "69d38f5e88c9c43a4fe353823112f4c6fcd2c8c9274937d8fa5c5db110e805dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"input.json").write('{"alpha":{"value":1},"beta":{"value":2}}')

    output = shell_output("#{bin}/jsrmx split --compact input.json -")
    assert_match '"alpha":{"value":1}', output
    assert_match '"beta":{"value":2}', output
  end
end
