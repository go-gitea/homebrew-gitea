require "formula"

class Lgtm < Formula
  homepage "https://github.com/go-gitea/lgtm"
  head "https://github.com/go-gitea/lgtm.git"

  stable do
    version "1.0.0"
    url "https://dl.gitea.io/lgtm/#{version}/lgtm-#{version}-darwin-10.6-amd64"
    sha256 `curl -s https://dl.gitea.io/lgtm/#{version}/lgtm-#{version}-darwin-10.6-amd64.sha256`.split(" ").first
  end

  devel do
    url "https://dl.gitea.io/lgtm/master/lgtm-master-darwin-10.6-amd64"
    sha256 `curl -s https://dl.gitea.io/lgtm/master/lgtm-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/go-gitea/lgtm.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/lgtm", "--version"
  end

  def install
    case
    when build.head?
      mkdir_p buildpath/File.join("src", "github.com", "go-gitea")
      ln_s buildpath, buildpath/File.join("src", "github.com", "go-gitea", "lgtm")

      ENV.append_path "PATH", File.join(buildpath, "bin")

      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["TAGS"] = ""

      system "cd src/github.com/go-gitea/lgtm && make build"

      bin.install "#{buildpath}/lgtm" => "lgtm"
    else
      bin.install "#{buildpath}/lgtm-#{version}-darwin-10.6-amd64" => "lgtm"
    end
  end
end
