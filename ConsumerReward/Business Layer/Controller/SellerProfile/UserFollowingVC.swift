//  Created by Navpreet on 11/07/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class UserFollowingVC: UIViewController {
    //MARK:- Variable Declaration
    var followers_list = [UserProfileFollowing]()
    var following_list = [UserProfileFollowing]()
    var user_id = ""
    var Seleted_segment = Int()
    let store = UserProfileServices.sharedInstance

    //MARK:- Outlet Connections
    @IBOutlet weak var segment_Following: HBSegmentedControl!
    @IBOutlet weak var table_Followers: UITableView!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchUsersList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    //MARK:- Custom Methods
    func initialSetup() {
        table_Followers.tableFooterView = UIView()
        table_Followers.showsVerticalScrollIndicator = false
        segment_Following.isHidden = true
        self.title = "FOLLOWERS"
        Seleted_segment = 0
    }
    func segmnetViewSetup() {
        segment_Following.items = ["FOLLOWERS (\(self.store.total_followers))","FOLLOWING (\(self.store.total_followwings))"]
        segment_Following.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 11)
        segment_Following.backgroundColor = UIColor.init(red: 17/255.0, green: 37/255.0, blue: 65/255.0, alpha: 1.0)
        segment_Following.addTarget(self, action: #selector(UserFollowingVC.segmentValueChanged(_:)), for: .valueChanged)
        segment_Following.isHidden = false
        self.segment_Following.selectedIndex = Seleted_segment
    }
    
    @objc func segmentValueChanged(_ sender: AnyObject?){
        if segment_Following.selectedIndex == 0 {
            self.title = "FOLLOWERS"
            Seleted_segment = 0
        }else if segment_Following.selectedIndex == 1{
            self.title = "FOLLOWING"
            Seleted_segment = 1
        }
        table_Followers.reloadData()
    }
    
    //MARK:- Button Methods
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Consumer_Profile(get_id: String) {
        let storyboard = UIStoryboard(name: "ConsumerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ConsumerProfileVC") as! ConsumerProfileVC
        vcObj.get_Follow_info = false
        vcObj.get_user_Follow_id = get_id
        self.navigationController?.pushViewController(vcObj, animated: false)
    }
    @objc func Seller_Profile(get_id: String) {
        
        let storyboard = UIStoryboard(name: "SellerProfile", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "BrandProfileVC") as! BrandProfileVC
        vcObj.get_brand_id = get_id
        self.navigationController?.pushViewController(vcObj, animated: false)
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension UserFollowingVC : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = Int()
        if segment_Following.selectedIndex == 0 {
            rowsCount = followers_list.count
        }else {
            rowsCount = following_list.count
        }
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var superCell = UITableViewCell()
        if segment_Following.selectedIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerFollowersCell", for: indexPath) as! SellerFollowersCell
            cell.configureCell(item: followers_list[indexPath.row])
            cell.btn_Follow.tag = indexPath.row
            cell.btn_Follow.addTarget(self, action: #selector(self.followUserTapped(sender:)), for: .touchUpInside)
            superCell = cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerFollowersCell", for: indexPath) as! SellerFollowersCell
            cell.configureCell(item: following_list[indexPath.row])
            cell.btn_Follow.tag = indexPath.row
            cell.btn_Follow.addTarget(self, action: #selector(self.followUserTapped(sender:)), for: .touchUpInside)
            superCell = cell
        }
        
        superCell.selectionStyle = .none
        return superCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment_Following.selectedIndex == 0 {
            let get_id  = followers_list[indexPath.row].port_accountid
            if followers_list[indexPath.row].reg_type == "1" {
                self.Seller_Profile(get_id: get_id)
            } else {
                self.Consumer_Profile(get_id: get_id)
            }
        }
        else {
            let get_id  = following_list[indexPath.row].port_accountid
            if following_list[indexPath.row].reg_type == "1" {
                self.Seller_Profile(get_id: get_id)
            } else {
                self.Consumer_Profile(get_id: get_id)
            }
        }
    }
    
    //MARK:- TableView Custom Methods
//    @objc func followUserTapped(sender:UIButton)
//    {
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Followers)
//        if let indexPath = self.table_Followers.indexPathForRow(at: buttonPosition) {
//            print(indexPath.row)
//            if segment_Following.selectedIndex == 0 {
//                if followers_list[indexPath.row].isFollowed == false {
//                    followers_list[indexPath.row].isFollowed = true
//                }else {
//                    followers_list[indexPath.row].isFollowed = false
//                }
//            }else {
//                if following_list[indexPath.row].isFollowed == false {
//                    following_list[indexPath.row].isFollowed = true
//                }else {
//                    following_list[indexPath.row].isFollowed = false
//                }
//            }
//
//            table_Followers.beginUpdates()
//            table_Followers.reloadRows(at: [indexPath], with: .automatic)
//            table_Followers.endUpdates()
//        }
//    }
    
    //MARK:- TableView Custom Methods
    @objc func followUserTapped(sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_Followers)
        if let indexPath = self.table_Followers.indexPathForRow(at: buttonPosition) {
            print(indexPath.row)
            if segment_Following.selectedIndex == 0 {
                let value = followers_list[indexPath.row]
                if value.isFollowed == false {
                    self.brandfollowAPI(index: indexPath.row,user_id: value.user_id)
                }else {
                    self.brandUnfollow(index: indexPath.row, user_id: value.user_id)
                }
            }else {
                let value = following_list[indexPath.row]

                if value.isFollowed == false {
                    self.brandfollowAPI(index: indexPath.row,user_id: value.user_id)

                }else {
                    self.brandUnfollow(index: indexPath.row, user_id: value.user_id)
                }
            }
//            table_Followers.beginUpdates()
//            table_Followers.reloadRows(at: [indexPath], with: .automatic)
//            table_Followers.endUpdates()
        }
    }
    func followUnFollowUIsetup(index:Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if segment_Following.selectedIndex == 0 {
            if followers_list[indexPath.row].isFollowed == false {
                followers_list[indexPath.row].isFollowed = true
            }else {
                followers_list[indexPath.row].isFollowed = false
            }
        }else {
            if following_list[indexPath.row].isFollowed == false {
                following_list[indexPath.row].isFollowed = true
            }else {
                following_list[indexPath.row].isFollowed = false
            }
        }

        table_Followers.beginUpdates()
        table_Followers.reloadRows(at: [indexPath], with: .automatic)
        table_Followers.endUpdates()
    }
}
// MARK: API CALLS
extension UserFollowingVC{
    @objc func fetchUsersList() {
        store.fetchFollowingAndFollowersList(showLoader: true, value: user_id, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            
            self.segmnetViewSetup()
            self.followers_list.removeAll()
            self.following_list.removeAll()
            
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                self.followers_list = self.store.usersFollowersList
                self.following_list = self.store.usersFollowingList
                
                //                if self.followers_list.count > 0
                //                {
                //                    self.noDataView.isHidden = true
                //                }
                //                else
                //                {
                //                    self.noDataView.isHidden = false
                //                }
                self.table_Followers.reloadData()
                //self.moveToNextView()
            }
        }) { (failure) -> Void in
            self.followers_list.removeAll()
            self.following_list.removeAll()
            //            if self.postsListArray.count > 0
            //            {
            //                self.noDataView.isHidden = true
            //            }
            //            else
            //            {
            //                self.noDataView.isHidden = false
            //            }
            // your failure handle
            if let value = failure as? [String:Any] {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: value["message"] as? String ?? "failure", btnTitle: "OK", viewController: self, completionHandler: { (success) in
                })
                return
            } else {
                AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: "", message: AlertController.AlertTitle.apiFailure.rawValue, btnTitle: "OK", viewController: self, completionHandler: { (success) in
                })
                return
            }
        }
    }
    func brandfollowAPI(index:Int,user_id:String) {
        
        store.callFollowBrandAPI(parameters: ["user_id":user_id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any] {
                print(success)
                print("success")
                // self.followUnFollowUIsetup(index: index)
                self.fetchUsersList()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
    }
    
    func brandUnfollow(index:Int,user_id:String)
    {
        store.callUnFollowBrandAPI(parameters: ["user_id":user_id], showLoader: true, outhType: "", completionBlockSuccess: { (success) -> Void in
            // your successful handle
            if let _ = success as? [String: Any]
            {
                print(success)
                print("success")
               // self.followUnFollowUIsetup(index: index)
                self.fetchUsersList()
            }
        }) { (failure) -> Void in
            self.handleAPIError(failure: failure)
        }
    }
}
