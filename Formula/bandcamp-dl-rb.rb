class BandcampDlRb < Formula
  desc "Download your Bandcamp purchases and organize them for a Plex library"
  homepage "https://github.com/alexcoll/bandcamp-dl-rb"
  url "https://github.com/alexcoll/bandcamp-dl-rb/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "078f8b4aa0a456c96347b034e77208b2a87d314eef1a6c9b63bdb1e20a6a6ee5"
  license "GPL-3.0-only"

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "--no-document",
           "--install-dir", libexec, "#{name}-#{version}.gem"

    # Copy the gem's executable into the keg and wrap it so GEM_HOME points
    # at the keg and the formula's Ruby is used.
    exe = "bandcamp_dl_rb"
    libexec_bin = libexec/"bin"
    libexec_bin.mkpath
    File.binwrite libexec_bin/exe,
                  File.binread(libexec/"gems/#{name}-#{version}/exe/#{exe}")
    chmod 0755, libexec_bin/exe
    (bin/exe).write_env_script libexec_bin/exe,
                               PATH:     "#{formula_opt_bin("ruby")}:$PATH",
                               GEM_HOME: libexec
  end

  test do
    assert_match "bandcamp_dl_rb", shell_output("#{bin}/bandcamp_dl_rb --help")
  end
end
