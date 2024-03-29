#
# Be sure to run `pod lib lint HIProbe.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HIProbe'
  s.version          = '0.1.1'
  s.summary          = 'objective-c, 埋点方案'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
用户行为统计，半自动。无侵入买点方案，支持手动买点。
                       DESC

  s.homepage         = 'https://github.com/qinyue/HIProbe'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hushaohua' => 'qinyue0306@163.com' }
  s.source           = { :git => 'https://github.com/qinyue/HIProbe.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HIProbe/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HIProbe' => ['HIProbe/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
