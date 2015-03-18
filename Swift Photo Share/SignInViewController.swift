//
//  SignInViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/15/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInIndicator: UIActivityIndicatorView!
    
    @IBAction func signIn(sender: AnyObject) {
        var error = ""
        if username.text == "" || password.text == "" {
            error = "Please enter a username and password"
        }
        
        if error != "" {
            showErrorAlert("Error", error: error)
        } else{
            userLoggingIn(username.text,password: password.text,errorMsg: error)
        }
        
    }
    
    func userLoggingIn(username:String,password:String, var errorMsg:String) {
        
        signInIndicator.startAnimating()
        //suspend touch screen
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            
            self.signInIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("loginToHome", sender: self)
            } else {
                // The login failed. Check error to see why.
                if let errorString = error.userInfo?["error"] as? NSString {
                    // Show the errorString somewhere and let the user try again.
                    errorMsg = errorString
                }else{
                    errorMsg = "Please try again later"
                }
                self.showErrorAlert("Could Not Login", error: errorMsg)
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
        
        // Do any additional setup after loading the view.
        println(PFUser.currentUser())
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("loginToHome", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
