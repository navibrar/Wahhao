//  Created by Nvish on 1/23/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit


class LeaderBoardViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    var pageController: PageControlViewController!
    var isFirstController = Bool()
    var dataController: [UIViewController] = []
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController.append(self.getViewController(withIdentifier: "ReferralLeaderboardVC"))
        dataController.append(self.getViewController(withIdentifier: "ReviewerLeaderboardVC"))
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
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
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Leaderboard", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PageControlViewController {
            self.pageController = controller
            self.pageController.delegate = self
            self.pageController.dataSource = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageController.isFirstController = self.isFirstController
        self.isFirstController = true
        if self.pageControl.currentPage == 0 && self.dataController.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                let vc : ReferralLeaderboardVC  = self.dataController[0] as! ReferralLeaderboardVC
                vc.hideCloseBtn(isHidden: false)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension LeaderBoardViewController: PageControlDelegate {
    
    func pageControl(_ pageController: PageControlViewController, atSelected viewController: UIViewController) {
        print(viewController)
        if viewController .isKind(of: ReferralLeaderboardVC.self) {
            pageControl.currentPage = Int(0)
      }else{
            pageControl.currentPage = Int(1)
       }
    }
    
    func pageControl(_ pageController: PageControlViewController, atUnselected viewController: UIViewController) {
    }
}

extension LeaderBoardViewController: PageControlDataSource {
    
    func numberOfCells(in pageController: PageControlViewController) -> Int {
        return self.dataController.count
    }
    
    func pageControl(_ pageController: PageControlViewController, cellAtRow row: Int) -> UIViewController! {
        return self.dataController[row]
    }
    
    func pageControl(_ pageController: PageControlViewController, sizeAtRow row: Int) -> CGSize {
        let width = pageController.view.bounds.size.width - 16
        return CGSize(width: width, height:  self.view.bounds.height-40)
    }
    
}
