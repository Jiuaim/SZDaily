#
# Be sure to run `pod lib lint SZDaily.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SZDaily'
  s.version          = '0.0.4'
  s.summary          = 'Daily knowledge record.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jiuaim/SZDaily'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jiuaim' => 'jiuaim@163.com' }
  s.source           = { :git => 'https://github.com/jiuaim/SZDaily.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SZDaily/SZHeader.h'
  s.public_header_files = 'SZDaily/SZHeader.h'
  
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'Forbidden' do |forbidden|
    forbidden.public_header_files = 'SZDaily/Forbidden/*.h'
    forbidden.source_files = 'SZDaily/Forbidden/*.{h,m}'
    forbidden.dependency 'Aspects'
    forbidden.dependency 'SZDaily/Macro'
  end
  
  s.subspec 'Preview' do |preview|
    preview.public_header_files = 'SZDaily/Preview/*.h'
    preview.source_files = 'SZDaily/Preview/*.{h,m}'
  end
  
  s.subspec 'Category' do |category|
    category.public_header_files = 'SZDaily/Category/*.h'
    category.source_files = 'SZDaily/Category/*.{h,m}'
  end
  
  s.subspec 'Macro' do |macro|
    macro.source_files = 'SZDaily/Macro/*.h'
  end
end
