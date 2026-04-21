class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "b9f2abc20b2383110b7af1ad0ff3014a329642c5a240c6bbc9fa6e68dbecba34"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"docs.ndjson").write("{\"x\":1}\n")

    output = shell_output("#{bin}/espipe docs.ndjson -")
    assert_equal "{\"x\":1}\n", output
  end
end
