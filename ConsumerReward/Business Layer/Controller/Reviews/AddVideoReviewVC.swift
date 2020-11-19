//  Created by Navpreet on 31/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit
import Cosmos
import TLPhotoPicker
import CropViewController
import AVKit

class AddVideoReviewVC: UIViewController {
    //MARK:- Variable Declaration
    var selectedImage = UIImage()
    var selectedVideoAsset: TLPHAsset? = nil
    var videoMediaUrl: URL? = nil
    var orders_details : OrderDetail? = nil
    var orders_info : Order? = nil
    var uploadedMediaResourceId = Int()
    
    var file_Path = String()
    var cropedVideoPath = ""
    var fileName = String()
    var fileType = String()
    let store = OrderInfoService.sharedInstance
    var get_post_info = String()
    var get_variant_id = String()
    var get_order_id = String()

    //MARK:- Outlet Connections
    @IBOutlet weak var btn_ShareReview: UIButton!
    @IBOutlet weak var view_ProductDetail: UIView!
    @IBOutlet weak var view_AddVideoReview: UIView!
    @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_AddVideoReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var view_VideoReview: UIView!
    @IBOutlet weak var constraint_VideoReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var img_VideoReview: UIImageView!
    @IBOutlet weak var btn_PlayVideo: UIButton!
    @IBOutlet weak var btn_DeleteVideo: UIButton!
    @IBOutlet weak var view_ReviewMessage: UIView!
    @IBOutlet weak var lbl_ReviewMessage: UILabel!
    @IBOutlet weak var img_Product: UIImageView!
    @IBOutlet weak var lbl_ProductName: UILabel!
    @IBOutlet weak var lbl_ProductColor: UILabel!
    @IBOutlet weak var view_ProductReviews: CosmosView!
   
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        //Notification
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.checkPermissionAuthorizedByUser), name: PrivacyPermissions.sharedInstance.PRIVACY_PERMISSION_NOTIFICATION_NAME, object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.cropVideo), name: Notification.Name(rawValue: "CropVideo"), object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.removeMedia), name: Notification.Name(rawValue: "removeMedia"), object: nil)
       FirAnalytics.trackPageView(withScreen: FirAnalytics.Screen.addvideoreview)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- NSNotification Center method
    @objc func checkPermissionAuthorizedByUser(note: NSNotification) {
        if let object = note.object as? String {
            if object == ConfigurationManager.PrivacyPermissionMessage.Video_Picker_Permission_Message.rawValue || object == ConfigurationManager.PrivacyPermissionMessage.Video_Capture_Permission_Message.rawValue{
                self.openGalleryToPickVideo()
            }
        }
    }
    //MARK: cropedVideo data
    @objc func cropVideo(notification: NSNotification) {
        
        var uniqueVideoID = ""
        var videoURL:URL?
        let uniqueID = ""
        if let object = notification.object as? Dictionary<String, Any> {
            print(object)
            
            let url = object["videoUrl"] as? URL
            let strURL =   url!.absoluteString
            print(strURL)
            if let thumbnail = object["thumbNailImage"] as? UIImage{
                DispatchQueue.main.async {
                    self.img_VideoReview.image = thumbnail
                }}
             self.showVideoView()
            //Getting the path as URL and storing the data in myVideoVarData.
            videoURL = object["videoUrl"] as? URL
            let myVideoVarData = try! Data(contentsOf: videoURL! as URL)
            //Now writeing the data to the temp diroctory.
            let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let tempDocumentsDirectory: AnyObject = tempPath[0] as AnyObject
            
            uniqueVideoID = uniqueID  + selectedVideoAsset!.originalFileName!
            self.cropedVideoPath = tempDocumentsDirectory.appendingPathComponent(uniqueVideoID) as String
            try? myVideoVarData.write(to: URL(fileURLWithPath: self.cropedVideoPath), options: [])
            self.videoMediaUrl  = URL.init(fileURLWithPath: self.cropedVideoPath)
            // self.callUploadMediaFileToServerAsFileURL(filePath: tempDataPath, fileName: selectedVideoAsset!.originalFileName!, fileType: "video/mp4")
        }
    }
    //MARK:- Custom Methods
    func initialSetup() {
        //Enable scrolling for small devices to show complete view
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E {
            constraint_ViewContentHeight.constant = 100
        }
        view_ProductDetail.topRoundCornners(radius: 6.0)
        view_ReviewMessage.bottomRoundCornners(radius: 6.0)
        self.hideUnhideVideoReview(isHide: true)
        self.hideUnhideAddVideoReview(isHide: false)
        if get_post_info.count > 0 {
            lbl_ProductName.text = self.orders_info?.Product_Name
            lbl_ProductColor.text = self.orders_info?.color
            
            let productImageUrl = orders_info?.image
            if productImageUrl != "" {
                let url = URL(string: productImageUrl!)
                img_Product.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
                
            }
            let get_ratinginfo = (self.orders_info?.rating_info as NSString?)!.doubleValue
            view_ProductReviews.rating = get_ratinginfo
            get_variant_id = (self.orders_info?.variant_id)!
            get_order_id = (self.orders_info?.order_id)!
            
        }else {
        lbl_ProductName.text = self.orders_details?.purchase_details.product_name
        lbl_ProductColor.text = self.orders_details?.purchase_details.color
        let productImageUrl = orders_details?.purchase_details.image.Thumbnail
        if productImageUrl != "" {
            let url = URL(string: productImageUrl!)
           img_Product.kf.setImage(with: url, placeholder: UIImage(named:Constants.PRODUCT_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)

        }
        let get_ratinginfo = (self.orders_details?.purchase_details.rating as NSString?)!.doubleValue
        view_ProductReviews.rating = get_ratinginfo
            get_variant_id = (self.orders_details?.purchase_details.variant_id)!
             get_order_id = (self.orders_details?.order_id)!
        }
    }
    func hideUnhideAddVideoReview(isHide: Bool) {
        if isHide == true {
            view_AddVideoReview.isHidden = true
            constraint_AddVideoReviewHeight.constant = 0
        }else {
            view_AddVideoReview.isHidden = false
            constraint_AddVideoReviewHeight.constant = 80
        }
    }
    func hideUnhideVideoReview(isHide: Bool) {
        if isHide == true {
            view_VideoReview.isHidden = true
            constraint_VideoReviewHeight.constant = 0
        }else {
            view_VideoReview.isHidden = false
            constraint_VideoReviewHeight.constant = self.view.bounds.width - 56
        }
    }
    func uploadVideo() {
        let isAuthorized : Bool = PrivacyPermissions.sharedInstance.CHECK_PHOTO_LIBRARY_PERMISSIONS(message: ConfigurationManager.PrivacyPermissionMessage.Video_Picker_Permission_Message.rawValue, viewController: self)
        if isAuthorized == true {
            self.openGalleryToPickVideo()
        }
    }
    func showVideoView() {
        self.img_VideoReview.image = self.selectedImage
        self.hideUnhideAddVideoReview(isHide: true)
        self.hideUnhideVideoReview(isHide: false)
    }
  @objc func removeMedia() {
        self.img_VideoReview.image = UIImage()
        self.videoMediaUrl = nil
        self.selectedVideoAsset = nil
        self.cropedVideoPath = ""
        self.fileType = ""
        self.selectedImage = UIImage()
        self.hideUnhideAddVideoReview(isHide: false)
        self.hideUnhideVideoReview(isHide: true)
       self.file_Path = ""
        self.fileName = ""
        self.fileType = ""
        self.cropedVideoPath = ""
        
    }
    func openGalleryToPickVideo(){
        //TLPhoto Picker
        let tlPhotoPickerController = TLPhotosPickerViewController()
        tlPhotoPickerController.delegate = self
        // take only 30 sec video
        tlPhotoPickerController.configure.maxVideoDuration = 30.0
        tlPhotoPickerController.configure.mediaType = .video
        
        let lang_Dict = GET_LOCALIZED_STRING_DICTIONARY(forClass: "CommonMessages")
        tlPhotoPickerController.configure.cancelTitle = lang_Dict["labelCancel"] ?? "Cancel"
        tlPhotoPickerController.configure.doneTitle = lang_Dict["labelDone"] ?? "Done"
        tlPhotoPickerController.configure.tapHereToChange = lang_Dict["labelTapHereToChange"] ?? "Tap here to change"
        tlPhotoPickerController.configure.defaultCameraRollTitle = lang_Dict["labelCameraRoll"] ?? "Camera Roll"
        tlPhotoPickerController.configure.emptyMessage = lang_Dict["labelNoAlbums"] ?? "No albums"
        
        tlPhotoPickerController.configure.selectedColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        tlPhotoPickerController.configure.singleSelectedMode = true
        tlPhotoPickerController.configure.allowedVideoRecording = true
        //tlPhotoPickerController.configure.usedCameraButton = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.present(tlPhotoPickerController, animated: true, completion: nil)
        }
      
    }
    func cropImage(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.doneButtonTitle = "Done"
        cropViewController.cancelButtonTitle = "Cancel"
        cropViewController.aspectRatioPreset = .presetCustom
        /*cropViewController.customAspectRatio = CGSize(width: self.view.bounds.width, height: self.view.bounds.width)
         cropViewController.cropView.cropBoxResizeEnabled = false
         cropViewController.aspectRatioLockEnabled = true
         cropViewController.resetAspectRatioEnabled = false*/
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    func checkMediaFileExistInDocumentDirectory(mediaUrl:URL, fileName:String) -> Bool{
        var status = false
        let fileManager = FileManager.default
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create a name for your Media File
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        if !fileManager.fileExists(atPath: fileURL.path) {
            status = saveMediaFileToDocumentDirectory(mediaUrl: mediaUrl, fileURL: fileURL)
        }else {
            //File already Exists at path
            do {
                try fileManager.removeItem(atPath: fileURL.path)
                status = saveMediaFileToDocumentDirectory(mediaUrl: mediaUrl, fileURL: fileURL)
            } catch let error as NSError {
                print(error.debugDescription)
                status = false
            }
        }
        return status
    }
    func saveMediaFileToDocumentDirectory(mediaUrl:URL,fileURL:URL) -> Bool {
        var status = false
        do {
            let mediaFileData = NSData.init(contentsOf: mediaUrl)
            //videoData?.write(to: fileURL, atomically: false)
            try mediaFileData?.write(to: fileURL, options: .completeFileProtection)
            print("Media File Added Successfully")
            status = true
        } catch {
            print(error)
            status = false
        }
        return status
    }
    
    func clearTempDataFromDocumentDirectory() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: path) else { return }
        for item in items {
            // This can be made better by using pathComponent
            let completePath = path.appending("/").appending(item)
            try? FileManager.default.removeItem(atPath: completePath)
        }
    }
   
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addVideoReviewTapped(_ sender: Any) {
        self.uploadVideo()
    }
    @IBAction func shareReviewTapped(_ sender: Any) {
        print(view_ProductReviews.rating)
        if view_ProductReviews.rating == 0 {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: "Please give rating to share review", btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (success)
                in
            }
        }else if self.cropedVideoPath == "" {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: "Please upload video", btnTitle: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk"), viewController: self) { (success)
                in
            }
        }else {
            self.callUploadMediaFileToServerAsFileURL(filePath: self.cropedVideoPath, fileName: selectedVideoAsset!.originalFileName!, fileType: fileType)
            }
    }
    @IBAction func playVideoTapped(_ sender: Any) {
        let player = AVPlayer(url: videoMediaUrl!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    @IBAction func deleteVideoTapped(_ sender: Any) {
        AlertController.SHOW_ALERT_CONTROLLER_DOUBLE_BUTTON(alertTitle: "", message: "Are you sure you want to delete video review?", btnTitle1: "Cancel", btnTitle2: "Yes", viewController: self) { (response) in
            if response.caseInsensitiveCompare("Button2") == .orderedSame {
                self.removeMedia()
                self.file_Path = ""
                self.fileName = ""
                self.fileType = ""
                self.cropedVideoPath = ""
            }
        }
    }
}

//MARK: - TLPhotoPicker Controller Delegate
extension AddVideoReviewVC : TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if withTLPHAssets.count > 0 {
            if withTLPHAssets.first!.fullResolutionImage != nil {
                /*self.selectedImage = withTLPHAssets.first!.fullResolutionImage!
                 self.selectedVideoAsset = withTLPHAssets.first
                 self.cropImage(image: self.selectedImage)*/
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                self.selectedVideoAsset = withTLPHAssets.first
                self.selectedImage = withTLPHAssets.first!.fullResolutionImage!
                self.manageVideoFileUpload()
                }
            }else {
                AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), time: 1.0)
            }
        }
    }
    func photoPickerDidCancel() {
        print("TLPhotoPicker Cancelled")
    }
    func manageVideoFileUpload(){
        if let asset = self.selectedVideoAsset {
            asset.tempCopyMediaFile(convertLivePhotosToJPG: false, progressBlock: { (progress) in
                print(progress)
            }, completionBlock: { (url, mimeType) in
                print("completion\(url)")
                print("mimetype is  = \(mimeType)")
                let videoURL = url
                self.videoMediaUrl = videoURL
                
                if self.checkMediaFileExistInDocumentDirectory(mediaUrl: videoURL, fileName: asset.originalFileName!) == false {
                    AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), time: 1.0)
                }
                //Upload File to server
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let filePath = (documentDirectory! as NSString).appendingPathComponent(asset.originalFileName!)
                print(filePath)
               // self.showVideoView()
                // self.file_Path = filePath
                // self.fileName = asset.originalFileName!
                self.fileType = "video/mp4"
                
                //Add video croper
                let stortyBoard = UIStoryboard.init(name: "Reviews", bundle: nil)
                let vc = stortyBoard.instantiateViewController(withIdentifier: "VideoTrimVC") as? VideoTrimViewController
                
                vc?.videoURL = self.videoMediaUrl
                self.present(vc!, animated: true, completion: nil)
                
                
            })
            return
        }
    }
}

//MARK:- Crop View Controller Delegate
extension AddVideoReviewVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.selectedImage = image
        self.manageVideoFileUpload()
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- API METHODS
extension AddVideoReviewVC {
    func callUploadMediaFileToServerAsFileURL(filePath: String, fileName: String, fileType: String) {
        store.callUploadPostMediaFileToServerAsFileURL(filePath: filePath, fileName: fileName, fileType: fileType, forKey: "resource", showLoader: true, completionBlockSuccess: { (respone) -> Void in
            //Success block
            print(respone)
            if (respone as! NSDictionary)["status"] as! Bool == true {
                self.clearTempDataFromDocumentDirectory()
//                self.addImageToImageView(image: self.selectedImage)
                let id = ((respone as! NSDictionary)["response"] as! NSDictionary)["resource_id"] as! Int
                self.uploadedMediaResourceId  = id
                print("get id",self.uploadedMediaResourceId)
                 FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.addvideoreview, category: FirAnalytics.Category.addvideoreview, label: FirAnalytics.Label.addvideoreview_addvideo, action: FirAnalytics.Actions.addvideo, value: 1)
                self.uploadFinalReview(get_resource_id: String(self.uploadedMediaResourceId))
            }else {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: "Ok", viewController: self, completionHandler: { (success) in

                })                    }
        },andFailureBlock: { (failure) -> Void in
            // your failure handle
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.addvideoreview, category: FirAnalytics.Category.addvideoreview, label: FirAnalytics.Label.addvideoreview_addvideo, action: FirAnalytics.Actions.addvideo, value: 0)
            if let value = failure["message"] {
                self.showAlertWithMessage(title: "", message: value as! String)
            }else {
                self.showAlertWithMessage(title: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"))
            }
            print(failure.localizedDescription ?? "Unable to upload file to server")})
    }
    
    
    
    func uploadFinalReview(get_resource_id:String) {
        let parameters:  [String: Any] = [
            "resource_id": get_resource_id,
            "product_id": get_variant_id,
            "order_id": get_order_id,
            "review": "",
            "rating": round(view_ProductReviews.rating),
            ]
        store.callWebserviceforaddReview(parameters: parameters, outhType: "", isShowLoader: true,showLoader: true, completionBlockSuccess: { (success) -> Void in
            print("Success")
            
              FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.addvideoreview, category: FirAnalytics.Category.addvideoreview, label: FirAnalytics.Label.addvideoreview_postreview, action: FirAnalytics.Actions.postreview, value: 1)
            
            self.view.isUserInteractionEnabled = false
           
            if let value = success["message"] {
                let alert = CustomAlert()
                alert.showCustomAlertWithImage(message: value as! String, imageName: "", viewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
             FirAnalytics.trackEvent(withScreen: FirAnalytics.Screen.addvideoreview, category: FirAnalytics.Category.addvideoreview, label: FirAnalytics.Label.addvideoreview_postreview, action: FirAnalytics.Actions.postreview, value: 0)
        }
    }
}
