//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Jaydeep Patoliya on 12/08/17.
//

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var welcomeLable: UILabel!
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    
    
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "E0E0E0")
        self.profileImage.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.isHidden = true
        self.signInButton.isHidden = true
        self.welcomeLable.isHidden = false
        
        self.nameLable.isHidden = true
        self.emailLable.isHidden = true
        //self.backgroundImage.setRandomDownloadImage(Int(self.bounds.size.width), height: 160)
    }
}
