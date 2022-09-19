#
# Be sure to run `pod lib lint MFMediaView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFMediaView'
  s.version          = '0.0.3'
  s.summary          = 'A Common Display View For Media'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
We Use This To Show Common Media File
1 for jpg、png
2 for mp4
3 for gif
4 for avi
5 for svga
6 for pag
                       DESC

  s.homepage         = 'https://github.com/MoreFunTech/MFMediaView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NealWills' => 'NealWills93@gmail.com' }
  s.source           = { :git => 'https://github.com/MoreFunTech/MFMediaView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MFMediaView/Classes/**/*'

#  s.resource_bundles = {
#    'MFMediaView' => ['MFMediaView/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'libpag', '~> 4.0'
  s.dependency 'SVGAPlayer', '~> 2.5'
  s.dependency 'MFFileDownloader'
  
end
