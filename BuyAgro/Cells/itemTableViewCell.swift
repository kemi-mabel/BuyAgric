//
//  itemTableViewCell.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 28/12/2020.
//

import UIKit

class itemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: IBOutlets
        @IBOutlet weak var itemImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var descriptionLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        
        
    func generateCell(_ item: Item) {
            
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertToCurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        //TODO: Download image
        if item.imageLinks != nil && item.imageLinks.count > 0 {

            downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage
                }
            }

        }

    }
