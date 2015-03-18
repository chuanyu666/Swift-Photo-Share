//
//  MeViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/17/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class MeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var headPhoto: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var myImageTable: UITableView!
    
    var myImages = [ImageStruct]()
    
    var user:PFUser!
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("logout", sender: self)
        
    }
    
    @IBAction func setNewPhoto(sender: AnyObject) {
        var pickedImage = UIImagePickerController()
        pickedImage.delegate = self
        pickedImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickedImage.allowsEditing = true
        self.presentViewController(pickedImage, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        headPhoto.image = image
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name: "photo.png", data: imageData)
        user["photo"] = imageFile
        user.saveInBackgroundWithBlock(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = PFUser.currentUser()
        username.text = user.username
        email.text = user.email
        if user["photo"] != nil {
            user["photo"].getDataInBackgroundWithBlock({
                (imageData:NSData!,error:NSError!)->Void in
                if error == nil {
                    self.headPhoto.image = UIImage(data: imageData)
                }else{
                    println(error)
                }

            })
        }else {
            headPhoto.image = UIImage(named: "DeviceRankNoLikeIcon")
        }
    }

    func updateMyImage(){
        var query = PFQuery(className: "images")
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    var item = ImageStruct()
                    item.title = object["imageTitle"] as String
                    item.username = object["username"] as String
                    item.file = object["imageFile"] as PFFile
                    item.id = object.objectId
                    self.myImages.append(item)
                }
            }
            self.myImageTable.reloadData()
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        myImages.removeAll(keepCapacity: true)
        updateMyImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return myImages.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:MyImageTableViewCell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as MyImageTableViewCell
        
        cell.title.text = myImages[indexPath.row].title
        
        myImages[indexPath.row].file.getDataInBackgroundWithBlock({
            (imageData:NSData!,error:NSError!)->Void in
            if error == nil {
                let image = UIImage(data: imageData)
                cell.postedImage.image = image
            }else{
                println(error)
            }
        })
        
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var obj = PFObject(className: "images")
            obj.objectId = myImages[indexPath.row].id
            obj.deleteInBackgroundWithBlock(nil)
            myImages.removeAtIndex(indexPath.row)
            myImageTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            myImageTable.reloadData()
        }
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
