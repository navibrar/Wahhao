# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ConsumerReward' do
use_frameworks!

pod 'Alamofire’
pod 'Cosmos'
pod 'CropViewController'
pod 'TLPhotoPicker'
pod 'PinCodeTextField'
pod 'SVProgressHUD'
pod 'MTSlideToOpen'
pod 'SwiftPhoneNumberFormatter' 
pod 'SkyFloatingLabelTextField'
pod 'TPKeyboardAvoidingSwift'
pod 'Kingfisher'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'ScrollableSegmentedControl', '~> 1.4.0'
pod 'Stripe'
pod 'SwiftyGif'
pod 'StepIndicator'
pod 'Branch'
pod 'Firebase/Core'

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
 end


  target 'ConsumerRewardTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ConsumerRewardUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
