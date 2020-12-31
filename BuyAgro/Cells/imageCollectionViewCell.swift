//
//  imageCollectionViewCell.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 30/12/2020.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setUpImageWith(itemImage: UIImage){
        imageView.image = itemImage
        
    }
}
