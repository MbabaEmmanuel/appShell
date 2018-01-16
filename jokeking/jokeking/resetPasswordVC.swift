//
//  resetPasswordVC.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/24/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {
    
    //text field
    @IBOutlet weak var emailTxt: UITextField!
    
    //button
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //alignment
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y , width: self.view.frame.size.width / 4, height: 30)
    }
    
    //clicked reset button
    @IBAction func resetBtn_click(_ sender: AnyObject) {
        
        //hide keyboard
        self.view.endEditing(true)
        
        //email textfield is empty
        if emailTxt.text!.isEmpty {
            
            //Show alert message if email text is empty
            let alert = UIAlertController(title: "Emaail Field", message: "is empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success: Bool, error: Error?) -> Void in
            if success {
                
                //Show alert message
                let alert = UIAlertController(title: "Email for resetting password", message: "has been sent to texted email", preferredStyle: UIAlertControllerStyle.alert)
                
                //if pressed call dismiss function
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    //click cancel button
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        //hide keyboards
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
