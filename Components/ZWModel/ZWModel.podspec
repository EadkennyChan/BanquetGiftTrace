#
# Be sure to run `pod lib lint SCFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZWModel'
  s.version          = '0.0.1'
  s.summary          = '超级码项目中实体对象模型.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
TODO: 超级码系统——移动物联网时代整合防伪、溯源、营销和大数据的一站式最佳解决方案。

超级码系统是国内首家为品牌企业提供防伪溯源营销的技术服务平台。集十多年行业经验和技术沉淀，倾力打造国内首个“产品防伪溯源+物流防窜货+积分营销+大数据”的全流程一体化防伪溯源云系统。

超级码利用先进的移动通讯技术，WEB系统技术，无线传感网络技术，结合“一品一码”的二维码防伪溯源定制标签，实现对产品的防伪溯源查询，后台大数据的监管分析，品牌的推广营销。

在农产品防伪溯源领域，超级码与世界知名的德国莱茵TUV第三方质量检测机构合作，对农产品从“播种”到“收获”的全流程进行监管溯源，打造出“安全可预警、源头和追溯、流向可跟踪、信息可查询、责任可认定”的质量安全监管追溯体系。

超级码致力于打造便捷高效的企业级产品监管、农产品全流程溯源、积分营销推广和大数据分析的系统工具。

助您实现：码上防伪、码上溯源、码上营销、码上抽奖、码上积分。
    DESC

  s.homepage         = 'https://github.com/EadkennyChan'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eadkennychan' => 'Eadkennychan@gmail.com' }
  s.source           = { :svn => 'http://192.168.2.49:81/svn/JGW/APP/IOS/component/SuperCode/SCEntity', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

s.source_files = '{Classes,Resource}/{*,**/*}.{h,m}'
s.exclude_files = '{**/Qualification/exclude/*.*}'
s.prefix_header_contents = ['#import "ZWMacroDef.h"','#import "ZWUtilityKit.h"','#import "Dictionary+SafeValue.h"','#import "NSURL+EncodeString.h"', '#import "SDWebImageManager.h"', '#import "UserEntity.h"']
  
  # s.resource_bundles = {
  #   'SCEntity' => ['SCEntity/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit'
    s.dependency 'ZWUtilityKit'
    s.dependency 'SDWebImage'
    s.dependency 'FMDB'

    s.xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
#'OTHER_LDFLAGS' => '"$(inherited)" "-lxml2" "-objc"'
    }
end
