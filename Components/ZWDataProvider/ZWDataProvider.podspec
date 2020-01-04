#
# Be sure to run `pod lib lint SCDateRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZWDataProvider'
  s.version          = '0.0.1'
  s.summary          = '网络请求数据部分.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 网络请求数据模板.
                       DESC

    s.homepage         = 'https://github.com/EadkennyChan'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Eadkennychan' => 'Eadkennychan@gmail.com' }
    s.source           = { :svn => 'svn://localhost/ios_database_mine/Jiaguwen/iOS/SuperCode/SCDataRequest', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.source_files = 'Classes/**/*.{h,m}'

    s.prefix_header_contents = ['#import <ZWUtilityKit/ZWUtilityKit.h>', '#import "UserEntity.h"']
#'#import "NetworkDetection.h"',
    # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'ZWUtilityKit'
    s.dependency 'AFNetworking'
    #s.dependency 'ZWNetwork'
    s.dependency 'ZWModel'
    s.dependency 'FMDB'    
end
