Pod::Spec.new do |spec|

  spec.name          = "DateRangeSelector"
  spec.version       = "0.0.1"
  spec.summary       = "customizable calendar view as a date range selector"

  spec.homepage      = "https://github.com/boof-tech/DateRangeSelector"
  spec.screenshots   = "https://user-images.githubusercontent.com/35375629/110629989-115ade00-81ba-11eb-85af-f6d5f026066c.png"


  spec.swift_versions = '5.0'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  spec.license       = { :type => "MIT" }
  spec.author        = { "Boof.tech" => "info@boof.tech" }
  spec.platform      = :ios, "11.0"
  spec.source        = { :git => 'https://github.com/boof-tech/DateRangeSelector.git', :tag => '0.0.1'}
  spec.source_files  = "DateRangeSelector/**/*.{swift}"
end