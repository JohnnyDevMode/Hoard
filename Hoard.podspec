Pod::Spec.new do |s|
  s.name        = "Hoard"
  s.version     = "0.0.2"
  s.summary     = "Hoard is a generic tree-based object cache for iOS development."
  s.homepage    = "https://github.com/JohnnyDevMode/Hoard"
  s.license     = { :type => "MIT" }
  s.authors     = { "JohnnyDevMode" => "john@devmode.com", "tangplin" => "john@devmode.com" }

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/JohnnyDevMode/Hoard.git", :tag => s.version }
  s.source_files = "Hoard/*.swift"
  s.pod_target_xcconfig =  {
        'SWIFT_VERSION' => '3.0',
  }
end
