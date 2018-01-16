//
//  homeVC.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/25/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit
import Parse

var what = String()
var  user = String()


class homeVC: UICollectionViewController {
    
    //refresher variable
    var refresher : UIRefreshControl!
    
    //size of page
    var page : Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFile]()

    //default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // always scroll vertical
        self.collectionView?.alwaysBounceVertical = true
        
        //title
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        //load posts function
        loadPosts()

    }

    //refreshing function
   @objc func refresh() {
    
        //reload data information
        collectionView?.reloadData()
    
        //stop refresher animating
        refresher.endRefreshing()
    }
    
    //load posts function
    @objc func loadPosts() {
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                //clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                //find related to our request
                for object in objects! {
                    
                    //add found data to arrays(holders)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    // cell number
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    //cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath ) as! pictureCell
        
        //get picture from the pic Array
        picArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at
        indexPath: IndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
      
        //Step 1. Get user data
        //get users data with connection to columns of PFuser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        header.button.setTitle("edit profile", for: UIControlState.normal)
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data:Data?, error:Error?) -> Void in
            header.avaImg.image = UIImage(data: data!)
        }
        
        // Step 2. Count statistics
        //count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count: Int32, error: Error?) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        //count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()!.username!)
        followers.countObjectsInBackground { (count:Int32, error:Error?) -> Void in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        
        //count total following
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: PFUser.current()!.username!)
        followings.countObjectsInBackground { (count:Int32, error:Error?) -> Void in
            if error == nil {
                header.followings.text = "\(count)"
            }
        }
        
        //Step 3 Implement tap gestures
        // tap posts
        let postTap = UITapGestureRecognizer(target: self, action: #selector(postsTap))
        postTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        return header
        
    }
    
    //taped posts total
    @objc func postsTap() {
    
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
        }
        
    }
    
    //tapped followers label
    @objc func followersTap() {
        user = PFUser.current()!.username!
        what = "followers"
        
        //make reference to followers VC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    @objc func followingsTap() {
        user = PFUser.current()!.username!
        what = "followings"
        
        //make reference to followers VC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        self.navigationController?.pushViewController(followings, animated: true)
        
        
    }
    

    /*
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
 */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
