//
//  placeTableViewCell.swift
//  DepositBeverage
//
//  Created by Chantanat Sensupa on 9/5/2559 BE.
//  Copyright © 2559 mintmint. All rights reserved.
//

import UIKit

class placeTableViewCell: UITableViewCell {
    
    
    var placeLogo = UIImageView()
    var placeName = UILabel()
    var placeOpenClose = UILabel()
    var pandingView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 80)
        
        //Place image
        self.placeLogo.frame = CGRect(x: 5, y: 5, width: 70, height: 70)
        self.placeLogo.image = UIImage(named: "logo2")
        self.placeLogo.backgroundColor = UIColor.white
        self.contentView.addSubview(self.placeLogo)
        
        //Place Title
        self.placeName.frame = CGRect(x: 80, y: 10, width: (self.contentView.frame.size.width-85), height: 30)
        self.placeName.text = "Place title"
        self.placeName.font = self.placeName.font.withSize(20)
        self.placeName.backgroundColor = UIColor.white
        self.contentView.addSubview(self.placeName)
        
        //Place open close
        self.placeOpenClose.frame = CGRect(x: 80, y: 40, width: (self.contentView.frame.size.width-85), height: 30)
        self.placeOpenClose.text = "Place open/close"
        self.placeOpenClose.backgroundColor = UIColor.white
        self.contentView.addSubview(self.placeOpenClose)
        
        pandingView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 80)
        pandingView.alpha = 0.2
        pandingView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(pandingView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
