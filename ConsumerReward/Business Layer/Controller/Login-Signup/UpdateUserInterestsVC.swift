//  Created by Navpreet on 28/09/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class UpdateUserInterestsVC: UIViewController {
    //MARK:- Variable Declaration
    var array_UserInterests = [UserInterest]()
    var dict_Localized = [String:String]()
    
    //MARK:- Outlet Connections
    @IBOutlet weak var collection_UserInterests: UICollectionView!
    @IBOutlet weak var btn_Done: UIButton!
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizedText()
        self.initialSetup()
        self.perform(#selector(self.callGetUserInterests), with: self, afterDelay: 0.1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Keyboard hide Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Custom Methods
    func setLocalizedText() {
        dict_Localized = GET_LOCALIZED_STRING_DICTIONARY(forClass: "UserInterests")
    }
    func initialSetup()  {
        collection_UserInterests.register(UINib(nibName: "UserInterestCell", bundle: nil), forCellWithReuseIdentifier: "UserInterestCell")
        collection_UserInterests.isScrollEnabled = false
        collection_UserInterests.showsVerticalScrollIndicator = false
        collection_UserInterests.backgroundColor = UIColor.clear
        if let layout = collection_UserInterests.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 8
            collection_UserInterests.collectionViewLayout = layout
        }
        self.enableDisableDoneButton()
    }
    
    @objc func userInterestsValidation() {
        let filteredArray = array_UserInterests.filter({$0.isSelected == true})
        if filteredArray.count < ConfigurationManager.CharacterLength.UserInterestMinimumCategorySelection.value {
            AlertController.SHOW_ALERT_CONTROLLER_SINGLE_BUTTON(alertTitle: (dict_Localized["labelSelectCategories"]?.capitalized)!, message: dict_Localized["errorSelectCategories"]!, btnTitle: dict_Localized["labelOk"]!, viewController: self) { (success) in
            }
            return
        }
        
        var interests = [Int]()
        for item in filteredArray {
            interests.append(item.id)
        }
        let parameters:  [String: Any] = [
            "interests":interests
        ]
        self.callSaveUserInterests(parameters: parameters)
    }
    func enableDisableDoneButton() {
        let filtered = self.array_UserInterests.filter({$0.isSelected == true})
        if filtered.count > 2 {
            btn_Done.alpha = 1.0
            btn_Done.isUserInteractionEnabled = true
        }else {
            btn_Done.alpha = 0.4
            btn_Done.isUserInteractionEnabled = false
        }
    }
    //MARK:- Button Actions
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneTapped(_ sender: Any) {
        self.userInterestsValidation()
    }
}



//MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension UpdateUserInterestsVC :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_UserInterests.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.bounds.width-32)/2)-8
        return CGSize(width: width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserInterestCell", for: indexPath) as! UserInterestCell
        cell.configureCell(item: array_UserInterests[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.array_UserInterests[indexPath.item].isSelected = !self.array_UserInterests[indexPath.item].isSelected
        self.enableDisableDoneButton()
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath)
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}


//MARK:- API CALL
extension UpdateUserInterestsVC {
    @objc func callGetUserInterests() {
        let service = LoginServices()
        service.callGetUserInterestsAPI(isSocialLogin: false, socialId: "", showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
            if let dict = success["response"] as? NSDictionary {
                if let allInterest = dict["interest"] as? [NSDictionary] {
                    self.array_UserInterests.removeAll()
                    for item in allInterest {
                        let interest = UserInterest(dictionary: item)
                        self.array_UserInterests.append(interest)
                    }
                    self.collection_UserInterests.reloadData()
                    self.enableDisableDoneButton()
                }
            }
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    func callSaveUserInterests(parameters: [String:Any]) {
        let service = LoginServices()
        service.callUpdateUserInterestsAPI(parameters: parameters, showLoader: true, completionBlockSuccess: { (success) -> Void in
            // your successful handle
            print(success)
            self.dismiss(animated: true, completion: nil)
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
