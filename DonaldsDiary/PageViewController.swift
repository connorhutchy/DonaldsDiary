//
//  PageViewController.swift
//  DonaldsDiary
//
//  Created by Connor Hutchinson on 25/10/20.
//

import Foundation
import UIKit

class PageViewController: UIViewController {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    var tweetText:String = "";
    var dateText:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.text = dateText;

        tweet.text = tweetText;
        background.layer.cornerRadius = 25;
        
    }
    
    
}
