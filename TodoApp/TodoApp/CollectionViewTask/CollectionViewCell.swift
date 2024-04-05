//
//  CollectionViewCell.swift
//  TodoApp
//
//  Created by Ana Paula Flores Salinas  on 04/04/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var deliveryDate: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
