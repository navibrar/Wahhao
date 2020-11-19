//  Created by Navpreet on 18/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class ThankYouVC: UIViewController {
    //MARK:- Variable Declaration
    
    //MARK:- Outlet Connections
    @IBOutlet weak var lbl_ThankYouMessage: UILabel!
    @IBOutlet weak var btn_Done: UIButton!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "gradientText")
        self.lbl_ThankYouMessage.textColor = UIColor(patternImage: image!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK:- Custom Methods
    
    //MARK:- Button Methods
    @IBAction func doneTapped(_ sender: Any) {
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        
        /*let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "HomePostViewController") as! HomePostViewController
        let navController = UINavigationController(rootViewController: vcObj)
        self.show(navController, sender: self)*/
    }
}
