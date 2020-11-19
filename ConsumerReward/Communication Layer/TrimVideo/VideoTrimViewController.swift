//
//  VideoTrimViewController.swift
//  VideoCropTrimmer
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoTrimViewController: UIViewController, ABVideoRangeSliderDelegate,ThumbnailImageLoadDelegate  {
    
    var alphaView  = UIView()
    @IBOutlet weak var btnPlay: UIButton!
    var oldXPos : CGFloat = 0
     var imgViewAlphaFrame : CGFloat = 0
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var abVideoRangerSlider: ABVideoRangeSlider!
    //Notification Name
    let IMAGE_LOAD_NOTIFICATION_NAME = Notification.Name("Privacy Permission")
    
    var thumbnailImageview  = [UIImageView]()
    var startTimer = Float64()
    var endTimer = Float64()
    var player = AVPlayer()
    var item : AVPlayerItem?
    var trimVideoUrl : URL?
    var videoURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoRangeSliderSetup()
        setUpPlayer()
        self.sliderView.layer.cornerRadius = 4.0
        self.sliderView.layer.masksToBounds = true
        
        
        
        // Do any additional setup after loading the view.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserdefaultStore.USERDEFAULTS_GET_BOOL_KEY(key: "dissmisFromCropVideoView"){
            UserdefaultStore.USERDEFAULTS_SET_BOOL_KEY(object: false, key: "dissmisFromCropVideoView")
            dismiss(animated: true, completion: nil)
        }
        print(globalThumnailImageViewArray.count)
      
        
        
    }
    
    func setUpPlayer() {
        self.videoView.frame = self.view.frame
        if videoURL != nil {
             item = AVPlayerItem(url: videoURL!)
           
            player = AVPlayer(playerItem: item)
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

            let playerLayer = AVPlayerLayer(player: player)
            
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoView.layer.addSublayer(playerLayer)
        }
        
        //player.play()
    }
    
   @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        btnPlay.isHidden = false
    }
    
    
    
    @IBAction func play(_ sender: Any) {
        print(startTimer)
        print(endTimer)
        btnPlay.isHidden = true
        
        if startTimer != endTimer {
           
            player.seek(to: CMTime(seconds: startTimer, preferredTimescale: CMTimeScale(60.0))) // add time what you want to start from
            item!.forwardPlaybackEndTime = CMTime(seconds: endTimer, preferredTimescale: 60) // add preferred end time
            
        }
        
        player.play()
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        NOTIFICATIONCENTER.post(name: Notification.Name(rawValue: "removeMedia"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        
        cropVideo(sourceURL: videoURL!, startTime: startTimer, endTime: endTimer) { (trimVideoUrl) in
            //print(trimVideoUrl)
            self.trimVideoUrl = trimVideoUrl
        }
    }
    //MARK:- ThumbnailImageLoadDelegate
    func checkThumbnailImageLoad() {
         self.changeTheAlphaForImageViewOnStart(frame: self.abVideoRangerSlider.draggableView.frame)
    }
    
    //MARK:- ABVideoRangeViewIntitalSetup
    
    func videoRangeSliderSetup() {
        // Set the video URL
        // let urlPath = Bundle.main.url(forResource: "Video5", withExtension:"mp4")
        let asset = AVAsset(url:videoURL! )
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")
        abVideoRangerSlider.setVideoURL(videoURL: videoURL!)
        abVideoRangerSlider.startTimeView.isHidden = true
        abVideoRangerSlider.endTimeView.isHidden = true
        // Set the delegate
        abVideoRangerSlider.delegate = self
        abVideoRangerSlider.thumbnailsManager.thumbnailDelegate = self
        
        // Set a minimun space (in seconds) between the Start indicator and End indicator
        abVideoRangerSlider.minSpace = 1.0
        // Set a maximun space (in seconds) between the Start indicator and End indicator - Default is 0 (no max limit)
        abVideoRangerSlider.maxSpace = 20.0
        // Set initial position of Start Indicator
        abVideoRangerSlider.setStartPosition(seconds: 0.0)
        // Set initial position of End Indicator
        if length > 20 {
            abVideoRangerSlider.setEndPosition(seconds: 20.0)
            
        }
        else {
            abVideoRangerSlider.setEndPosition(seconds: length)
        }
        
        
        
    }
    
    //MARK:- ABVideoRangeSliderDelegateMethod
    
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        startTimer = startTime
        endTimer = endTime
        
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        
        
        changeTheAlphaForImageView(frame: videoRangeSlider.draggableView.frame)
        
        
    }
     func changeTheAlphaForImageViewOnStart(frame : CGRect){
          for imgView in globalThumnailImageViewArray {
            DispatchQueue.main.async {
                imgView.alpha = 0.25
            }
          if (imgView.frame.origin.x + imgView.frame.size.width  < frame.size.width)  {
                DispatchQueue.main.async {
                    imgView.alpha = 1.0
                }
            }else  {
                
               
            }
            
        }
        
    }
    
    func changeTheAlphaForImageView(frame : CGRect ){
        
//        let backView = UIView()
//        backView.frame = CGRect(x: 0, y: 0, width: frame.origin.x, height: frame.size.height)
//        backView.alpha = 0.25
//        abVideoRangerSlider.addSubview(backView)
//        abVideoRangerSlider.bringSubview(toFront: backView)
//
//
//        let nextView = UIView()
//        nextView.frame = CGRect(x: frame.size.width, y: 0, width: abVideoRangerSlider.frame.size.width, height: frame.size.height)
//        nextView.alpha = 0.25
//        abVideoRangerSlider.addSubview(nextView)
//        abVideoRangerSlider.bringSubview(toFront: backView)
//
//       abVideoRangerSlider.draggableView.alpha = 1.0 
        
       
       for imgView in globalThumnailImageViewArray {

        DispatchQueue.main.async {
          imgView.alpha = 0.25
        }

            let xPos = frame.origin.x
            if oldXPos == 0 {
                oldXPos = xPos
            }
            else if oldXPos < xPos {
              imgViewAlphaFrame = imgView.frame.size.width/4

            }else {
                  imgViewAlphaFrame = imgView.frame.size.width/1.5
            }


            if (imgView.frame.origin.x + imgViewAlphaFrame  < frame.origin.x) || (imgView.frame.origin.x + imgViewAlphaFrame  > frame.origin.x + frame.size.width) {

            }else  {

                DispatchQueue.main.async {
                    imgView.alpha = 1.0
                }
            }
            oldXPos = xPos
        }
        
    }
    
    //MARK:- cropVideo
    
    func cropVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: ((_ outputUrl: URL) -> Void)? = nil)
    {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let asset = AVAsset(url: sourceURL)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")
        
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(sourceURL.lastPathComponent)")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        try? fileManager.removeItem(at: outputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                    end: CMTime(seconds: endTime, preferredTimescale: 1000))
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                completion?(outputURL)
                DispatchQueue.main.async {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Reviews", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CropVideoVC") as! CropVideoViewController
                    nextViewController.cropVideoUrl = outputURL
                    
                    self.present(nextViewController, animated: true, completion: nil)
                }
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
            default: break
            }
        }
    }
}

