//
//  SheetCell.swift
//  MazaadyTask
//
//  Created by Nevine on 06/02/2023.
//

import UIKit

class SheetCell: UITableViewCell {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var popupCellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(name: String, isSelected: Bool) {
        popupCellLabel.text = name
    }
}
