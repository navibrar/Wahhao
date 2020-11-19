//  Copyright © 2017 Thapar. All rights reserved.

import Foundation
import UIKit
import AVFoundation
import Photos
import MediaPlayer

class PrivacyPermissions {
    static let sharedInstance = PrivacyPermissions()
    
    //Notification Name
    let PRIVACY_PERMISSION_NOTIFICATION_NAME = Notification.Name("Privacy Permission")
    
    func CHECK_CAMERA_PERMISSIONS(message:String, viewController : UIViewController) -> Bool {
        var isAuthorised = false
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            isAuthorised = true
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    isAuthorised = true
                    // Post notification
                    NOTIFICATIONCENTER.post(name: self.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: message)
                } else {
                    //access denied
                    AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: message, btnTitle1: "Cancel", btnTitle2: "Settings", viewController: viewController, completionHandler: { (response) in
                        if response.caseInsensitiveCompare("Button2") == .orderedSame {
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                                        isAuthorised = success
                                    })
                                }
                            }
                        }else {
                            isAuthorised = false
                        }
                    })
                }
            })
        }
        return isAuthorised
    }
    
    func CHECK_PHOTO_LIBRARY_PERMISSIONS(message:String, viewController : UIViewController) -> Bool {
        var isAuthorised = false
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            isAuthorised = true
        }
        else if (status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    isAuthorised = true
                    // Post notification
                    NOTIFICATIONCENTER.post(name: self.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: message)
                }else {
                    //access denied
                    AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: message, btnTitle1: "Cancel", btnTitle2: "Settings", viewController: viewController, completionHandler: { (response) in
                        if response.caseInsensitiveCompare("Button2") == .orderedSame {
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                                        isAuthorised = success
                                    })
                                }
                            }
                        }else {
                            isAuthorised = false
                        }
                    })
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            isAuthorised = false
        }
        return isAuthorised
    }
    
    func CHECK_MICROPHONE_PERMISSIONS(message:String, viewController : UIViewController) -> Bool {
        var isAuthorised = false
        let microPhoneStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch microPhoneStatus {
        case .notDetermined, .denied:
            //request access
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    isAuthorised = true
                    // Post notification
                    NOTIFICATIONCENTER.post(name: self.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: message)
                } else {
                    //access denied
                    AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: message, btnTitle1: "Cancel", btnTitle2: "Settings", viewController: viewController, completionHandler: { (response) in
                        if response.caseInsensitiveCompare("Button2") == .orderedSame {
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                                        isAuthorised = success
                                    })
                                }
                            }
                        }else {
                            isAuthorised = false
                        }
                    })
                }
            })
        case .restricted:
            isAuthorised = false
        case .authorized:
            isAuthorised = true
        }
        return isAuthorised
    }
    
    func CHECK_MEDIA_LIBRARY_PERMISSIONS(message:String, viewController : UIViewController) -> Bool {
        var isAuthorised = false
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .notDetermined, .denied:
            // not determined
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    isAuthorised = true
                    // Post notification
                    NOTIFICATIONCENTER.post(name: self.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: message)
                } else {
                    //access denied
                    AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: message, btnTitle1: "Cancel", btnTitle2: "Settings", viewController: viewController, completionHandler: { (response) in
                        if response.caseInsensitiveCompare("Button2") == .orderedSame {
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                                        isAuthorised = success
                                    })
                                }
                            }
                        }else {
                            isAuthorised = false
                        }
                    })
                }
            }
            break
        case .restricted:
            isAuthorised = false
            
        case .authorized:
            isAuthorised = true
        }
        return isAuthorised
    }
}
