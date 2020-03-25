Pod::Spec.new do |s|

  s.name         = "GQNetWork"
  s.version      = "1.4.4"
  s.summary      = "继承形式的网络请求库，支持NSURLSession,支持https请求，请求数据缓存机制，支持链式调用"

  s.homepage     = "https://github.com/g763007297/GQNetWork"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }

  s.platform     = :ios

  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/g763007297/GQNetWork.git", :tag => s.version }

  s.requires_arc = true

  s.subspec 'GQNetworking' do |ss|
    ss.ios.source_files  = [
      "GQNetworking/**/*.{h,m}",
      "GQBaseNetwork/**/*.{h,m}",
      "GQNetworkOperation/**/*.{h,m}",
    ]

    ss.public_header_files = [
      'GQNetworking/**/*.h',
      'GQBaseNetwork/**/*.h',
      "GQNetworkOperation/**/*.{h,m}",
    ]
  end

  s.subspec 'GQAFNetworking' do |ss|
    ss.ios.source_files  = [
      "GQNetworking/**/*.{h,m}",
      "GQBaseNetwork/**/*.{h,m}",
      "AFNetWorking/**/*.{h,m}",
    ]

    ss.public_header_files = [
      'GQNetworking/**/*.h',
      'GQBaseNetwork/**/*.h',
      "AFNetWorking/**/*.{h,m}",
    ]

    ss.dependency 'AFNetworking/NSURLSession'
  end

  s.default_subspec = 'GQNetworking'

end
