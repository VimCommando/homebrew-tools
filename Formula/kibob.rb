class Kibob < Formula
  desc "Git-inspired CLI tool for managing Kibana saved objects"
  homepage "https://github.com/VimCommando/kibana-object-manager"
  url "https://github.com/VimCommando/kibana-object-manager/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "5ffed330c17350b949095b47482f7a9612e951c5f709484d3d985b93177763c6"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kibana-object-manager")
  end

  test do
    assert_match "kibob", shell_output("#{bin}/kibob --help")
    assert_match version.to_s, shell_output("#{bin}/kibob --version")

    (testpath/"export.ndjson").write <<~EOS
      {"id":"release-smoke-dashboard","type":"dashboard","attributes":{"title":"Release Smoke"},"references":[]}
    EOS
    system bin/"kibob", "init", testpath/"export.ndjson", testpath/"project"
    manifest = JSON.parse((testpath/"project/manifest/saved_objects.json").read)
    assert_equal [{ "type" => "dashboard", "id" => "release-smoke-dashboard" }], manifest.fetch("objects")
    object = JSON.parse((testpath/"project/objects/dashboard/Release Smoke.json").read)
    assert_equal "Release Smoke", object.fetch("attributes").fetch("title")
  end
end
