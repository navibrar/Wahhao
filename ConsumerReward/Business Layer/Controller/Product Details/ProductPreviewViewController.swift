//
//  ProductPreviewViewController.swift
//  ConsumerReward
//
//  Created by apple on 1/2/19.
//  Copyright © 2019 Navpreet. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVKit
import QuartzCore
import CoreMedia
import Kingfisher

class ProductPreviewViewController: UIViewController {
    
    //HOME FEED OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedCell : HomePostCollectionViewCell? = nil

    var productImagesArray = [ProductImages]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.bounces = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.isHidden = true
        
        //SWIPE GESTURES
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.isNavigationBarHidden = false
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at:IndexPath(item: selectedIndex, section: 0), at: .right, animated: false)
        self.collectionView.isHidden = false
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.goBack()
            case UISwipeGestureRecognizer.Direction.up:
                print("move up")
            default:
                break
            }
        }
    }
    func goBack() {
        self.pauseVideo()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        //print("Video Finished")
        if selectedCell != nil{
            selectedCell?.play_icon_imageview.isHidden = false
            selectedCell?.avPlayer.pause()
            selectedCell?.avPlayer.seek(to: CMTime.zero)
        }
    }
        
    func pauseVideo()
    {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count <= 0 {
            return
        }
        let getindex = indexPathItem[0].item
        let indexPath = IndexPath(row: getindex, section: 0)
        let value = self.productImagesArray[indexPath.row]
        if value.media_type == "video"
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell {
                if(cell.avPlayer.timeControlStatus == AVPlayer.TimeControlStatus.playing)
                {
                    cell.play_icon_imageview.isHidden = false
                    cell.avPlayer.pause()
                }
            }
        }
    }
    
    func playVideo()
    {
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count <= 0 {
            return
        }

        let getindex = indexPathItem[0].item
        let indexPath = IndexPath(row: getindex, section: 0)
        let value = self.productImagesArray[indexPath.row]
        if value.media_type == "video"
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            {
                if(cell.avPlayer.timeControlStatus==AVPlayer.TimeControlStatus.paused)
                {
                    cell.play_icon_imageview.isHidden = true
                    cell.avPlayer.play()
                }
            }
        }
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.goBack()
    }
    
    @objc func handleSingleTap() {
        print("Single Tap!")
        //print("Tap here for Pause & Play")
        let indexPathItem = collectionView.indexPathsForVisibleItems
        if indexPathItem.count <= 0 {
            return
        }
        
        let getindex = indexPathItem[0].item
        let indexPath = IndexPath(row: getindex, section: 0)
        let value = self.productImagesArray[indexPath.row]
        if value.media_type == "video"
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? HomePostCollectionViewCell
            {
                if(cell.avPlayer.timeControlStatus == AVPlayer.TimeControlStatus.playing)
                {
                    self.pauseVideo()
                }
                else if(cell.avPlayer.timeControlStatus==AVPlayer.TimeControlStatus.paused)
                {
                    self.playVideo()
                }
            }
        }
    }
}

//MARK:- CollectionView Delegate and DataSource
extension ProductPreviewViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    //MARK:-
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("after end",indexPath.item)
        (cell as? HomePostCollectionViewCell)?.avPlayer.pause()
        (cell as? HomePostCollectionViewCell)?.avPlayerLayer.removeFromSuperlayer()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell =  (cell as? HomePostCollectionViewCell)
        {
            let value = self.productImagesArray[indexPath.row]
            if value.media_type == "video"
            {
                let videoURL = URL(string: value.media_url)!
                cell.avPlayer = AVPlayer(url: videoURL)
                cell.avPlayer.actionAtItemEnd = .none
                cell.avPlayerLayer = AVPlayerLayer(player: cell.avPlayer)
                cell.avPlayerLayer.frame = cell.bounds
                cell.cellView.layer.insertSublayer(cell.avPlayerLayer, at: 0)
                
                if CGFloat(value.resolutionHeight ) > self.view.bounds.height-200 {
                    if CGFloat(value.resolutionWidth ) > CGFloat(value.resolutionHeight ) {
                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                    }else {
                        cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    }
                }else {
                    cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                }
                
                // When you need to update the UI, switch back out to the main thread
                DispatchQueue.main.async {
                    // Main thread
                    // Do your UI updates here
                    
                    let item = AVPlayerItem(url: videoURL)
                    cell.avPlayer.replaceCurrentItem(with: item)
                    cell.cellView.isHidden = false
                    cell.avPlayer.play()
                    
                    self.preriodicTimeObsever(cell : cell)
                    NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.avPlayer.currentItem)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedCell != nil{
            selectedCell?.avPlayer.pause()
        }
        //print("before end",indexPath.row)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCollectionViewCell", for: indexPath) as? HomePostCollectionViewCell
        {
            DispatchQueue.main.async {
                cell.layoutIfNeeded()
                let value = self.productImagesArray[indexPath.row]
                let imageName = value.Thumbnail
                
                //POST CONTENT SETUP MEDIA
                cell.itemImageView.isHidden = false
                cell.cellView.isHidden = true
                cell.play_icon_imageview.isHidden = true
                cell.itemImageView.image =  nil
                cell.itemImageView.backgroundColor = UIColor.black

                if imageName != ""
                {
                    let url = URL(string: imageName)
                    cell.itemImageView.kf.setImage(with: url, placeholder: UIImage(named:Constants.BACKGROUND_THEME_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
                }
                
                if CGFloat(value.resolutionHeight ) > self.view.bounds.height-200 {
                    if CGFloat(value.resolutionWidth ) > CGFloat(value.resolutionHeight ) {
                        cell.itemImageView.contentMode = .scaleAspectFit
                    }else {
                        cell.itemImageView.contentMode = .scaleAspectFill
                    }
                }else {
                    cell.itemImageView.contentMode = .scaleAspectFit
                }

                
//                if value.media_type == "video"
//                {
//                    let videoURL = URL(string: value.media_url)!
//                    cell.avPlayer = AVPlayer(url: videoURL)
////                    let resolution = self.resolutionForLocalVideo(url: videoURL)
//                    DispatchQueue.main.async {
////                        if CGFloat(resolution?.height ?? 0) > self.view.bounds.height-200 {
////                            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
////                            cell.itemImageView.contentMode = .scaleAspectFill
////                        }else {
//                            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                            cell.itemImageView.contentMode = .scaleAspectFit
////                        }
//                    }
//                    cell.avPlayer.actionAtItemEnd = .none
//                    cell.avPlayerLayer = AVPlayerLayer(player: cell.avPlayer);
//                    cell.avPlayerLayer.frame = cell.bounds
//                    cell.avPlayer.play()
//                    cell.cellView.layer.addSublayer(cell.avPlayerLayer)
//                    cell.cellView.isHidden = false
//
//                    self.preriodicTimeObsever(cell : cell)
//                    NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.avPlayer.currentItem)
//                }
                self.selectedCell = cell
                
                cell.tapDetectionView.isUserInteractionEnabled = true
                // Single Tap
                let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
                singleTap.numberOfTapsRequired = 1
                singleTap.cancelsTouchesInView = false
                cell.tapDetectionView.addGestureRecognizer(singleTap)
            }
            return cell
        }
        return HomePostCollectionViewCell()
    }
    

    func preriodicTimeObsever(cell : HomePostCollectionViewCell){
        if cell.observer != nil {
            //removing time obse
            cell.observer = nil
            //            observer = nil
        }

        let intervel : CMTime = CMTimeMake(value: 1, timescale: 1)
        cell.observer = cell.avPlayer.addPeriodicTimeObserver(forInterval: intervel, queue: DispatchQueue.main) { [weak self] time in
            guard let strongSelf = self else {return}
            //            let sliderValue : Float64 = CMTimeGetSeconds(time)

            let indexPath = strongSelf.collectionView.indexPathsForVisibleItems
            //this is the slider value update if you are using UISlider.
            let playbackLikelyToKeepUp = cell.avPlayer.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                //                strongSelf.showIndicator()
                //Here start the activity indicator inorder to show buffering
            }else{
                //                strongSelf.hideIndicator()
                //stop the activity indicator
            }
        }
    }
}
