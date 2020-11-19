//  Created by Navpreet on 07/01/19.
//  Copyright © 2019 Navpreet. All rights reserved.

import UIKit
import SwiftyGif

class WahhaoLoader: UIView {
    static let sharedInstance = WahhaoLoader()
    var loaderView: UIView? = nil
    var loaderImageView: UIImageView? = nil
    
    func showWahhaoLoader(controller: UIViewController) {
        if loaderImageView?.isAnimatingGif() == nil || loaderImageView?.isAnimatingGif() == false {
            if(controller.isKind(of: ShopMoreVC.self)){
                print("shop more",controller)
                loaderView = UIView(frame: (controller as? ShopMoreVC)!.baseView.frame)
                loaderView!.backgroundColor = UIColor.clear
            }
            else if(controller.isKind(of: ProductDetailVC.self))
            {
                print("ProductDetailVC",controller)
                loaderView = UIView(frame: (controller as? ProductDetailVC)!.back_View.frame)
                loaderView!.backgroundColor = UIColor.clear
            }
            else if(controller.isKind(of: CheckoutVC.self))
            {
                print("CheckoutVC",controller)
                loaderView = UIView(frame: (controller as? CheckoutVC)!.contentView.frame)
                loaderView!.backgroundColor = UIColor.clear
            }
            else if(controller.isKind(of: ShopMoreCategoryListViewController.self))
            {
                print("ShopMoreCategoryListViewController",controller)
                loaderView = UIView(frame: (controller as? ShopMoreCategoryListViewController)!.view.frame)
                loaderView!.backgroundColor = UIColor.clear
            }
            else{
                loaderView = UIView(frame: controller.view.bounds)
                loaderView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.6)
            }

            //let gif = UIImage(gifName: "WahhaoLoaderSmall.gif")
            let gif = UIImage(gifName: "WahhaoLoader.gif")
            //let imageView = UIImageView(gifImage: gif, loopCount: -1)
            loaderImageView = UIImageView(gifImage: gif)
            loaderImageView!.frame = CGRect(x: (loaderView!.bounds.width/2)-41, y: (loaderView!.bounds.height/2)-67, width: 83, height: 134)
            loaderView!.addSubview(loaderImageView!)
            loaderImageView?.startAnimatingGif()
            controller.view.isUserInteractionEnabled = false
            controller.view.addSubview(self.loaderView!)
            controller.view.bringSubviewToFront(self.loaderView!)
        }
    }

    func hideWahhaoLoader() {
        if self.loaderView != nil {
            self.loaderView!.getParentViewController()?.view.isUserInteractionEnabled = true
            if self.loaderImageView != nil {
                self.loaderImageView?.stopAnimatingGif()
                self.loaderImageView!.image = nil
            }
            loaderView?.removeFromSuperview()
            self.loaderView = nil
        }
    }
}
//Swift 3
extension UIResponder {
    func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).getParentViewController()
            }
            else {return nil}
        }
    }
}
