#
# Be sure to run `pod lib lint TRTCAITestDevice.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TRTCAITestDevice'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TRTCAITestDevice.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yaliyingwy/TRTCAITestDevice'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'moonwen' => 'moonwen@tencent.com' }
  s.source           = { :git => 'https://github.com/moonwen/TRTCAITestDevice.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'



  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
#  s.dependency 'Masonry', '1.1.0'
 
  s.default_subspec = 'Core'
  s.static_framework = true

 s.subspec 'Core' do |core|
     core.dependency 'Masonry', '1.1.0'
     core.source_files = 'TRTCAITestDevice/Classes/**/*'
     core.public_header_files = 'TRTCAITestDevice/Classes/**/*.h'
     core.resource_bundles = {
        'TRTCAITestDevice' => ['TRTCAITestDevice/Assets/*.xcassets', 'TRTCAITestDevice/Assets/Localized/**/*.strings', 'TRTCAITestDevice/Assets/Lottie/**/*.json', 'TRTCAITestDevice/Assets/Lottie/**/*.mp3']
      }
 end
  
  s.subspec 'WithLib' do |withlib|
      
      withlib.dependency 'lottie-ios', '~> 2.5.3'
      withlib.dependency 'TXLiteAVSDK_TRTC'
  end
end
