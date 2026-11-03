class Scribe < Formula
  desc "Meeting notes for macOS that never leave your Mac"
  homepage "https://github.com/azeemhassni/scribe"
  url "https://github.com/azeemhassni/scribe/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e80ce7720cf2921ad4bb779134550b4ce5b3435af033b93bed7aa8122e55da88"
  license "GPL-3.0-only"
  head "https://github.com/azeemhassni/scribe.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  # Apple Silicon for the CoreAudio process taps, Tahoe for Liquid Glass.
  depends_on arch: :arm64
  depends_on macos: :tahoe
  # Scribe shells out to whisper-cli for transcription.
  depends_on "whisper.cpp"

  def install
    # SwiftPM cannot run its own sandbox inside Homebrew's.
    ENV["SCRIBE_SWIFT_FLAGS"] = "--disable-sandbox"
    ENV["SCRIBE_VERSION"] = version.to_s
    # bundle.sh counts commits for this, and a release tarball has no git
    # history to count.
    ENV["SCRIBE_BUILD"] = Time.now.strftime("%Y%m%d")

    system "bash", "scripts/bundle.sh"

    # Homebrew owns updates for a Homebrew install; Sparkle checking as well
    # would offer downloads that brew then knows nothing about.
    system "/usr/libexec/PlistBuddy", "-c",
           "Set :SUEnableAutomaticChecks false",
           "build/Scribe.app/Contents/Info.plist"

    prefix.install "build/Scribe.app"
  end

  def caveats
    <<~EOS
      Scribe is built from source and signed ad-hoc on this Mac, so macOS lets
      it open without any Gatekeeper warning.

      Put it where Spotlight and Launchpad can see it:
        ln -sfn #{opt_prefix}/Scribe.app /Applications/Scribe.app

      Then open it once and work through the setup window: it downloads the
      speech model and either finds Ollama or fetches a built-in notes model.

      Two things to expect:
        * macOS ties microphone and audio permissions to the code signature,
          and an ad-hoc signature changes on every build, so `brew upgrade`
          will ask for microphone access again.
        * Updates come from `brew upgrade scribe`, not from inside the app.
    EOS
  end

  test do
    app = prefix/"Scribe.app/Contents/MacOS/Scribe"
    assert_predicate app, :executable?
    # --doctor reports what is missing and exits non-zero; running it at all
    # proves the bundle links and launches.
    system app, "--check-resampler"
  end
end
