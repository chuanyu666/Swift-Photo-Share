//
//  ParseMainUIViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/17/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class ParseMainUIViewController: UIViewController,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate {
    
    var logInController:PFLogInViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInController = PFLogInViewController()
        logInController.delegate = self
        logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.Facebook
            | PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten)
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.text = "Share Your Photos!"
        label.font = UIFont(name: "Helvetica Neue", size: 35)
        label.sizeToFit()
        logInController.logInView.logo = label
        
        logInController.signUpController.delegate = self
        let label2 = UILabel()
        label2.textColor = UIColor.blackColor()
        label2.text = "Share Your Photos!"
        label2.font = UIFont(name: "Helvetica Neue", size: 35)
        label2.sizeToFit()
        logInController.signUpController.signUpView.logo = label2
        
        logInController.facebookPermissions = ["email","public_profile"]
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.presentViewController(logInController, animated:true, completion: nil)
        }else{
            self.performSegueWithIdentifier("loginToHome", sender: self)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newUserDefaultFollowing(){
        var following = PFObject(className: "followers")
        following["following"] = "spofficial"
        following["follower"] = PFUser.currentUser().username
        following.saveInBackgroundWithBlock(nil)
    }
    
    func getImageFromFB(user:PFUser){
        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSession.accessTokenData.accessToken
        var url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response,data,error) -> Void in
            let imageFile = PFFile(name: "photo.png", data: data)
            user["photo"] = imageFile
            user.saveInBackgroundWithBlock(nil)
            self.newUserDefaultFollowing()
        })
    }
    
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser!) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
        if user.isNew {
            FBRequestConnection.startForMeWithCompletionHandler({
                (connection,result,error) in
                user.username = result["name"] as String
                user.email = result["email"] as String
                self.getImageFromFB(user)
            })
        }else{
            println("login")
        }
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
        newUserDefaultFollowing()
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
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
