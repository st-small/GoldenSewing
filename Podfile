# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'GoldenSewing' do
  
    use_frameworks!
    pod 'Firebase/Crashlytics'
    pod 'Firebase/Analytics'
    pod 'Firebase/Core'
    pod 'OneSignal', '>= 2.10.0', '< 3.0'
    pod 'RealmSwift'
    pod 'Alamofire', '~> 5.2'
    pod 'Gloss', '~> 3.2.1'
    pod 'SnapKit', '~> 5.0.0'
    pod 'SDWebImage', '~> 5.9.1'
    pod 'Toast-Swift', '~> 5.0.0'
    pod 'SwiftSoup', '~> 2.3.2'

end

target 'Golden Sewing Tests' do
  
  use_frameworks!
  pod 'Crashlytics'
  pod 'Firebase/Core'
  pod 'OneSignal', '>= 2.10.0', '< 3.0'
  pod 'RealmSwift'
  pod 'Alamofire', '~> 5.2'
  pod 'Gloss', '~> 3.2.1'
  pod 'SnapKit', '~> 5.0.0'
  pod 'SDWebImage', '~> 5.9.1'
  pod 'Toast-Swift', '~> 5.0.0'
  pod 'SwiftSoup', '~> 2.3.2'
  
end

target 'GoldenSewingUITests' do
  
  use_frameworks!
  pod 'Firebase/Core'
  pod 'OneSignal', '>= 2.10.0', '< 3.0'
  pod 'RealmSwift'
  pod 'Alamofire', '~> 5.2'
  pod 'Gloss', '~> 3.2.1'
  pod 'SnapKit', '~> 5.0.0'
  pod 'SDWebImage', '~> 5.9.1'
  pod 'Toast-Swift', '~> 5.0.0'
  pod 'SwiftSoup', '~> 2.3.2'
  
end

target 'OneSignalNotificationServiceExtension' do
  use_frameworks!
  pod 'OneSignal', '>= 2.10.0', '< 3.0'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
