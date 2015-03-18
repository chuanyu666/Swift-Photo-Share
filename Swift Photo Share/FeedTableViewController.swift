//
//  FeedTableViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/15/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var images = [ImageStruct]()
    var followings = [String]()
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        followings.append("spofficial")
        followings.append(PFUser.currentUser().username)
        updateImages()

    }
    
    func updateImages(){
        
        var getFollowedUsersQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects{
                    self.followings.append(object["following"] as String)
                }
            }
        }
        
        var query = PFQuery(className:"images")
        query.whereKey("username", containedIn: followings)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    var item = ImageStruct()
                    item.title = object["imageTitle"] as String
                    item.username = object["username"] as String
                    item.file = object["imageFile"] as PFFile
                    self.images.append(item)
                }
            } else {
                println(error)
            }
            self.tableView.reloadData()
        }
    }
    
    func refreshing(){
        images.removeAll(keepCapacity: true)
        updateImages()
        refresher.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return images.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:FeedTableViewCell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as FeedTableViewCell
        
        cell.imageTitle.text = images[indexPath.row].title
        cell.username.text = "Posted by @"+images[indexPath.row].username
        images[indexPath.row].file.getDataInBackgroundWithBlock({
            (imageData:NSData!,error:NSError!)->Void in
            if error == nil {
                let image = UIImage(data: imageData)
                cell.postedImage.image = image
            }
        })
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
