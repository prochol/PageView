
Pod::Spec.new do |s|
  s.name             = "PageView"
  s.version          = "0.0.1"
  s.summary          = "A control that mimics PageView functionality with added customization options."
  s.description      = <<-DESC
                        This is a UIControl that mimics the functionality of PageView while also adding additional customization options that are not available using the base PageView
                        DESC
  s.homepage         = "https://github.com/prochol/PageView"
  s.license          = 'MIT'
  s.author           = { "Kuzmin Pavel" => "prochol@ya.ru" }
  s.source           = { :git => "https://github.com/prochol/PageView.git", :tag => s.version.to_s }

  s.platform     = :ios, '11.0'
  s.requires_arc = true

  s.source_files = "Pod/Classes/*.swift"
  s.resources = "Pod/Classes/*.xib"
end
