//
//  signInVC.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/24/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    //Texdt fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    //buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        label.font = UIFont (name: "Lemonade Stand", size: 50)
        
        //alignment
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20 , height: 75)
        
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 95, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30 , width: self.view.frame.size.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        
        let hideTap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        /*
        //background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "img.jpeg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        */
    }
    
    
    //hide keyboard func
    @objc func hideKeyboard(recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    //clicked sign in button
    @IBAction func signInBtn_click(_ sender: AnyObject) {
        print("sign in pressed")
        
        //hide keyboard
        self.view.endEditing(true)
        
        //if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            //show alert message
            let alert = UIAlertController(title: "Please", message: "fill in fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        //login function
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) -> Void in
            if error == nil {
                
                //Save user in app memory
                UserDefaults.standard.set(user!.username, forKey:"username")
                UserDefaults.standard.synchronize()
                
                //call login function from app delegate
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            } else {
                //show alert message
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    


}
