class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.47.tar.gz"
  sha256 "046d62692f2ba2c5ef3b76e22eab19259403e21a7399bf716c2733f4347714c8"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d1eb443c53ce1a8cb820dcc1b0e67426de332acda46de1f96a649d24ee7673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d1eb443c53ce1a8cb820dcc1b0e67426de332acda46de1f96a649d24ee7673"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97d1eb443c53ce1a8cb820dcc1b0e67426de332acda46de1f96a649d24ee7673"
    sha256 cellar: :any_skip_relocation, sonoma:        "7659911550e9f3ea46b4c8af2118b6829226120c5ddeb9bfbfbf305942c907b3"
    sha256 cellar: :any_skip_relocation, ventura:       "7659911550e9f3ea46b4c8af2118b6829226120c5ddeb9bfbfbf305942c907b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781c24633ffadaae8e8bedb4aaa4c5700ea5129b75755d4a722d7ad9c005ae9a"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
