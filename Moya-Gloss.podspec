#
# Be sure to run `pod lib lint Moya-Gloss.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Moya-Gloss"
  s.version          = "2.0.0-beta.2"
  s.summary          = "Convenience Gloss bindings for Moya."
  s.description      = <<-EOS
    [Gloss](https://github.com/hkellaway/Gloss) bindings for
    [Moya](https://github.com/Moya/Moya) for fabulous JSON serialization.
    [RxSwift](https://github.com/ReactiveX/RxSwift/) and [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa/) bindings also included.
    Instructions on how to use it are in
    [the README](https://github.com/spxrogers/Moya-Gloss).
  EOS

  s.homepage         = "https://github.com/spxrogers/Moya-Gloss"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Steven Rogers" => "me@srogers.net" }
  s.source           = { :git => "https://github.com/spxrogers/Moya-Gloss.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/spxrogers"

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Source/*.swift"
    ss.dependency "Moya", "8.0.0-beta.2"
    ss.dependency "Gloss", "~> 1.0"
    ss.framework  = "Foundation"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Source/RxSwift/*.swift"
    ss.dependency "Moya-Gloss/Core"
    ss.dependency "Moya/RxSwift"
    ss.dependency 'RxSwift', '3.0.0-beta.1'
    ss.dependency 'RxCocoa', '3.0.0-beta.1'
  end

  s.subspec "ReactiveCocoa" do |ss|
    ss.source_files = "Source/ReactiveCocoa/*.swift"
    ss.dependency "Moya-Gloss/Core"
    ss.dependency "Moya/ReactiveCocoa"
    ss.dependency 'ReactiveSwift', '1.0.0-alpha.1'
  end

end
