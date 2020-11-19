//
//  CropVideoViewController.swift
//  Brand
//
//  Created by apple on 07/01/19.
//  Copyright © 2019 wahhao. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
public protocol trimVideoDelegate: class {
    func selectedVideo(_ description:URL,image:UIImage)
}
class CropVideoViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var collectionBackgroundView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
   // var frames = [UIImage]()
    var cropVideoUrl : URL?
    var selectedImageIndex : Int?
    var duration: Float64   = 0.0
    var imagesCount : Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    private var generator:AVAssetImageGenerator!
    var thumbnailViews = [UIImageView]()
    var thumbnails = [UIImage]()
    var selectedThumbNail = UIImage()
    open weak var delegate: trimVideoDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackViewImage()
        selectedImageIndex = 0
        // converPhoto(index: selectedImageIndex!)
        self.duration = ABVideoHelper.videoDuration(videoURL: cropVideoUrl!)
        updateThumbnails(view: self.collectionView, videoURL: cropVideoUrl!, duration: self.duration)
       // print(thumbnailViews)
        collectionBackgroundView.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }
    func addBackViewImage() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bg_theme"))
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    
    func coverPhoto(index : Int)  {
        let image = self.thumbnails[index]
        self.thumbnailImageView.layer.cornerRadius = 6.0
        self.thumbnailImageView.layer.masksToBounds = true
        DispatchQueue.main.async {
            self.thumbnailImageView.image = image
        }
        selectedThumbNail = image
    }
    
    
    
     func thumbnailCount(inView: UICollectionView) -> Int {
        
        var num : Double = 0;
        
        //DispatchQueue.main.sync {
        num = Double(inView.frame.size.width) / Double(inView.frame.size.height)
        // }
        guard !(num.isNaN || num.isInfinite) else {
            return 0 // or do some error handling
        }
        
        return Int(ceil(num))
    }
    
    func updateThumbnails(view: UIView, videoURL: URL, duration: Float64) {
        
        var offset: Float64 = 0
        for view in self.thumbnailViews{
            DispatchQueue.main.sync
                {
                    view.removeFromSuperview()
            }
        }
        
        //let imagesCount = self.thumbnailCount(inView: self.collectionView)
        
        if self.duration > 10 {
            imagesCount = 10
        }else {
            imagesCount = 5
        }
        for i in 0..<imagesCount{
            let thumbnail = ABVideoHelper.thumbnailFromVideo(videoUrl: videoURL,
                                                             time: CMTimeMake(value: Int64(offset), timescale: 1))
            offset = Float64(i) * (duration / Float64(imagesCount))
            thumbnails.append(thumbnail)
        }
        coverPhoto(index: selectedImageIndex!)
        self.collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thumbnails.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VideoCropCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCropCollectionViewCell
        
        cell.coverImageView.image = self.thumbnails[indexPath.row]
        if selectedImageIndex == indexPath.row   {
            cell.coverImageView.layer.borderColor = UIColor(red: 0/255.0, green: 136/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            cell.coverImageView.layer.borderWidth = 2.0
            cell.coverImageView.layer.cornerRadius = 3.0
        }else {
            cell.coverImageView.layer.borderColor = UIColor.clear.cgColor
            cell.coverImageView.layer.borderWidth = 0.0
            cell.coverImageView.layer.cornerRadius = 0.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        selectedImageIndex = indexPath.row
        coverPhoto(index: selectedImageIndex!)
        self.collectionView.reloadData()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btnDoneClicked(_ sender: Any) {
     UserdefaultStore.USERDEFAULTS_SET_BOOL_KEY(object: true, key: "dissmisFromCropVideoView")
        let dict:[String: Any]  =  ["videoUrl":self.cropVideoUrl as Any, "thumbNailImage":self.selectedThumbNail ]
            NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "CropVideo"), object: dict)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CropVideoViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: 48, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
}

