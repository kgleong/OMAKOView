#
# Be sure to run `pod lib lint OMAKOView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OMAKOView'
  s.version          = '1.0.1'
  s.summary          = 'Custom user interface elements for iOS applications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This is a collection of UI elements for use in iOS applications.

  Includes:
  * OMAKOPartiallyVisibleSwipableView
  DESC

  s.homepage         = 'https://github.com/kgleong/OMAKOView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Leong' => 'kgleong@gmail.com' }
  s.source           = { :git => 'https://github.com/kgleong/OMAKOView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'OMAKOView/Classes/**/*'

  # s.resource_bundles = {
  #   'OMAKOView' => ['OMAKOView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
