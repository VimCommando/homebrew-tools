class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.4.0.tar.gz"
  version "0.4.0"
  sha256 "632f556e535fb6c6e1bae2c6116e7396697aea4b0cfd303f3b2434beb371fef0"
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
