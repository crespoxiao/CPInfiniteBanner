#
# Be sure to run `pod lib lint CPInfiniteBanner.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CPInfiniteBanner"
  s.version          = "0.1.0"
  s.summary          = "A short description of CPInfiniteBanner."
  s.description      = <<-DESC.gsub(/^\s*\|?/,'')
                       An optional longer description of CPInfiniteBanner

                       | * Markdown format.
                       | * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/crespoxiao/CPInfiniteBanner"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'BSD'
  s.author           = { "CrespoXiao" => "xiaochengfei@didichuxing.com" }
  s.source           = { :git => "git@github.com:crespoxiao/CPInfiniteBanner.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.source_files = 'Pod/Classes/**/*'

  # Uncomment following lines if CPInfiniteBanner has some resource files.
  s.resource_bundles = {
     'CPInfiniteBanner' => ['Pod/Assets/*']
   }

  # Uncomment following lines if CPInfiniteBanner needs to link with some static libraries.
  # s.vendored_libraries = [
  #   'Pod/lib/a-static-library.a',
  # ]

  # Uncomment following lines if CPInfiniteBanner depends on any system framework.
  s.frameworks = 'UIKit', 'Foundation'

  # Uncomment following lines if CPInfiniteBanner depends on any public or private pod.
  s.dependency 'libextobjc', '~> 0.4.1'
  s.dependency 'SDWebImage','~>3.7.2'
  s.dependency 'Masonry','~>0.6.3'

end
