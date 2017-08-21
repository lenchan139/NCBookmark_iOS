//
//  BookmarksViewController.swift
//  NCBookmarkiOS
//
//  Created by Len Chan on 21/8/2017.
//  Copyright © 2017 Len Chan. All rights reserved.
//

import UIKit

import Alamofire
class BookmarksViewController: UITableViewController {
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var btnBack: UIButton!
    var  cars = [BookmarkObj]()
    let V2_API_ENDPOINT = "/apps/bookmarks/public/rest/v2/"
    var newCar: String = ""
    @IBAction func onBtnBackPressed(_ sender: Any) {
        // switching
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "tagNavController")
        self.showDetailViewController(vc as! UINavigationController, sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tag = UserDefaults.standard.string(forKey: "currTag")
        if(tag != nil){
            NavBar.title = tag
            let username = UserDefaults.standard.string(forKey: "username")
            let password = UserDefaults.standard.string(forKey: "password")
            let loginString = String(format: "%@:%@", username!, password!)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginString)"]
            let url1 = UserDefaults.standard.string(forKey: "url")! + V2_API_ENDPOINT + "bookmark?sortby=tags&page=-1" + "&tags[]=" + tag!
            Alamofire.request(url1, method: .get, headers: headers)
                .responseJSON{(responseObject) -> Void in
                    
                    if responseObject.result.isSuccess {
                        let json = responseObject.result.value as! NSDictionary
                        let jsonArr = json["data"] as! NSArray
                        //let jsonArray = try? JSONSerialization.jsonObject(with: str.data(using: .utf8)!, options: JSONSeri
                        for i in 0...jsonArr.count-1{
                            let jsonRow = jsonArr[i] as! NSDictionary
                            let t = jsonRow["title"] as! String
                            let u = jsonRow["url"] as! String
                            let bj = BookmarkObj.init(title:t , url:u )
                            self.cars.append(bj)
                            self.tableView.reloadData()
                        }
                    
                    }else if responseObject.result.isFailure {
                        
                    }
            }
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath)
        
        cell.textLabel!.text = cars[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url1 = URL(string: cars[indexPath.row].url)!
        UIApplication.shared.openURL(url1)
    
        
    }

}
