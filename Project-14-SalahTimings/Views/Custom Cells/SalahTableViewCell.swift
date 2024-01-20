//
//  SalahTableViewCell.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import UIKit

class SalahTableViewCell: UITableViewCell {
    
    static let identifier = "SalahTableViewCell"
    static let nib = UINib(nibName: "SalahTableViewCell", bundle: nil)
    @IBOutlet var prayerTime: UILabel!
    @IBOutlet var prayerName: UILabel!
    @IBOutlet var vwContainer: UIView!
    @IBOutlet var vwColorBullett: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        vwContainer.layer.cornerRadius = 10
        vwContainer.layer.masksToBounds = true
    }
    func configure(currentPrayerTime: [String]){
        self.prayerName.text = currentPrayerTime[0]
        self.prayerTime.text = currentPrayerTime[1]
        self.vwColorBullett.backgroundColor = generateRandomColor()
    }
}
