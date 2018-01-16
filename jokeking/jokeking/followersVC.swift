//
//  followersVC.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/25/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit
import Parse



class followersVC: UITableViewController {
    
    //arrays to hold dat received from servers
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    
    //follow array
    var followArray = [String]()
    
    //default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = what.uppercased()
        
        // load followers if tapped on followers label
        if what == "followers" {
            loadFollower()
        }
        
        // load followings if tappedd on followings label
        if what == "followings" {
            loadFollowing()
        }

    }
    
    func loadFollower() {
        
        
        // find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                
                //clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                //find related objects depending on query settings
                for object in objects! {
                    self.followArray.append(object.value(forKey: "follower") as! String)
                }
                
                //find users following user
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("_created_at")
                query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?)  -> Void in
                    if error == nil {
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                        
                    } else  {
                            print(error!.localizedDescription)
                    }
                })
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // shows followers
    func loadFollowing () {
        
        //Step 1. Find in Follow class people following user
        //find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
            
            //clean up
            self.followArray.removeAll(keepingCapacity: false)
            
            //Step 2 Hold received data
            // find related objects in "follow" class of Parse
            for object in objects! {
                self.followArray.append(object.value(forKey: "following") as! String)
            }
            
            //Step 3 Find in user class data of users
            // find users to follow by user
            let query = PFQuery(className: "_User")
            query.whereKey("username", containedIn: self.followArray)
            query.addDescendingOrder("_created_at")
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error: Error?) -> Void in
                if error == nil {
                    
                    //clean up
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.avaArray.removeAll(keepingCapacity: false)
                    
                    // find related objects in "User" class of Parse
                    for object in objects! {
                        self.usernameArray.append(object.object(forKey: "username") as! String)
                        self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                        self.tableView.reloadData()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            } else {
                print(error!.localizedDescription)
            }
        
       }
    }

   //cell number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }

    //cell configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        
        //STEP 1. Connect data from server to objects
        // connect data from server to objects
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) -> Void in
            if error == nil {
                cell.avaImg.image == UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        //STEP 2.
        // show do user following or do not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text)
        query.countObjectsInBackground { (count:Int32, error:Error?) -> Void in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("FOLLOW", for: UIControlState.normal)
                    cell.followBtn.backgroundColor = UIColor.lightGray
                } else {
                    cell.followBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    cell.followBtn.backgroundColor = UIColor.green
                }
            }
        }
        
        //hide follow button for current user
        if cell.usernameLbl.text == PFUser.current()?.username {
            cell.followBtn.isHidden = true
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
