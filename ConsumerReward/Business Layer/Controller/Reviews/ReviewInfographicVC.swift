//  Created by Navpreet on 31/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import UIKit

class ReviewInfographicVC: UIViewController {
    //MARK:- Variable Declaration
    var array_Items = [NSDictionary]()
    //MARK:- Outlet Connections
    @IBOutlet weak var table_ReviewInfographic: UITableView!
    @IBOutlet weak var lbl_ReviewMessage: UILabel!
    @IBOutlet weak var btn_StartShopping: UIButton!
    
    //MARK:- Load View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.initialSetup()
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
    func initialSetup() {
        table_ReviewInfographic.tableFooterView = UIView()
        table_ReviewInfographic.register(UINib(nibName: "ReviewInfographicCell", bundle: nil), forCellReuseIdentifier: "ReviewInfographicCell")
        table_ReviewInfographic.reloadData()
    }
    func setupData() {
        let dict1: NSDictionary = ["title":"WATCH", "image":"watch_icon", "message":"We have the coolest products from all over the world. Discover new stuff every day through short videos."]
        let dict2: NSDictionary = ["title":"SHOP", "image":"shop_icon", "message":"Instantly shop the products you see with just a simple tap. Easiest checkout process ever."]
        let dict3: NSDictionary = ["title":"EARN", "image":"earn_icon_review", "message":"Watching, shopping, and telling your friends about us earns you cash you can spend anywhere."]
        array_Items.append(dict1)
        array_Items.append(dict2)
        array_Items.append(dict3)
    }
    //MARK:- Button Methods
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func startShoppingTapped(_ sender: Any) {
        NOTIFICATIONCENTER.post(name: NSNotification.Name("UpdateUI"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension ReviewInfographicVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewInfographicCell", for: indexPath) as! ReviewInfographicCell
        cell.configureCell(item: array_Items[indexPath.row])
        return cell
    }
    
    
}
