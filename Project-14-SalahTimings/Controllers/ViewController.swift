//
//  ViewController.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import UIKit

class ViewController: UIViewController {
    
    var prayers = [[String]]()
    
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblQiblaDirection: UILabel!
    @IBOutlet var lblPressure: UILabel!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblLon: UILabel!
    @IBOutlet var lblLat: UILabel!
    @IBOutlet var tblSalah: UITableView!{
        didSet{
            tblSalah.register(SalahTableViewCell.nib, forCellReuseIdentifier: SalahTableViewCell.identifier)
        }
    }
    var networkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblSalah.delegate = self
        tblSalah.dataSource = self
        networkManager.delegate = self
        stylebordersAndCorners()
        fetchData()
    }


}
// MARK: - Custom Functions
extension ViewController{
    func stylebordersAndCorners(){
        tblSalah.layer.cornerRadius = 12
        tblSalah.layer.masksToBounds = true
        tblSalah.layer.borderWidth = 0.6
        tblSalah.layer.borderColor = UIColor.black.cgColor
     
    }
    func fetchData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.networkManager.fetchSalahTimings()
        }
    }
}
// MARK: - TableviewM Methods

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SalahTableViewCell.identifier, for: indexPath) as! SalahTableViewCell
        cell.configure(currentPrayerTime: prayers[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblSalah.frame.size.height/5
    }
    
    
}

extension ViewController:NetworkManagerDelegate{
    func updateUI(timings: SalahModel) {
        let prayerNames = ["Fajr","Zuhr","Asr","Maghrib","Isha"]
        DispatchQueue.main.async{ [weak self] in
            print("timings: \(timings)")
            self?.lblLocation.text = timings.city
            self?.lblQiblaDirection.text = timings.qibla_direction
            self?.lblPressure.text = "\(timings.today_weather.pressure) atm"
            self?.lblTemp.text = "\(timings.today_weather.temperature) °C"
            self?.lblLat.text = "Lat: \(timings.latitude)"
            self?.lblLon.text = "Lon: \(timings.longitude)"
            self?.prayers.append(["Fajr",timings.items[0].fajr])
            self?.prayers.append(["Dhuhr",timings.items[0].dhuhr])
            self?.prayers.append(["Asr",timings.items[0].asr])
            self?.prayers.append(["Maghrib",timings.items[0].maghrib])
            self?.prayers.append(["Isha",timings.items[0].isha])
            self?.tblSalah.reloadData()
        }
       
    }
    
    func netwrokError(error: Error) {
        DispatchQueue.main.async{
            let ac = UIAlertController(title: "Network Error", message: "\(error.localizedDescription)", preferredStyle:.alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(ac,animated: true)
        }
       
    }
    
    
}

