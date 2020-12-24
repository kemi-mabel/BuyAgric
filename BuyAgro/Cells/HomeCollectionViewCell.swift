//
//  CategoryCollectionViewCell.swift
//  BuyAgro
//
//  Created by mohammed sani hassan on 21/12/2020.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category: Category ){
        nameLabel.text = category.name
        imageView.image = category.image
        
    }
}





//comment
