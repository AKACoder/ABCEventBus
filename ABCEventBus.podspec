Pod::Spec.new do |s|
  s.name         = "ABCEventBus"
  s.version      = "0.1"
  s.summary      = "This is an event bus for iOS."
  s.homepage     = "https://github.com/AKACoder/ABCEventBus/"
  s.license      = { :type => "MIT" }
  s.author       = { "AKACoder" => "akacoder@outlook.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/AKACoder/ABCEventBus.git", :tag => "0.1" }
  s.source_files = "SourceCode/**/*.{swift}"
  s.requires_arc = true
  s.dependency "AsyncSwift", "2.0.4"
end
