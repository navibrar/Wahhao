//  Created by Navpreet on 24/11/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

enum ReferralLeaderboardSegmentValues {
    static let daily = "Daily"
    static let weekly = "Weekly"
    static let monthly = "Monthly"
    static let allTime = "All-Time"
}

class ReferralLeaderboardVC: UIViewController {
    //MARK:- Variable Declaration
    var array_Leaderboard = [Leaderboard]()
    let leaderboardService = LeaderboardServices.sharedInstance
    var testvar  = String()
    
    @IBOutlet weak var btnClose: UIButton!
    //MARK:- Outlet Connections
    @IBOutlet weak var segment_Time: HBSegmentedControl!
    @IBOutlet weak var table_Leaderboard: UITableView!
    @IBOutlet weak var lbl_PriceCenter: UILabel!
    @IBOutlet weak var lbl_PriceLeft: UILabel!
    @IBOutlet weak var lbl_PriceRight: UILabel!
    @IBOutlet weak var lbl_ReferralsCenter: UILabel!
    @IBOutlet weak var lbl_ReferralsLeft: UILabel!
    @IBOutlet weak var lbl_ReferralsRight: UILabel!
    @IBOutlet weak var img_TopUserLeft: UIImageView!
    @IBOutlet weak var img_TopUserCenter: UIImageView!
    @IBOutlet weak var img_TopUserRight: UIImageView!
    @IBOutlet weak var btn_ReferFriends: UIButton!
    @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var view_TopFirstFan: UIView!
    @IBOutlet weak var view_TopSecondFan: UIView!
    @IBOutlet weak var view_TopThirdFan: UIView!
    @IBOutlet weak var view_TableHeader: UIView!
    @IBOutlet weak var constraint_ReferBtnBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var lbl_DataRefreshed: UILabel!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.initialSetup()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.callFetchLeaderboardFans()
        }
        //SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        segment_Time.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        segment_Time.addGestureRecognizer(swipeRight)
        // image corner radius
      
        self.img_TopUserCenter.layer.cornerRadius = 6.0
        self.img_TopUserCenter.layer.masksToBounds = true
        
        self.img_TopUserLeft.layer.cornerRadius = 6.0
        self.img_TopUserLeft.layer.masksToBounds = true
        
        self.img_TopUserRight.layer.cornerRadius = 6.0
        self.img_TopUserRight.layer.masksToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        self.btnClose.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- CloseButtonHidden
    
    func hideCloseBtn(isHidden : Bool)   {
        guard let btn  = self.btnClose else {
            return
        }
        if  isHidden == true {
            btn.isHidden = true
        }else {
             btn.isHidden = false
        }
    }

    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("move Left")
                self.stopTableViewFromScrolling()
                if segment_Time.selectedIndex == 3 {
                    segment_Time.selectedIndex = 2
                    self.setupMonthlyFansData()
                }else if segment_Time.selectedIndex == 2 {
                    segment_Time.selectedIndex = 1
                    self.setupWeeklyFansData()
                }else if segment_Time.selectedIndex == 1 {
                    segment_Time.selectedIndex = 0
                    self.setupDailyFansData()
                }
            case UISwipeGestureRecognizer.Direction.right:
                self.stopTableViewFromScrolling()
                print("move Right")
                if segment_Time.selectedIndex == 0 {
                    segment_Time.selectedIndex = 1
                   self.setupWeeklyFansData()
                }else if segment_Time.selectedIndex == 1 {
                    segment_Time.selectedIndex = 2
                    self.setupMonthlyFansData()
                }else if segment_Time.selectedIndex == 2 {
                    segment_Time.selectedIndex = 3
                    self.setupAllTimeFansData()
                }
            default:
                break
            }
        }
    }
    //MARK:- Custom Methods
    func setLocalizedText() {
    }
    func initialSetup() {
        self.lbl_DataRefreshed.text = ""
        self.hideAllTopFans()
        leaderboardService.array_TopDailyFans.removeAll()
        leaderboardService.array_TopWeeklyFans.removeAll()
        leaderboardService.array_TopMonthlyFans.removeAll()
        leaderboardService.array_TopAllTimeFans.removeAll()
        
        //view_TableHeader.isHidden = true
        //Segment Values
        segment_Time.items = [ReferralLeaderboardSegmentValues.daily.uppercased(), ReferralLeaderboardSegmentValues.weekly.uppercased(), ReferralLeaderboardSegmentValues.monthly.uppercased(), ReferralLeaderboardSegmentValues.allTime.uppercased()]
        segment_Time.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 11)
        segment_Time.borderColor = .white
        segment_Time.addTarget(self, action: #selector(ReferralLeaderboardVC.segmentValueChanged(_:)), for: .valueChanged)
        leaderboardService.array_TopDailyFans.removeAll()
        leaderboardService.array_TopWeeklyFans.removeAll()
        leaderboardService.array_TopMonthlyFans.removeAll()
        leaderboardService.array_TopAllTimeFans.removeAll()
        table_Leaderboard.tableFooterView = UIView()
        btn_ReferFriends.roundCorners([.bottomLeft, .bottomRight], radius: 6, width: self.view.bounds.width-32)
    }
    @objc func segmentValueChanged(_ sender: AnyObject?){
        self.stopTableViewFromScrolling()
        if segment_Time.selectedIndex == 0 {
            self.setupDailyFansData()
        }else if segment_Time.selectedIndex == 1 {
            self.setupWeeklyFansData()
        }else if segment_Time.selectedIndex == 2 {
            self.setupMonthlyFansData()
        }else if segment_Time.selectedIndex == 3 {
            self.setupAllTimeFansData()
        }
    }
    func setupDailyFansData() {
        if leaderboardService.array_TopDailyFans.count == 0 {
            let type = ReferralLeaderboardSegmentValues.daily
            self.callFetchLeaderboardFans(type)
        }else {
            self.setUpData()
        }
    }
    func setupWeeklyFansData() {
        if leaderboardService.array_TopWeeklyFans.count == 0 {
            let type = ReferralLeaderboardSegmentValues.weekly
            self.callFetchLeaderboardFans(type)
        }else {
            self.setUpData()
        }
    }
    func setupMonthlyFansData() {
        if leaderboardService.array_TopMonthlyFans.count == 0 {
            let type = ReferralLeaderboardSegmentValues.monthly
            self.callFetchLeaderboardFans(type)
        }else {
            self.setUpData()
        }
    }
    func setupAllTimeFansData() {
        if leaderboardService.array_TopAllTimeFans.count == 0 {
            let type = ReferralLeaderboardSegmentValues.allTime
            self.callFetchLeaderboardFans(type)
        }else {
            self.setUpData()
        }
    }
    func setDataRefreshedTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let dateStr = formatter.string(from: Date())
        lbl_DataRefreshed.text = "LAST REFRESHED \(dateStr).\nUPDATES SUNDAY AT 12 AM EST"
    }
    func setUpData() {
        array_Leaderboard.removeAll()
        self.hideAllTopFans()
        let indexPath = IndexPath(row: 0, section: 0)
        if self.table_Leaderboard.cellForRow(at: indexPath) != nil {
            let cell : LeaderboardHeaderCell = self.table_Leaderboard.cellForRow(at: indexPath) as! LeaderboardHeaderCell
            cell.headerView.isHidden = true
        }
        //view_TableHeader.isHidden = true
        if segment_Time.selectedIndex == 0 {
            if leaderboardService.array_TopDailyFans.count > 0 {
                if leaderboardService.array_TopDailyFans.count == 1 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopDailyFans[0])
                    self.unhideFirstTopFan()
                }else if leaderboardService.array_TopDailyFans.count == 2 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopDailyFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopDailyFans[1])
                    self.unhideTwoTopFans()
                }else if leaderboardService.array_TopDailyFans.count >= 3 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopDailyFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopDailyFans[1])
                    self.setTopThirdFanValue(data: leaderboardService.array_TopDailyFans[2])
                    self.unhideAllTopFans()
                    if leaderboardService.array_TopDailyFans.count > 3 {
                        let indexPath = IndexPath(row: 0, section: 0)
                        if self.table_Leaderboard.cellForRow(at: indexPath) != nil {
                            let cell : LeaderboardHeaderCell = self.table_Leaderboard.cellForRow(at: indexPath) as! LeaderboardHeaderCell
                            cell.headerView.isHidden = false
                        }
                        
                       // view_TableHeader.isHidden = false
                        let value = Array(leaderboardService.array_TopDailyFans.suffix(leaderboardService.array_TopDailyFans.count-3))
                        self.array_Leaderboard = value
                    }
                }
            }
        }else if segment_Time.selectedIndex == 1 {
            if leaderboardService.array_TopWeeklyFans.count > 0 {
                if leaderboardService.array_TopWeeklyFans.count == 1 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopWeeklyFans[0])
                    self.unhideFirstTopFan()
                }else if leaderboardService.array_TopWeeklyFans.count == 2 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopWeeklyFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopWeeklyFans[1])
                    self.unhideTwoTopFans()
                }else if leaderboardService.array_TopWeeklyFans.count >= 3 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopWeeklyFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopWeeklyFans[1])
                    self.setTopThirdFanValue(data: leaderboardService.array_TopWeeklyFans[2])
                    self.unhideAllTopFans()
                    if leaderboardService.array_TopWeeklyFans.count > 3 {
                       // view_TableHeader.isHidden = false
                        let indexPath = IndexPath(row: 0, section: 0)
                        if self.table_Leaderboard.cellForRow(at: indexPath) != nil {
                            let cell : LeaderboardHeaderCell = self.table_Leaderboard.cellForRow(at: indexPath) as! LeaderboardHeaderCell
                            cell.headerView.isHidden = false
                        }
                        let value = Array(leaderboardService.array_TopWeeklyFans.suffix(leaderboardService.array_TopWeeklyFans.count-3))
                        self.array_Leaderboard = value
                    }
                }
            }
        }else if segment_Time.selectedIndex == 2 {
            if leaderboardService.array_TopMonthlyFans.count > 0 {
                if leaderboardService.array_TopMonthlyFans.count == 1 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopMonthlyFans[0])
                    self.unhideFirstTopFan()
                }else if leaderboardService.array_TopMonthlyFans.count == 2 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopMonthlyFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopMonthlyFans[1])
                    self.unhideTwoTopFans()
                }else if leaderboardService.array_TopMonthlyFans.count >= 3 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopMonthlyFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopMonthlyFans[1])
                    self.setTopThirdFanValue(data: leaderboardService.array_TopMonthlyFans[2])
                    self.unhideAllTopFans()
                    if leaderboardService.array_TopMonthlyFans.count > 3 {
                       // view_TableHeader.isHidden = false
                        let indexPath = IndexPath(row: 0, section: 0)
                        if self.table_Leaderboard.cellForRow(at: indexPath) != nil {
                            let cell : LeaderboardHeaderCell = self.table_Leaderboard.cellForRow(at: indexPath) as! LeaderboardHeaderCell
                            cell.headerView.isHidden = false
                        }
                        
                        let value = Array(leaderboardService.array_TopMonthlyFans.suffix(leaderboardService.array_TopMonthlyFans.count-3))
                        self.array_Leaderboard = value
                    }
                }
            }
        }else if segment_Time.selectedIndex == 3 {
            if leaderboardService.array_TopAllTimeFans.count > 0 {
                if leaderboardService.array_TopAllTimeFans.count == 1 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopAllTimeFans[0])
                    self.unhideFirstTopFan()
                }else if leaderboardService.array_TopAllTimeFans.count == 2 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopAllTimeFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopAllTimeFans[1])
                    self.unhideTwoTopFans()
                }else if leaderboardService.array_TopAllTimeFans.count >= 3 {
                    self.setTopFirstFanValue(data: leaderboardService.array_TopAllTimeFans[0])
                    self.setTopSecondFanValue(data: leaderboardService.array_TopAllTimeFans[1])
                    self.setTopThirdFanValue(data: leaderboardService.array_TopAllTimeFans[2])
                    self.unhideAllTopFans()
                    if leaderboardService.array_TopAllTimeFans.count > 3 {
                       // view_TableHeader.isHidden = false
                        let indexPath = IndexPath(row: 0, section: 0)
                        if self.table_Leaderboard.cellForRow(at: indexPath) != nil {
                            let cell : LeaderboardHeaderCell = self.table_Leaderboard.cellForRow(at: indexPath) as! LeaderboardHeaderCell
                            cell.headerView.isHidden = false
                        }
                        
                        let value = Array(leaderboardService.array_TopAllTimeFans.suffix(leaderboardService.array_TopAllTimeFans.count-3))
                        self.array_Leaderboard = value
                    }
                }
            }
        }
        table_Leaderboard.reloadData()
        self.setDataRefreshedTime()
    }
    func hideAllTopFans() {
        view_TopFirstFan.isHidden = true
        view_TopSecondFan.isHidden = true
        view_TopThirdFan.isHidden = true
    }
    func unhideFirstTopFan() {
        view_TopFirstFan.isHidden = false
        view_TopSecondFan.isHidden = true
        view_TopThirdFan.isHidden = true
    }
    func unhideTwoTopFans() {
        view_TopFirstFan.isHidden = false
        view_TopSecondFan.isHidden = false
        view_TopThirdFan.isHidden = true
    }
    func unhideAllTopFans() {
        view_TopFirstFan.isHidden = false
        view_TopSecondFan.isHidden = false
        view_TopThirdFan.isHidden = false
    }
    func setTopFirstFanValue(data: Leaderboard) {
        self.img_TopUserCenter.image = UIImage(named:Constants.USER_DUMMY_IMAGE)
        self.img_TopUserCenter.layer.cornerRadius = 6.0
        self.img_TopUserCenter.layer.masksToBounds = true
        if data.profile_image != "" {
            let url = URL(string: data.profile_image)
            self.img_TopUserCenter.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        lbl_ReferralsCenter.text = "\(data.referrals) REFERRALS"
        let cashReward = "$ \(data.cash)"
        lbl_PriceCenter.attributedText =  createSuperscriptText(text: cashReward, location: 0, length: 1, baseLineOffset: 6)
    }
    func setTopSecondFanValue(data: Leaderboard) {
        self.img_TopUserLeft.image = UIImage(named:Constants.USER_DUMMY_IMAGE)
        if data.profile_image != "" {
            let url = URL(string: data.profile_image)
            self.img_TopUserLeft.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        lbl_ReferralsLeft.text = "\(data.referrals) REFERRALS"
        let cashReward = "$ \(data.cash)"
        lbl_PriceLeft.attributedText =  createSuperscriptText(text: cashReward, location: 0, length: 1, baseLineOffset: 6)
    }
    func setTopThirdFanValue(data: Leaderboard) {
        self.img_TopUserRight.image = UIImage(named:Constants.USER_DUMMY_IMAGE)
        if data.profile_image != "" {
            let url = URL(string: data.profile_image)
            self.img_TopUserRight.kf.setImage(with: url, placeholder: UIImage(named:Constants.USER_DUMMY_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
        }
        lbl_ReferralsRight.text = "\(data.referrals) REFERRALS"
        let cashReward = "$ \(data.cash)"
        lbl_PriceRight.attributedText =  createSuperscriptText(text: cashReward, location: 0, length: 1, baseLineOffset: 6)
    }
    func createSuperscriptText(text:String, location: Int, length: Int, baseLineOffset: Int) -> NSMutableAttributedString {
        let font:UIFont? = UIFont(name: Constants.SEMI_BOLD_FONT, size:21)
        let fontSuperScriptText:UIFont? = UIFont(name: Constants.SEMI_BOLD_FONT, size:11)
        
        let attributedStr:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font:font!])
        attributedStr.setAttributes([.font:fontSuperScriptText!,.baselineOffset:baseLineOffset], range: NSRange(location:location,length:length))
        return attributedStr
    }
    func stopTableViewFromScrolling() {
        if self.table_Leaderboard.contentOffset != .zero {
            self.table_Leaderboard.setContentOffset(.zero, animated: false)
        }
    }
    //MARK:- Button Methods
    @IBAction func inviteFriendsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ShareEarnVC") as! ShareEarnVC
        if self.presentingViewController != nil {
            if self.presentingViewController?.restorationIdentifier == vcObj.restorationIdentifier {
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.present(vcObj, animated: true, completion: nil)
    }
    @IBAction func closeViewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension ReferralLeaderboardVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
              return array_Leaderboard.count
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! LeaderboardHeaderCell
            
            cell.selectionStyle = .none
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
            if array_Leaderboard.count > 0 {
                cell.configureCell(item: array_Leaderboard[indexPath.item])
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 38
        }else {
            return 70
        }
    }
}

//MARK:- API METHODS

extension ReferralLeaderboardVC {
    @objc func callFetchLeaderboardFans( _ type: String = ReferralLeaderboardSegmentValues.daily) {
        leaderboardService.callGetLeaderboardFansAPI(type: type, showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            print(response)
            self.setUpData()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
