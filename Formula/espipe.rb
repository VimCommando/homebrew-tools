class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/refs/tags/v0.3.0.tar.gz"
  version "0.3.0"
  sha256 "4fc8a064ead2af190551460fb595983e41c7d95ad0258213fb19226449799470"
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
