#
# Be sure to run `pod lib lint AFPageClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AFPageClient'
  s.version          = '1.4.0'
  s.summary          = '分页控制器'
  s.homepage         = 'https://github.com/yxh418983798/AFPageClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alfie' => '418983798@qq.com' }
  s.source           = { :git => 'https://github.com/yxh418983798/AFPageClient.git', :tag => s.version.to_s, :branch => 'master'}
  s.ios.deployment_target = '8.0'
  s.source_files = 'AFPageClient/Classes/**/*'
  s.dependency 'Masonry'
#  s.public_header_files = 'Pod/Classes/**/{AFPageClient,AFPageItem,AFSegmentConfiguration}.h'
  
end


