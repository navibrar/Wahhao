//  Created by Navpreet on 26/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    func showToastMessage(message: String) {
        let view = UIView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 75))
        view.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1).withAlphaComponent(0.85)
        let label = UILabel(frame: CGRect(x: 16, y: 10, width: view.bounds.width-32, height: view.bounds.height-40))
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.REGULAR_FONT, size: 13)!
        label.text = message
        view.addSubview(label)
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            view.frame = CGRect(x: 0, y: self.view.bounds.height-75, width: self.view.bounds.width, height: 75)
        }) { (finished) in
            self.hideToastMessage(view: view)
        }
    }
    func hideToastMessage(view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseIn, animations: {
            view.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 75)
        }) { (finished) in
            view.removeFromSuperview()
        }
    }
    
}
