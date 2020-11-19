//
//  SelectionOfAttacthmentsViewController.swift
//  Consumer
//
//  Created by Apple on 13/07/18.
//  Copyright © 2018 wahhao. All rights reserved.
//

import UIKit
import TLPhotoPicker
import MobileCoreServices
import Photos
import CropViewController
import AVKit
import WebKit
import SVProgressHUD

class SelectionOfAttacthmentsViewController: UIViewController,TLPhotosPickerViewControllerDelegate , CropViewControllerDelegate{

      var selectedAssets = [TLPHAsset]()
    var timer = Timer()
     @IBOutlet weak var text_Message: UITextView!
      @IBOutlet weak var view_MessageBox: UIView!
     @IBOutlet weak var constraint_MessageBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_Message_bottom: NSLayoutConstraint!
    @IBOutlet weak var Photo_ImageView:UIImageView!
     @IBOutlet weak var lower_View:UIView!
      @IBOutlet weak var video_View:UIView!
     @IBOutlet weak var image_back_View:UIView!
    @IBOutlet weak var Document_View:UIView!
    @IBOutlet weak var Document_image_View:UIImageView!
    @IBOutlet weak var Document_lbl_View:UILabel!
     @IBOutlet weak var play_video_Btn :UIButton!
    @IBOutlet weak var cross_video_Btn :UIButton!
    @IBOutlet weak var cross_image_Btn :UIButton!
    @IBOutlet weak var cross_Doc_Btn :UIButton!
    @IBOutlet weak var Doc_Download_Btn :UIButton!
    @IBOutlet weak var webView: WKWebView!
     var messageBoxPlaceholderText = String()
     let playerViewController = AVPlayerViewController()
    var keyboardOpen = String()
    var Post_Identify = String()
    var keyboard_height = Int()
    var getVideo_filename = String()
     @IBOutlet weak var Low_View: UIView!
     var fileUrl = NSURL()
     var selectedImage = UIImage()
     var getstrchatid = String()
     var getprefilledID = Int()
     var to_id = String()
     var withWhom_Id = Int()
     var UplaodedDocs = Int()
    var Doc_FileName = String()
    @IBOutlet weak var btn_SendMessage: UIButton!
    var dict_Localized = [String:String]()
    var str_OK = ""
    var str_Cancel = ""
    var str_Done = ""
    var  str_Un_Approved = ""
    var  str_No_Message = ""
     var getfile_openUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("get getstrchatid",getstrchatid)
        print("get getprefilledID",getprefilledID)
        print("get to_id",to_id)
        print("get withWhom_Id",withWhom_Id)
        str_Cancel = "Cancel"
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
//        self.Photo_ImageView.isUserInteractionEnabled = true
        view_MessageBox.isHidden = true
        Low_View.isHidden = true
//        self.Photo_ImageView.addGestureRecognizer(tap)
//        self.video_View.isUserInteractionEnabled = true
//        self.video_View.addGestureRecognizer(tap)
          lower_View.isHidden = true
         video_View.isHidden = true
         image_back_View.isHidden = true
        Document_View.isHidden = true
         self.initialSetup()
        
       
        // Do any additional setup after loading the view.
    }
    
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "Chat")
        str_OK = GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelOk")
        str_Cancel = GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelCancel")
        str_Done = dict_Localized["labelDone"]!
        
        str_Un_Approved = dict_Localized["label_profile_unapproved"]!
        str_No_Message = dict_Localized["label_No_Message_Entered"]!
        messageBoxPlaceholderText = dict_Localized["label_start_Typing"]!
    }
    
    @objc func Media_Selection()
    {
        let actionSheet = UIAlertController(title: dict_Localized["label_Select_Option"], message: nil, preferredStyle: .actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
        let attributedString = NSAttributedString(string: "Select Media", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.black
            ])
        actionSheet.setValue(attributedString, forKey: "attributedTitle")
        //1
        let takePhotoAction = UIAlertAction(title: "Upload Image", style: .default) { (action) in
            self.image_Selection()
        }
        actionSheet.addAction(takePhotoAction)
        //2
        let chooseFromLibraryAction = UIAlertAction(title: "Upload Video", style: .default) { (action) in
            self.video_selection()
        }
        actionSheet.addAction(chooseFromLibraryAction)
        //3 For upload Document ( PDF , DOC , EXCEL )
        let chooseFromDoucmentAction = UIAlertAction(title: "Upload Documents", style: .default) { (action) in
           self.uploadDocument()
        }
        actionSheet.addAction(chooseFromDoucmentAction)
        // 4
        let cancelAction = UIAlertAction(title: str_Cancel, style: .cancel) { (action) in
            let btn = UIButton()
            self.close_ButtonTapped(btn)
        }
        actionSheet.addAction(cancelAction)
    }
    func uploadDocument() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypePNG), String(kUTTypeJPEG), String(kUTTypeText), "com.microsoft.word.doc", "com.microsoft.excel.xls"], in: .import)
        //let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypePNG), String(kUTTypeJPEG),  String(kUTTypeCompositeContent)], in: .import)
        documentPickerController.delegate = self
        documentPickerController.view.tintColor = UIColor.init(red: 17/255.0, green: 35/255.0, blue: 65/255.0, alpha: 1.0)
        if #available(iOS 11.0, *) {
            documentPickerController.allowsMultipleSelection = false
        }
        documentPickerController.modalPresentationStyle = .formSheet
        self.present(documentPickerController, animated: true,completion: {
        })
    }
    
    func initialSetup()  {
        
        //Comment Box
     //   view_MessageBox.backgroundColor = UIColor.black
       // setLocalizedText()
        text_Message.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        text_Message.text = messageBoxPlaceholderText
        text_Message.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        text_Message.backgroundColor = UIColor.clear
        text_Message.autocorrectionType = .no
        text_Message.autocapitalizationType = .none
        text_Message.spellCheckingType = .no
        text_Message.delegate = self
        text_Message.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        if getfile_openUrl.count > 0 {
            self.Document_View.isHidden = false
            self.webView.load(URLRequest(url: URL(string: getfile_openUrl)!))
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.Media_Selection()
            }
        }
        //        enableDisableSendMessageButton(isEnabled: false)
    }
    func resetMessageBoxView() {
        //text_Message.text = messageBoxPlaceholderText
        text_Message.text = ""
        text_Message.textColor = UIColor.lightGray
        self.constraint_MessageBoxHeight.constant = 48
        //        enableDisableSendMessageButton(isEnabled: false)
    }
    @objc func viewTapped() {
     //   self.dismiss(animated: true, completion: nil)
       self.view.endEditing(true)
    }
    @IBAction func close_ButtonTapped(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    @IBAction func image_Selection()
    {
        let tlPhotoPickerController = TLPhotosPickerViewController()
        tlPhotoPickerController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.allowedVideo = true
        //configure.mediaType = PHAssetMediaType.video
        tlPhotoPickerController.configure.mediaType = .image
        let lang_Dict = GET_LOCALIZED_STRING_DICTIONARY(forClass: "CommonMessages")
        tlPhotoPickerController.configure.cancelTitle = lang_Dict["labelCancel"] ?? "Cancel"
        tlPhotoPickerController.configure.doneTitle = lang_Dict["labelDone"] ?? "Done"
        tlPhotoPickerController.configure.tapHereToChange = lang_Dict["labelTapHereToChange"] ?? "Tap here to change"
        tlPhotoPickerController.configure.defaultCameraRollTitle = lang_Dict["labelCameraRoll"] ?? "Camera Roll"
        tlPhotoPickerController.configure.emptyMessage = lang_Dict["labelNoAlbums"] ?? "No albums"
        tlPhotoPickerController.configure.selectedColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1)
        tlPhotoPickerController.configure.singleSelectedMode = true
        self.present(tlPhotoPickerController, animated: true, completion: nil)
    }
    
    @IBAction func video_selection()
    {
        
        let tlPhotoPickerController = TLPhotosPickerViewController()
        tlPhotoPickerController.delegate = self
        //tlPhotoPickerController.configure.maxVideoDuration = 20.0
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
        self.present(tlPhotoPickerController, animated: true, completion: nil)
        
    }
    @IBAction func downloadImageTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if let fileUrl = URL(string: self.getfile_openUrl) {
                self.downloadFileFromUrl(fileUrl: fileUrl)
            }
        }
    }
    func downloadFileFromUrl(fileUrl: URL) {
        var isUrlData = false
        if let fileData = NSData.init(contentsOf: fileUrl) {
            isUrlData = true
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [fileData], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .airDrop,.assignToContact]
            self.present(activityViewController, animated: true, completion: nil)
            //Hide Loader
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.dismiss()
            }
        }
        if isUrlData == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                SVProgressHUD.dismiss()
            }
        }
    }
    @IBAction func sendButtonTapped(_ sender: UIButton) {
//        if text_Message.text.caseInsensitiveCompare(messageBoxPlaceholderText) == .orderedSame {
//            let alert = UIAlertController(title: nil, message: str_No_Message, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: str_OK, style: .cancel
//                , handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        self.view.endEditing(true)
         self.callSendMsg()
    }
    @IBAction func cross_image_ButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
            image_back_View.isHidden = true
    }
    @IBAction func cross_Vide_ButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
            video_View.isHidden = true
    }
    @IBAction func cross_Doc_ButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        Document_View.isHidden = true
    }
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        getFirstSelectedImage()
        //iCloud or video
        // getAsyncCopyTemporaryFile()
    }
    @IBAction func playVideo() {
        playerViewController.player!.play()
        play_video_Btn.setImage(UIImage(named: ""), for: .normal)
    }
    func getFirstSelectedImage() {
        if let asset = self.selectedAssets.first {
            if asset.type == .video {
                asset.tempCopyMediaFile(convertLivePhotosToJPG: false, progressBlock: { (progress) in
                    print(progress)
                }, completionBlock: { (url, mimeType) in
                    print("completion\(url)")
                    self.lower_View.isHidden = true
                    self.getVideo_filename = asset.originalFileName!
                    var filePath = String()
                    filePath = url.absoluteString
                    print("filePath",filePath)
                    let newString = filePath.replacingOccurrences(of: "file:///", with: "/")
                    print("newString",newString)
                    self.fileUrl = NSURL(fileURLWithPath: newString)
                    self.Post_Identify = "Video"
                    self.manageVideoFileUpload(Fileurl: self.fileUrl as URL, Video_fileName: self.getVideo_filename)
                    //  print(mimeType)
                })
                return
            }
            if let image = asset.fullResolutionImage {
                print(image)
                self.lower_View.isHidden = true
                self.selectedImage = self.selectedAssets.first!.fullResolutionImage!
                self.Post_Identify = "Image"
                 self.uploadCroppedImageToServer(croppedImage: self.selectedImage)
            }
        }
    }
    @IBAction func Crop_ButtonTapped(_ sender: UIButton) {
        self.presentCropViewController()
    }
    //MARK:- Crop Images
    func presentCropViewController ()
    {
        let image: UIImage = (self.Photo_ImageView.image)!
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.doneButtonTitle = str_Done
        cropViewController.cancelButtonTitle = str_Cancel
        
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.Photo_ImageView.image  = image
        self.dismiss(animated: true, completion: nil)
    }
    func photoPickerDidCancel() {
         print("TLPhotoPicker Cancelled")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            if constraint_Message_bottom.constant == 0{
                //291.0 34.0
                //self.view.frame.origin.y -= keyboardSize.height
                if UIScreen.main.nativeBounds.height == 2436 {
                    self.constraint_Message_bottom.constant -= (keyboardSize.height - 30)
                }else {
                    self.constraint_Message_bottom.constant -= (keyboardSize.height - 3)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            if constraint_Message_bottom.constant != 0{
                //self.view.frame.origin.y += keyboardSize.height
                //                if UIScreen.main.nativeBounds.height == 2436 {
                //                    self.constraint_Message_bottom.constant -= 291-34
                //                }else {
                self.constraint_Message_bottom.constant = 0
                //                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: =======Upload Image=========
    
    func uploadCroppedImageToServer(croppedImage:UIImage)
    {
        let pickedMediaName = Date.CONVERT_DATE_TO_STRING(formatter: "dd_MM_yy_hh_mm_ss", date: Date()) + ".jpeg"
        var fileType = String()
        
        fileType = "image/jpeg"
        let capturedImage : UIImage = croppedImage
        let imageData = capturedImage.pngData()
        //*********File Size************
        let fileSize : Double = Double(imageData!.count)
        let size = (fileSize/1000.0)/1000.0
        
        
        let heightInPoints = capturedImage.size.height
        let heightInPixels = heightInPoints * croppedImage.scale
        
        let widthInPoints = capturedImage.size.width
        let widthInPixels = widthInPoints * croppedImage.scale
        
        print(heightInPixels,widthInPixels)
        
        // let allowedFileSize : Double = 5.0
        if size > FILE_SIZE {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: "Maximum file size: 25MB", btnTitle: str_OK, viewController: self, completionHandler: { (success) in
            })
        }
        //***************
        let service = GetChatDetails()
        service.uploadFileToServerAsDataForDoccument(fileData: imageData, fileName: pickedMediaName, fileType: fileType, forKey: "Resource", showLoader: true, completionBlockSuccess: { (respone) -> Void in
            //Success block
            print("success")
            
            if (respone as! NSDictionary)["status"] as! Bool == true
            {
                self.Low_View.isHidden = false
                 self.lower_View.isHidden = true
                self.view_MessageBox.isHidden = false
                 self.image_back_View.isHidden = false
                self.Photo_ImageView.image = croppedImage
                
                let id = ((respone as! NSDictionary)["response"] as! NSDictionary)["resource_id"] as! Int
                self.UplaodedDocs = id
            }
            else
            {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
                    self.dismiss(animated: true, completion: nil)
                })                    }
        },
                                                     
                                                     andFailureBlock: { (failure) -> Void in
                                                        // your failure handle
                                                        if let value = failure["message"] {
                                                            self.showAlertWithMessage(message: value as! String, title: "")
                                                        }else {
                                                            self.showAlertWithMessage(message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), title: "")
                                                        }
                                                        print(failure.localizedDescription ?? "Unable to upload file to server")})
        //}
    }

    
    func manageVideoFileUpload(Fileurl:URL,Video_fileName: String){
                print("completion\(Fileurl)")
                let videoURL = Fileurl
                if self.checkMediaFileExistInDocumentDirectory(mediaUrl: videoURL, fileName: Video_fileName) == false {
                    AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: "Some error occured", time: 1.0)
                }
                //Upload File to server
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let filePath = (documentDirectory! as NSString).appendingPathComponent(Video_fileName)
                print(filePath)
                self.callUploadMediaFileToServerAsFileURL(filePath: filePath, fileName: Video_fileName, fileType: "video/mp4")
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
    
    
    func callUploadMediaFileToServerAsFileURL(filePath: String, fileName: String, fileType: String) {
        let service = GetChatDetails()
        service.callUploadPostMediaFileToServerAsFileURL(filePath: filePath, fileName: fileName, fileType: fileType, forKey: "Resource", showLoader: true, completionBlockSuccess: { (respone) -> Void in
            //Success block
            print(respone)
            if (respone as! NSDictionary)["status"] as! Bool == true
            {
                self.clearTempDataFromDocumentDirectory()
                let player = AVPlayer(url: self.fileUrl as URL)
                self.playerViewController.player = player
                let avPlayerLayer = AVPlayerLayer(player: player)
                avPlayerLayer.frame = self.video_View.bounds
                avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
                self.video_View.layer.insertSublayer(avPlayerLayer, at: 0)
                
                self.view_MessageBox.isHidden = false
                self.video_View.isHidden = false
                self.lower_View.isHidden = true
                self.Low_View.isHidden = false
                let id = ((respone as! NSDictionary)["response"] as! NSDictionary)["resource_id"] as! Int
                self.UplaodedDocs = id
            }
            else {
                self.showAlertWithMessage(message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), title: "")
            }
        },andFailureBlock: { (failure) -> Void in
            // your failure handle
            if let value = failure["message"] {
                self.showAlertWithMessage(message: value as! String, title: "")
            }else {
                self.showAlertWithMessage(message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), title: "")
            }
            print(failure.localizedDescription ?? "Unable to upload file to server")})
    }
    func showAlertWithMessage(message:String, title: String) {
        AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: title, message: message, btnTitle: self.str_OK, viewController: self) { (success)
            in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */




extension SelectionOfAttacthmentsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messageBoxPlaceholderText {
            self.constraint_MessageBoxHeight.constant = 48
            textView.text = ""
            //            UIView.animate(withDuration: 0.3, animations: {
            //                self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 250, width:self.view.frame.size.width, height:self.view.frame.size.height);
            //        })
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = self.messageBoxPlaceholderText
            textView.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        }else {
            textView.textColor = #colorLiteral(red: 0.7176470588, green: 0.7764705882, blue: 0.8784313725, alpha: 1)
        }
        //        UIView.animate(withDuration: 0.3, animations: {
        //            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 250, width:self.view.frame.size.width, height:self.view.frame.size.height);
        //
        //        })
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.constraint_MessageBoxHeight.constant < 150
        {
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height < 36 ? 36 : newSize.height)
            self.constraint_MessageBoxHeight.constant = newFrame.size.height + 10
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true && text == "\n" {
            textView.text = messageBoxPlaceholderText
            textView.resignFirstResponder()
        }
        else if (newText == "\n") {
            text_Message.resignFirstResponder()
        }
        else {
            //enableDisableSendMessageButton(isEnabled: !(newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
        }
        return newText.count <= 200
    }
}


extension SelectionOfAttacthmentsViewController{
func callSendMsg() {
   
    var gettextmsg = text_Message.text
     if gettextmsg == messageBoxPlaceholderText {
        gettextmsg = ""
    }
    let parameters:  [String: Any] = [
        "chat_id": getstrchatid,
        "from_id": getprefilledID,
        "to_id": to_id,
        "message": gettextmsg as Any,
        "resource": UplaodedDocs,
        "withwhom_group": withWhom_Id,
        ]
    print("parm get.......",parameters)
     let store1 = GetChatDetails.sharedInstance
    store1.callWebserviceforsendMsg(parameters: parameters, outhType: "", isShowLoader: true,showLoader: true, completionBlockSuccess: { (success) -> Void in
        
        print("Success")
        
        if let response = success["response"] as? NSDictionary {
            if let chat_id_dict = response["message"] as? NSDictionary {
                if  let value = chat_id_dict["chat_id"] as? Int {
                    self.getstrchatid = String(value)
                }else if  let value = chat_id_dict["chat_id"] as? NSNumber {
                    self.getstrchatid = value.stringValue
                }else {
                    self.getstrchatid = chat_id_dict["chat_id"] as? String ?? ""
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "Media_Upload"), object: self.getstrchatid)
                     NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "Media_Upload_history"), object: self.getstrchatid)
                     self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        // self.navigationController?.popViewController(animated: true)
        
        
    }) { (failure) -> Void in
        // your failure handle
        if let value = failure["message"] {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: (value as? String)!, btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
            })
        } else{
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
            })
        }
    }
}
}
//MARK:- DocumentPickerDelegate
extension SelectionOfAttacthmentsViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
        do {
            //********File Size*******
            let resources = try url.resourceValues(forKeys:[.fileSizeKey])
            let fileSize : Double = Double(resources.fileSize!)
            let size = (fileSize/1000.0)/1000.0
            if size > FILE_SIZE {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "onboardOtherDetails", withKey: "lableFileSizeError"), btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
                })
                return
            }
            //**********
            let documentData = try Data(contentsOf: url as URL)
            let file_name = (url.lastPathComponent).replacingOccurrences(of: " ", with: "_")
            let file_extenstion = url.pathExtension
            Doc_FileName = file_name
            
            let fileType = Validations.getMimeType(file_extenstion: file_extenstion)
            
            let service = GetChatDetails()
            service.uploadFileToServerAsDataForDoccument(fileData: documentData, fileName: file_name, fileType: fileType, forKey: "Resource", showLoader: true, completionBlockSuccess: { (respone) -> Void in
                //Success block
                print("success")
                var ThumbnilimageURL = String()
                if (respone as! NSDictionary)["status"] as! Bool == true
                {
                    
                    if fileType.contains("image")
                    {
                        let result = url
                        let url = result.absoluteString
                        //url to string
                        ThumbnilimageURL = url
                        print("get ThumbnilimageURL",ThumbnilimageURL)
                    }
                    else {
                        ThumbnilimageURL = ""
                    }
                    
                    let sepratestring = self.Doc_FileName.components(separatedBy: "/")
                    let getname : String = sepratestring.last ?? ""
                    self.Doc_Download_Btn.isHidden = true
                    print("get extension name of file",getname)
                    if getname.contains(".png") || getname.contains(".PNG") || getname.contains(".jpg") || getname.contains(".JPG") || getname.contains(".jpeg") || getname.contains(".JPEG")    {
                        
                        let Str_media_url = ((respone as! NSDictionary)["response"] as! NSDictionary)["media_url"]
                        print("get image url",Str_media_url as Any)
                        let fileUrl = URL(string: Str_media_url as! String)
                        
                        self.Low_View.isHidden = false
                        self.lower_View.isHidden = true
                        self.view_MessageBox.isHidden = false
                        self.image_back_View.isHidden = false
                        self.Photo_ImageView.image = UIImage(named: "PlaceholderImage")
                        self.Photo_ImageView.kf.setImage(with: fileUrl)
                        
                    }
                    else {
                        if getname.contains(".pdf") || getname.contains(".PDF"){
                            self.Document_image_View.image = UIImage(named:"pdf_file")
                        }
                        else if getname.contains(".doc") || getname.contains(".docx") || getname.contains(".rtf"){
                            self.Document_image_View.image = UIImage(named:"doc_file")
                        }
                        else if getname.contains(".xls") {
                            self.Document_image_View.image = UIImage(named:"xls_file")
                        }
                        else {
                            self.Document_image_View.image = UIImage(named:"PlaceholderImage")
                        }
                        let request = NSURLRequest(url: url)
                        self.webView.load(request as URLRequest)
                        
                        
                        self.Document_View.isHidden = false
                        self.Document_lbl_View.text = getname
                        
                        self.Low_View.isHidden = false
                        self.lower_View.isHidden = true
                        self.view_MessageBox.isHidden = false
                    }
                    let id = ((respone as! NSDictionary)["response"] as! NSDictionary)["resource_id"] as! Int
                    self.UplaodedDocs = id
                }
                else
                {
                    AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), btnTitle: self.str_OK, viewController: self, completionHandler: { (success) in
                        self.dismiss(animated: true, completion: nil)
                    })                    }
                
            },
                                                         
                                                         andFailureBlock: { (failure) -> Void in
                                                            // your failure handle
                                                            if let value = failure["message"] {
                                                                self.showAlertWithMessage(message: value as! String, title: "")
                                                            }else {
                                                                self.showAlertWithMessage(message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelSomethingWrong"), title: "")
                                                            }
                                                            print(failure.localizedDescription ?? "Unable to upload file to server")})
            
            
            
            
        } catch {
            print("Unable to load data: \(error)")
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("cancelled")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


