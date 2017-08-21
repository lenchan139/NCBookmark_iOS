//
//  ViewController.swift
//  NCBookmarkiOS
//
//  Created by Len Chan on 20/8/2017.
//  Copyright © 2017 Len Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ncurl: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let u1 = userDefaults.string(forKey: "url")
        let u2 = userDefaults.string(forKey: "username")
        let u3 = userDefaults.string(forKey: "password")
        if(u1 == nil || u2 == nil || u3 == nil){
            
        }else{
            gotoTagView()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnSavePressed(_ sender: Any) {
        var msg = ""
        if(!ncurl.text!.isEmpty && !username.text!.isEmpty && !password.text!.isEmpty){
        msg += "Url: " + ncurl.text! + "\n"
        msg += "Username: " + username.text! + "\n"
        msg += "Password: " + password.text! + "\n"
        //saving user data
        let userDefaults = UserDefaults.standard
        userDefaults.set(ncurl.text, forKey: "url")
        userDefaults.set(username.text, forKey: "username")
        userDefaults.set(password.text, forKey: "password")
        userDefaults.synchronize()
            gotoTagView()
        }else{
            msg = "Url or Username or Password is empty."
        }
        let alert = UIAlertController(title: "Dialog", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func gotoTagView(){
        
        // switching
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "tagNavController")
        self.showDetailViewController(vc as! UINavigationController, sender: self)
    }


}

