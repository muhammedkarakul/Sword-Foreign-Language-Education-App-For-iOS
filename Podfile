# Uncomment the next line to define a global platform for your project
platform :ios, '10.3'

target 'Sword' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sword
  pod "BWWalkthrough"
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'ProgressHUD'
  pod "Koloda"
  pod 'RealmSwift'
  pod 'DeviceKit', '~> 1.3'
  pod "GTProgressBar"
  pod 'Charts'
  pod 'SwiftyPlistManager'
  
  target 'SwordTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SwordUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end


