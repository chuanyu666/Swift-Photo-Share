//
//  PostViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/15/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var imageChoosed = false
    
    @IBOutlet weak var postIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UITextField!
    
    @IBAction func chooseImage(sender: AnyObject) {
        var pickedImage = UIImagePickerController()
        pickedImage.delegate = self
        pickedImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickedImage.allowsEditing = false
        self.presentViewController(pickedImage, animated: true, completion: nil)
    }
    
    
    @IBAction func postImage(sender: AnyObject) {
        if imageChoosed {
            postIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "images")
            if let title = imageTitle.text? {
                post["imageTitle"] = title
            }else{
                post["imageTitle"] = ""
            }
            post["username"] = PFUser.currentUser().username
            let imageData = UIImagePNGRepresentation(image.image)
            let imageFile = PFFile(name: "image.png", data: imageData)
            post["imageFile"] = imageFile
            
            post.saveInBackgroundWithBlock({
                (success:Bool!,error:NSError!)->Void in
                
                self.postIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if success == true {
                    self.showErrorAlert("Image Posted!", error: "You have posted the image")
                    self.imageChoosed = false
                    self.image.image = UIImage(named: "default.png")
                    self.imageTitle.text = ""
                }else {
                    self.showErrorAlert("Could Not Post Image", error: "Please try again later")
                }
            })
        
        }else{
           showErrorAlert("Could Not Post Image", error: "Please choose an image")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.image.image = image
        imageChoosed = true
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
        imageChoosed = false
        image.image = UIImage(named: "default.png")
        imageTitle.text = ""
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
