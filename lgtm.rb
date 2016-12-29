require "formula"

class Lgtm < Formula
  homepage "https://github.com/go-gitea/lgtm"
  head "https://github.com/go-gitea/lgtm.git"

  stable do
    url "http://dl.gitea.io/lgtm/1.0.0/lgtm-1.0.0-darwin-amd64"
    sha256 `curl -s http://dl.gitea.io/lgtm/1.0.0/lgtm-1.0.0-darwin-amd64.sha256`.split(" ").first
    version "1.0.0"
  end

  devel do
    url "http://dl.gitea.io/lgtm/master/lgtm-master-darwin-amd64"
    sha256 `curl -s http://dl.gitea.io/lgtm/master/lgtm-master-darwin-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/go-gitea/lgtm.git", :branch => "master"

    depends_on "go" => :build
    depends_on "git" => :build
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

      system("make", "build")

      bin.install "#{buildpath}/bin/lgtm" => "lgtm"
    when build.devel?
      bin.install "#{buildpath}/lgtm-master-darwin-amd64" => "lgtm"
    else
      bin.install "#{buildpath}/lgtm-1.0.0-darwin-amd64" => "lgtm"
    end
  end
end
