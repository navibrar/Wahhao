//  Created by Navpreet on 24/11/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

enum TopVideosSegmentValues {
    static let cashBack = "CASH BACK"
    static let unitsSold = "UNITS SOLD"
    static let mostLiked = "MOST LIKED"
}

class ReviewerLeaderboardVC: UIViewController {
    //MARK:- Variable Declaration
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    let leaderboardService = LeaderboardServices.sharedInstance
    
    //MARK:- Outlet Connections
    @IBOutlet weak var segment_Time: HBSegmentedControl!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var collection_Posts: UICollectionView!
    @IBOutlet weak var constraint_ViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_DataRefreshed: UILabel!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.callFetchTopCashbackEarnedPosts()
        }
        //SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        segment_Time.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        segment_Time.addGestureRecognizer(swipeRight)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("move Left")
                self.stopCollectionViewFromScrolling()
                if segment_Time.selectedIndex == 2 {
                    segment_Time.selectedIndex = 1
                    //self.setupMostSoldProductsData()
                }else if segment_Time.selectedIndex == 1 {
                    segment_Time.selectedIndex = 0
                    //self.setupTopCasbackPostData()
                }
            case UISwipeGestureRecognizer.Direction.right:
                print("move Right")
                self.stopCollectionViewFromScrolling()
                if segment_Time.selectedIndex == 0 {
                    segment_Time.selectedIndex = 1
                    //self.setupMostSoldProductsData()
                }else if segment_Time.selectedIndex == 1 {
                    segment_Time.selectedIndex = 2
                    //self.setupMostLikedPostsData()
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
        //Segment Values
        segment_Time.items = [TopVideosSegmentValues.cashBack, TopVideosSegmentValues.unitsSold, TopVideosSegmentValues.mostLiked]
        segment_Time.font = UIFont(name: Constants.SEMI_BOLD_FONT, size: 11)
        segment_Time.borderColor = .white
        segment_Time.addTarget(self, action: #selector(ReviewerLeaderboardVC.segmentValueChanged(_:)), for: .valueChanged)
        
        leaderboardService.array_TopCashbackPost.removeAll()
        leaderboardService.array_MostSoldProducts.removeAll()
        leaderboardService.array_MostLikedPost.removeAll()
        collection_Posts.register(UINib(nibName: "TopVideosCell", bundle: nil), forCellWithReuseIdentifier: "TopVideosCell")
        collection_Posts.register(UINib(nibName: "UnitsSoldCell", bundle: nil), forCellWithReuseIdentifier: "UnitsSoldCell")
        
        collection_Posts.showsVerticalScrollIndicator = false
        collection_Posts.backgroundColor = UIColor.clear
        if let layout = collection_Posts.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 0
            collection_Posts.collectionViewLayout = layout
        }
        let labelHeight: CGFloat = 32
        let collectionWidth: CGFloat = self.view.bounds.width-56
        let cellSpacing: CGFloat = 16//Total space between three cells
        cellWidth = (collectionWidth-cellSpacing)/3//To display three cell in a row
        
        cellHeight = cellWidth + labelHeight
    }
    @objc func segmentValueChanged(_ sender: AnyObject?){
        self.stopCollectionViewFromScrolling()
        if segment_Time.selectedIndex == 0 {
            if leaderboardService.array_TopCashbackPost.count == 0 {
                self.callFetchTopCashbackEarnedPosts()
            }else {
                setupTopCasbackPostData()
            }
        }else if segment_Time.selectedIndex == 1{
            if leaderboardService.array_MostSoldProducts.count == 0 {
                self.callFetchMostSoldProducts()
            }else {
                setupMostSoldProductsData()
            }
        }else if segment_Time.selectedIndex == 2{
            if leaderboardService.array_MostLikedPost.count == 0 {
                self.callFetchMostLikedPosts()
            }else {
                setupMostLikedPostsData()
            }
        }
    }
    func setupTopCasbackPostData() {
        lbl_Description.text = "Make a video review about your purchase.\n Earn cashback everytime someone buys.\n Real reviews from real people. It's that simple."
        collection_Posts.reloadData()
    }
    func setupMostSoldProductsData() {
        lbl_Description.text = "Woah. These top selling products are awesome.\n Have fun shopping these videos.\n Good things should be shared!"
        collection_Posts.reloadData()
    }
    func setupMostLikedPostsData() {
        lbl_Description.text = "Our most liked videos ever.\n Have fun shopping these videos.\n Good things should be shared!"
        collection_Posts.reloadData()
    }
    func moveToProductDetail(item: UnitsSold) {
        let dict: NSDictionary = ["product_id": item.product_id, "variant_id": item.variant_id]
        let product = Product(dictionary: dict)
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vc.product = product
        vc.isShowCartButtons = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func moveToTopCashbackPostDetail(posts: [HomePost], index: Int) {
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = posts
        vc.selectedIndex = index
        vc.callback = { posts in
            self.leaderboardService.array_TopCashbackPost.removeAll()
            self.leaderboardService.array_TopCashbackPost = posts
            self.collection_Posts.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    func moveToTopLikedPostDetail(posts: [HomePost], index: Int) {
        let storyboard = UIStoryboard.init(name: "ProjectStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.passedListArray = posts
        vc.selectedIndex = index
        vc.callback = { posts in
            self.leaderboardService.array_MostLikedPost.removeAll()
            self.leaderboardService.array_MostLikedPost = posts
            self.collection_Posts.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    func stopCollectionViewFromScrolling() {
        if self.collection_Posts.contentOffset != .zero {
            self.collection_Posts.setContentOffset(.zero, animated: false)
        }
    }
    //MARK:- Button Methods
    @IBAction func closeViewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- CollectionView Delegate and DataSource
extension ReviewerLeaderboardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.segment_Time.selectedIndex == 0 {
            return leaderboardService.array_TopCashbackPost.count
        }else if self.segment_Time.selectedIndex == 1 {
            return leaderboardService.array_MostSoldProducts.count
        }else {
            return leaderboardService.array_MostLikedPost.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var superCell = UICollectionViewCell()
        if self.segment_Time.selectedIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopVideosCell", for: indexPath) as! TopVideosCell
            if leaderboardService.array_TopCashbackPost.count > 0 {
                cell.configureCell(cellWidth: cellWidth, item: leaderboardService.array_TopCashbackPost[indexPath.item], isCashbackPost: true)
            }
            superCell = cell
        }else if self.segment_Time.selectedIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnitsSoldCell", for: indexPath) as! UnitsSoldCell
            if leaderboardService.array_MostSoldProducts.count > 0 {
                cell.configureCell(cellWidth: cellWidth, item: leaderboardService.array_MostSoldProducts[indexPath.item])
            }
            superCell = cell
        }else if self.segment_Time.selectedIndex == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopVideosCell", for: indexPath) as! TopVideosCell
            if leaderboardService.array_MostLikedPost.count > 0 {
                cell.configureCell(cellWidth: cellWidth, item: leaderboardService.array_MostLikedPost[indexPath.item], isCashbackPost: false)
            }
            superCell = cell
        }
        return superCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.segment_Time.selectedIndex == 0 {
            self.moveToTopCashbackPostDetail(posts: leaderboardService.array_TopCashbackPost, index: indexPath.item)
        }else if self.segment_Time.selectedIndex == 1 {
            if leaderboardService.array_MostSoldProducts[indexPath.item].status != -1 {
                self.moveToProductDetail(item: leaderboardService.array_MostSoldProducts[indexPath.item])
            }
        }else if self.segment_Time.selectedIndex == 2 {
            self.moveToTopLikedPostDetail(posts: leaderboardService.array_MostLikedPost, index: indexPath.item)
        }
    }
}

//MARK:- API Methods

extension ReviewerLeaderboardVC {
    @objc func callFetchTopCashbackEarnedPosts() {
        leaderboardService.callGetLeaderboardTopCashbackVideosAPI(showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            self.setupTopCasbackPostData()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchMostLikedPosts() {
        leaderboardService.callGetLeaderboardMostLikedPostsAPI(showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            self.setupMostLikedPostsData()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
    @objc func callFetchMostSoldProducts() {
        leaderboardService.callGetLeaderboardMostSoldProductAPI(showLoader: true, completionBlockSuccess: { (response) -> Void in
            // your successful handle
            self.setupMostSoldProductsData()
        }) { (failure) -> Void in
            // your failure handle
            self.handleAPIError(failure: failure)
        }
    }
}
