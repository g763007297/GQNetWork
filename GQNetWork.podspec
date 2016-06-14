Pod::Spec.new do |s|

  s.name         = "GQNetWork"
  s.version      = "1.0.0"
  s.summary      = "继承形式的网络请求库，支持关系映射，支持NSURLSession"

  s.homepage     = "https://github.com/g763007297/GQNetWork"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }

  s.platform     = :ios

  s.ios.deployment_target = '5.0'

  s.source       = { :git => "https://github.com/g763007297/GQNetWork.git", :tag => s.version }

  s.requires_arc = true

  s.subspec 'Mapping' do |ss|
    ss.ios.source_files = [
      'GQMapping/**/*.{h,m}',
      'GQNetWork/Additions/NSString+GQAdditions.h',
      'GQNetWork/Additions/NSString+GQAdditions.3',
    ]

    ss.public_header_files = "GQMapping/**/*.h"
  end
  
  s.subspec 'NetWork' do |ss|
    ss.ios.source_files  = "GQNetWork/**/*.{h,m}"
    ss.dependency 'GQNetWork/Mapping'
  end
  
  s.default_subspec = 'NetWork'

end
