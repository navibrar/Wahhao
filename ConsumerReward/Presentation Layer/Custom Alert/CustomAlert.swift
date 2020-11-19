//  Created by Navpreet on 22/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class CustomAlert: UIView {
    @IBOutlet weak var img_Alert: UIImageView!
    @IBOutlet weak var lbl_Alert: UILabel!
    @IBOutlet var view_Alert: UIView!
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        Bundle.main.loadNibNamed("CustomAlert", owner: self, options: nil)
        addSubview(view_Alert)
        view_Alert.frame = self.bounds
        view_Alert.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 1, alpha: 1).withAlphaComponent(0.85)
        
        lbl_Alert.textAlignment = .center
        lbl_Alert.backgroundColor = .clear
        lbl_Alert.translatesAutoresizingMaskIntoConstraints = false
        
        img_Alert.contentMode = .center
        img_Alert.translatesAutoresizingMaskIntoConstraints = false
        
        let labelTop = lbl_Alert.topAnchor.constraint(equalTo: view_Alert.topAnchor, constant: 10)
        let labelRight = lbl_Alert.rightAnchor.constraint(lessThanOrEqualTo: view_Alert.rightAnchor, constant: -16)
        let labelBottom = lbl_Alert.bottomAnchor.constraint(equalTo: view_Alert.bottomAnchor, constant: -30)
        let labelCenter = lbl_Alert.centerXAnchor.constraint(equalTo: view_Alert.centerXAnchor, constant: 10)
        NSLayoutConstraint.activate([labelTop, labelRight, labelBottom, labelCenter])
        
        let imgWidth = img_Alert.widthAnchor.constraint(equalToConstant: 25)
        let imgHeight = img_Alert.heightAnchor.constraint(equalToConstant: 25)
        let imgCenter = img_Alert.centerYAnchor.constraint(equalTo: lbl_Alert.centerYAnchor)
        let imgRight = img_Alert.rightAnchor.constraint(equalTo: lbl_Alert.leftAnchor, constant: -5)
        NSLayoutConstraint.activate([imgWidth, imgHeight, imgCenter, imgRight])
        
    }
    
    func showCustomAlertWithImage(message: String, imageName: String, viewController: UIViewController) {
        self.view_Alert.frame = CGRect(x: 0, y: viewController.view.bounds.height, width: viewController.view.bounds.width, height: 75)
        lbl_Alert.text = message
        img_Alert.image = UIImage(named: imageName)
//        viewController.view.addSubview(view_Alert)
        let window = UIApplication.shared.windows.last
        window!.addSubview(view_Alert)

        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            self.view_Alert.frame = CGRect(x: 0, y: viewController.view.bounds.height-75, width: viewController.view.bounds.width, height: 75)
        }) { (finished) in
            self.hideCustomAlert(viewController: viewController)
        }
        self.view_Alert.layoutSubviews()
    }
    
     func hideCustomAlert(viewController: UIViewController) {
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseIn, animations: {
            self.view_Alert.frame = CGRect(x: 0, y: viewController.view.bounds.height, width: viewController.view.bounds.width, height: 75)
        }) { (finished) in
            self.view_Alert.removeFromSuperview()
        }
    }
}

