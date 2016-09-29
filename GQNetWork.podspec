Pod::Spec.new do |s|

  s.name         = "GQNetWork"
  s.version      = "1.2.7"
  s.summary      = "继承形式的网络请求库，支持关系映射，支持NSURLSession,支持https请求，请求数据缓存机制，支持链式调用，支持model版本控制"

  s.homepage     = "https://github.com/g763007297/GQNetWork"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }

  s.platform     = :ios

  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/g763007297/GQNetWork.git", :tag => s.version }

  s.requires_arc = true

   s.subspec 'GQMapping' do |ss|
     ss.ios.source_files = 'GQMapping/**/*.{h,m}'
     ss.public_header_files = 'GQMapping/**/*.h'
   end

  s.subspec 'GQNetworking' do |ss|
    ss.ios.source_files  = [
      "GQNetworking/**/*.{h,m}",
      "GQBaseNetwork/**/*.{h,m}",
    ]

    ss.public_header_files = [
      'GQNetworking/**/*.h',
      'GQBaseNetwork/**/*.h',
    ]
   ss.dependency 'GQNetWork/GQMapping'
  end

  #s.dependency 'GQMapping'
  s.default_subspec = 'GQNetworking'

end
