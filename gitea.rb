require "formula"

class Gitea < Formula
  homepage "https://github.com/go-gitea/gitea"
  head "https://github.com/go-gitea/gitea.git"

  stable do
    url "http://dl.gitea.io/gitea/1.0.0/gitea-1.0.0-darwin-10.6-amd64"
    sha256 `curl -Ls http://dl.gitea.io/gitea/1.0.0/gitea-1.0.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "1.0.0"
  end

  devel do
    url "http://dl.gitea.io/gitea/master/gitea-master-darwin-10.6-amd64"
    sha256 `curl -Ls http://dl.gitea.io/gitea/master/gitea-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", :branch => "master"

    depends_on "go" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/gitea", "--version"
  end

  def install
    if build.head?
      mkdir_p buildpath/File.join("src", "code.gitea.io")
      ln_s buildpath, buildpath/File.join("src", "code.gitea.io", "gitea")

      ENV.append_path "PATH", File.join(buildpath, "bin")

      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["TAGS"] = "sqlite"

      system("make", "build")

      bin.install "#{buildpath}/bin/gitea" => "gitea"
    else
      bin.install "#{buildpath}/gitea-master-darwin-10.6-amd64" => "gitea"
    end
  end
end
