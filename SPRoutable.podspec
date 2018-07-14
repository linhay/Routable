Pod::Spec.new do |s|
  s.name    = 'SPRoutable'
  s.version = '0.9.9.1.alpha'
  s.license = 'MIT'
  s.summary = '基础的路由服务'
  
  s.homepage  = 'https://github.com/linhay/Routable'
  s.author    = { 'linhey' => 'linheyhan.linhey@outlook.com' }
  s.source    = { :git => 'https://github.com/linhay/Routable.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  
  s.source_files = ['Sources/*.{swift,h}']
  s.public_header_files = ['Sources/Routable.h']
  
  s.osx.exclude_files = ['Sources/Routale+UIKit.swift']
  s.watchos.exclude_files = ['Sources/Routale+UIKit.swift']
  s.tvos.exclude_files = ['Sources/Routale+UIKit.swift']
  
  s.dependency 'RoutableAssist', '0.2.2'
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.requires_arc = true
  
end
