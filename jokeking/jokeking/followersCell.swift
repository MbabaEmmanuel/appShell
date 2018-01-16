//
//  followersCell.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/25/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }

    @IBAction func followBtn_click(_ sender: AnyObject) {
        
        let title = followBtn.title(for: UIControlState.normal)
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success: Bool, error: Error?) -> Void in
                if success {
                    self.followBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    self.followBtn.backgroundColor = UIColor.green
                } else {
                    print(error?.localizedDescription)
                }
            })
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()?.username)
            query.whereKey("following", equalTo: usernameLbl.text)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success: Bool, error: Error?) -> Void in
                            if success {
                                self.followBtn.setTitle("FOLLOW", for: UIControlState.normal)
                                self.followBtn.backgroundColor = UIColor.lightGray
                            } else {
                                print (error?.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
        }
        
    }
    
}
