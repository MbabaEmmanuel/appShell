//
//  guestVC.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/25/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class guestVC: UICollectionViewController {
    
    // UI objects
    var refresher : UIRefreshControl!
    var page : Int = 10
    
    // arrays to hold data from server
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allow vertical scroll
        self.collectionView!.alwaysBounceVertical = true
        
        //top title
        self.navigationItem.title = guestname.last
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        //swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back (sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        //call load posts
        loadPoasts()

    }
    
    @objc func back(sender : UIBarButtonItem) {
        
        //push back
        self.navigationController?.popViewController(animated: true)
        
        // clean guest username or deduct the last guest username from guestname + Array
        if !guestname.isEmpty {
            guestname.removeLast()
        }
    }
    
    // refresh function
    @objc func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    // posts loading function
    @objc func loadPoasts() {
        
        //load posts
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page
        query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) -> Void in
            if error == nil {
                
                //find related objects
                for object in objects! {
                    
                    // hold found information in arrays
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }

  // cell number
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // define cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        picArray[indexPath.row].getDataInBackground { (data: Data?, error:Error?) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        return cell
    }

}
