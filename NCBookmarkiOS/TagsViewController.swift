//
//  TagsViewController.swift
//  NCBookmarkiOS
//
//  Created by Len Chan on 21/8/2017.
//  Copyright © 2017 Len Chan. All rights reserved.
//

import UIKit
import Alamofire
class TagsViewController: UITableViewController {
    var  cars = [String]()
    let V2_API_ENDPOINT = "/apps/bookmarks/public/rest/v2/"
    var newCar: String = ""
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let username = UserDefaults.standard.string(forKey: "username")
        let password = UserDefaults.standard.string(forKey: "password")
        let loginString = String(format: "%@:%@", username!, password!)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginString)"]
        let url1 = UserDefaults.standard.string(forKey: "url")! + V2_API_ENDPOINT + "tag"
        Alamofire.request(url1, method: .get, headers: headers)
            .responseJSON{(responseObject) -> Void in
                
                if responseObject.result.isSuccess {
                    let json = responseObject.result.value as! NSArray
                    //let jsonArray = try? JSONSerialization.jsonObject(with: str.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    
                    var finalArray:[String] = []
                    for i in 0...json.count-1{
                        let str2 = "\(json[i])" as String
                        print(str2)
                        self.cars.append(str2)
                        self.tableView.reloadData()
                    }
                    
                }else if responseObject.result.isFailure {
                    
                }
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()

    }

    override func viewDidAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func onbtnMenuClick(_ sender: Any) {
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Clear Data", style: UIAlertActionStyle.default, handler: { action in
            var ud = UserDefaults.standard
            ud.removeObject(forKey: "url")
            ud.removeObject(forKey: "username")
            ud.removeObject(forKey: "password")
            // switching
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
            self.showDetailViewController(vc as! ViewController, sender: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) 
        
        cell.textLabel!.text = cars[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        print("row: \(indexPath.row)")
        print("content: \(cars[indexPath.row])")
        UserDefaults.standard.set(cars[indexPath.row], forKey: "currTag")
        gotoBookmarkView()
        
    }
    
    func gotoBookmarkView(){
        // switching
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "BookmarkNavController")
        self.showDetailViewController(vc as! UINavigationController, sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
