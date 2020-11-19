//  Created by apple on 19/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit
import MessageUI
import Messages

class ShareEarnVC: UIViewController {
    //MARK:- Variable Declaration
    let store = ShareEarnServices.sharedInstance
    let messageComposer = MFMessageComposeViewController()
    var img_ReferralCode = UIImage()
    //MARK:- Outlet Connections
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_ShareReferralCode: UILabel!
    @IBOutlet weak var lbl_ReferralCode: UILabel!
    @IBOutlet weak var btn_InviteFriends: UIButton!
    @IBOutlet weak var btn_checkoutLeaderboard: UIButton!
    @IBOutlet weak var lbl_DaisyMessage: UILabel!
    @IBOutlet weak var scroll_Content: UIScrollView!
    @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchShareEarnData()
        self.initialSetup()
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.clear), for: .default)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    //MARK:- Custom Methods
    func initialSetup() {
        lbl_Title.text = "SHARE • EARN • GIVE"
        lbl_ReferralCode.text = ""
        lbl_ReferralCode.textColor = UIColor(patternImage: UIImage(named: "gradientText")!)
        lbl_DaisyMessage.text = ""

        //Enable scrolling for small devices to show complete view
        if UIDevice().SCREEN_TYPE == .iPhone4 || UIDevice().SCREEN_TYPE == .iPhone5E || UIDevice().SCREEN_TYPE == .iPhone8 {
            constraint_ViewContentHeight.constant = 100
        }
    }
    @objc func setUpData () {
        lbl_Title.text = "SHARE • EARN • GIVE"
        lbl_ReferralCode.text = self.store.referralDetails?.referal_code ?? ""
        lbl_ReferralCode.textColor = UIColor(patternImage: UIImage(named: "gradientText")!)
        lbl_DaisyMessage.text = self.store.referralDetails?.content ?? ""
        if self.store.referralDetails?.referal_code_image != "" {
            DispatchQueue.global(qos: .background).async {
                do {
                    let url = URL(string: (self.store.referralDetails?.referal_code_image)!)
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.img_ReferralCode = UIImage(data: data!)!
                    }
                }
            }
        }
    }
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inviteFriendsTapped(_ sender: Any) {
        let shareText = self.store.referralDetails?.text_msg ?? ""
        let vc = UIActivityViewController(activityItems: [shareText, img_ReferralCode], applicationActivities: [])
        present(vc, animated: true, completion:  {
            //stuff stuff
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.color(.appThemeColor)), for: .default)
        })
        /*if let image = UIImage(named: "SHAREMESSAGE") {
            let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
            present(vc, animated: true, completion:  {
                //stuff stuff
                UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: UIColor.color(.appThemeColor)), for: .default)
            })
        }*/

    }
    @IBAction func checkoutLeaderboardTapped(_ sender: Any){
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LeaderboardVC") as! LeaderBoardViewController
        if self.presentingViewController != nil {
            if self.presentingViewController?.restorationIdentifier == vc.restorationIdentifier {
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        vc.isFirstController = true
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK: API CALLS
extension ShareEarnVC {
    @objc func fetchShareEarnData() {
        store.callShareCodeAPI(showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.setUpData()
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}

// MARK: SHARE CODE SOCIAL CALLS
extension ShareEarnVC : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

}
//MARK:- MFMailComposeViewControllerDelegate
extension ShareEarnVC : MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        switch result {
        case .cancelled: break
        //            AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelEmailCancelled"), time: 1.5)
        case .saved: break
        //            AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelEmailSaved"), time: 1.5)
        case .sent: break
        //            AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelEmailSent"), time: 1.5)
        case .failed: break
            //            AlertController.SHOW_AUTOHIDE_MESSAGE(controller: self, message: GET_LOCALIZED_STRING(forClass: "CommonMessages", withKey: "labelEmailError"), time: 1.5)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

