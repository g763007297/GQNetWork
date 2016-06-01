Pod::Spec.new do |s|

  s.name         = "GQNetWork"
s.version = "0.0.3"
  s.summary      = "继承形式的网络请求库，支持关系映射，支持NSURLSession"

  s.homepage     = "https://github.com/g763007297/GQNetWork"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "developer_高" => "763007297@qq.com" }

  s.platform     = :iOS
  s.platform     = :ios, "5.0"

  s.source       = { :git => "https://github.com/g763007297/GQNetWork.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.default_subspec = 'NetWork'

  s.subspec 'Mapping' do |ss|
    ss.source_files = [
      'GQMapping/**/*.{h,m}',
      'GQNetWork/Additions/NSString+GQAdditions.h',
      'GQNetWork/Additions/NSString+GQAdditions.m',
    ]
    ss.public_header_files = "GQMapping/*.h"
  end
  
  s.subspec 'NetWork' do |nw|
    nw.source_files  = "GQNetWork/**/*.{h,m}"
    nw.dependency 'GQNetWork/Mapping'
  end
  
end
