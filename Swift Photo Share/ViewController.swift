//
//  ViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/14/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var signupIndicator: UIActivityIndicatorView!
    
    @IBAction func signup(sender: AnyObject) {
        var error = ""
        if username.text == "" || password.text == "" || confirmPassword.text == "" || email.text == "" {
            error = "Please fill out the form"
        }
        if password.text != confirmPassword.text {
            error = "Password not identical"
        }
        if error != "" {
            showErrorAlert("Error", error: error)
        } else{
            userSigningUp(username.text,password: password.text,email:email.text,errorMsg: error)
        }
        
    }
    
    func userSigningUp(username:String,password:String, email:String, var errorMsg:String) {
        var user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        //   user.email = "email@example.com"
        // other fields can be set just like with PFObject
        //   user["phone"] = "415-392-0202"
        
        signupIndicator.startAnimating()
        //suspend touch screen
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            
            self.signupIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                // Hooray! Let them use the app now.
                self.performSegueWithIdentifier("signupToHome", sender: self)
            } else {
                if let errorString = error.userInfo?["error"] as? NSString {
                    // Show the errorString somewhere and let the user try again.
                    errorMsg = errorString
                }else{
                    errorMsg = "Please try again later"
                }
                self.showErrorAlert("Could Not Sign Up", error: errorMsg)
            }
        }
    }
    
    func showErrorAlert(title:String,error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

