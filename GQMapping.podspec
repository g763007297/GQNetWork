Pod::Spec.new do |s|

  s.name         = "GQMapping"
  s.version      = "1.2.7"
  s.summary      = "json->model,自带model版本控制"

  s.homepage     = "https://github.com/g763007297/GQNetWork"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }

  s.platform     = :ios

  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/g763007297/GQNetWork.git", :tag => s.version }

  s.requires_arc = true

  s.source_files  = 'GQMapping/**/*.{h,m}'
  
  s.public_header_files = 'GQMapping/**/*.h'
  
  end