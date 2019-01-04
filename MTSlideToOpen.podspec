Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.name         = "MTSlideToOpen"
  s.version      = "1.2.1"
  s.summary      = "A simple SlideToUnlock iOS UI component."

  s.description  = "A simple iOS UI component acts Slide To Unlock."

  s.homepage     = "https://github.com/lemanhtien/MTSlideToOpen"
  s.screenshots  = "https://raw.githubusercontent.com/lemanhtien/MTSlideToOpen/master/Screenshot.png"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.author             = { "Tien Le" => "lemanhtien.bka@gmail.com" }
  s.social_media_url   = "https://twitter.com/Martin_ManhTien"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.source       = { :git => "https://github.com/lemanhtien/MTSlideToOpen.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.source_files  = "Source"
  s.framework  = "UIKit"
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "4.2" }
  s.requires_arc = true


end
