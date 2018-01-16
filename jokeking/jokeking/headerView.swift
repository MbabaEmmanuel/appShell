//
//  headerView.swift
//  jokeking
//
//  Created by Emmanuel Mbaba on 12/25/17.
//  Copyright © 2017 Emmanuel Mbaba. All rights reserved.
//

import UIKit

class headerView: UICollectionReusableView {
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
}
