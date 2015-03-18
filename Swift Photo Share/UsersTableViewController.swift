//
//  UsersTableViewController.swift
//  Swift Photo Share
//
//  Created by Chuan Yu on 3/15/15.
//  Copyright (c) 2015 Chuan Yu. All rights reserved.
//

import UIKit

class UsersTableViewController: PFQueryTableViewController {

    var users = [""]

    var followings = [String]()
    
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUsers()
//        
//        refresher = UIRefreshControl()
//        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refresher.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refresher)
        self.pullToRefreshEnabled = false
    }
    
    
    func updateUsers(){
//        var query = PFUser.query()
//        query.findObjectsInBackgroundWithBlock({
//            (objects:[AnyObject]!,error:NSError!)->Void in
//            
//            self.users.removeAll(keepCapacity: true)
//            
//            for object in objects {
//                var user:PFUser = object as PFUser
//                if user.username != PFUser.currentUser().username {
//                    self.users.append(user.username)
//                }
//            }
//            
//            self.tableView.reloadData()
//        })
        var queryFollowing = PFQuery(className:"followers")
        queryFollowing.whereKey("follower", equalTo:PFUser.currentUser().username)
        queryFollowing.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                // Do something with the found objects
                for object in objects {
                    self.followings.append(object.objectForKey("following")! as String)
                }
            } else {
                // Log details of the failure
                println(error)
            }
            self.tableView.reloadData()
        }
    }
//    
//    func refreshing(){
//        updateUsers()
//        refresher.endRefreshing()
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return users.count
//    }

    override func queryForTable() -> PFQuery! {
        var query = PFUser.query()
        query.whereKey("username", notEqualTo: PFUser.currentUser().username)
        query.orderByAscending("username")
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        var cell:PFTableViewCell
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier("userCell") as?PFTableViewCell {
            cell = reuseCell
        }else{
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "userCell")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = object["username"] as? String
        cell.imageView?.image = UIImage(named: "DeviceRankNoLikeIcon")
        if object["photo"] != nil {
            cell.imageView.file = object["photo"] as PFFile
        }
        if contains(followings, object["username"] as String) {
              cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
 
        return cell
    }
    
   
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as UITableViewCell
//        cell.textLabel?.text = users[indexPath.row]
//        cell.imageView?.image = UIImage(named: "DeviceRankNoLikeIcon")
//        if contains(followings, users[indexPath.row]) {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        }
//        return cell
//    }
//
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.whereKey("following", equalTo:cell!.textLabel!.text)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // Do something with the found objects
                    for object in objects {
                        object.deleteInBackgroundWithBlock(nil)
                    }
                } else {
                    // Log details of the failure
                    println(error)
                }
            }
        } else{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            var following = PFObject(className: "followers")
            following["following"] = cell!.textLabel!.text
            following["follower"] = PFUser.currentUser().username
            following.saveInBackgroundWithBlock(nil)
        }
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
