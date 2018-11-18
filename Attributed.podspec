Pod::Spec.new do |s|
  s.name         = "Attributed"
  s.version      = "7.0.0"
  s.summary      = "Convert XML to an NSAttributedString."
  s.author       = 'Hilton Campbell'
  s.homepage     = "https://github.com/CrossWaterBridge/Attributed"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/CrossWaterBridge/Attributed.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'Attributed/*.swift'
  s.framework = 'UIKit'
  s.requires_arc = true
end
