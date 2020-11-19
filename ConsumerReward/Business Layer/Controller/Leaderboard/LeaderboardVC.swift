//  Created by Navpreet on 24/11/18.
//  Copyright © 2018 wahhao. All rights reserved.

import UIKit

class LeaderboardVC: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "ReferralLeaderboardVC"),
            self.getViewController(withIdentifier: "ReviewerLeaderboardVC")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Leaderboard", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    //MARK:- Variable Declaration
    var isFirstController = Bool()
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageControl()
        self.dataSource = self
        self.delegate   = self
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipedown)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let scrollView = view.subviews.filter({ $0 is UIScrollView }).first,
            let pageControl = view.subviews.filter({ $0 is UIPageControl }).first {
            scrollView.frame = view.bounds
            pageControl.frame = CGRect(x: (self.view.bounds.width/2)-30, y: self.view.bounds.height-40, width: 60, height: 10)
            view.bringSubviewToFront(pageControl)
        }
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
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.currentPageIndicatorTintColor = .white
        appearance.backgroundColor = .clear
        appearance.numberOfPages = pages.count
        appearance.hidesForSinglePage = true
        if isFirstController {
            if let firstVC = pages.first {
                setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                appearance.currentPage = 0
            }
        }else {
            setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
            appearance.currentPage = 1
        }
        //self.isPagingEnabled = false
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
//MARK:- UIPageViewControllerDataSource
extension LeaderboardVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        }else {
           return pages[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        if nextIndex >= pages.count {
            return nil
        }else {
           return pages[nextIndex]
        }
    }
}
//MARK:- UIPageViewControllerDelegate
extension LeaderboardVC: UIPageViewControllerDelegate { }

//MARK:- UIPageViewController
extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}


