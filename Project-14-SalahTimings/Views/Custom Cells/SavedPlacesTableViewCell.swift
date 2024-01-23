//
//  SavedPlacesTableViewCell.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 21/01/24.
//

import UIKit
struct SavedPlaceViewModel{
    let query: String
    let qiblaDirection: String
    let temp: String
    let pressure: String
    let times: [[String]]

}

class SavedPlacesTableViewCell: UITableViewCell {
    
    static let identifier = "SavedPlacesTableViewCell"
    static let nib = UINib(nibName: "SavedPlacesTableViewCell", bundle: nil)
    var times = [[String]]()
    
    @IBOutlet var btnCancel: UIControl!
    @IBOutlet var vwContainer: UIView!
    @IBOutlet var lblQiblaDirection: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblPressue: UILabel!
    @IBOutlet var tbl: UITableView!{
        didSet{
            tbl.register(SalahTableViewCell.nib, forCellReuseIdentifier: SalahTableViewCell.identifier)
        }
    }
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tbl.dataSource = self
        tbl.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(place: SavedPlaceViewModel){
        lblLocation.text = place.query
        lblQiblaDirection.text = place.qiblaDirection
        lblTemp.text = place.temp
        lblPressue.text = place.pressure
        self.times = place.times
        
        
    }
    
}

extension SavedPlacesTableViewCell: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SalahTableViewCell.identifier, for: indexPath) as! SalahTableViewCell
       cell.configure(currentPrayerTime: times[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tbl.frame.size.height/5
    }
    
}


