//
//  FrontCoverController.swift
//  DonaldsDiary
//
//  Created by Connor Hutchinson on 25/10/20.
//

import Foundation

import UIKit

class FrontCoverController: UIViewController {
    
    
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.layer.cornerRadius = 25;
        
    }
    
    
}
