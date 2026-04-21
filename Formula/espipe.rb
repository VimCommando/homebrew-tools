class Espipe < Formula
  desc "Pipe NDJSON, JSON, or CSV documents into Elasticsearch"
  homepage "https://github.com/VimCommando/espipe"
  url "https://github.com/VimCommando/espipe/archive/44fd20b0cbc092ef91787320cac07c3802c11bdd.tar.gz"
  version "0.2.0"
  sha256 "bd46bc0d201bcfd7d24e8bb54dfaac4ae839a34e0c6409bb2f536e93e47f6ea2"
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
