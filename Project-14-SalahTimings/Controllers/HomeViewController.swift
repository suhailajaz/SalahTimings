//
//  ViewController.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var prayers = [[String]]()
    
    @IBOutlet var searchBar: UISearchBar!
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
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        stylebordersAndCorners()
        fetchData()
    }


}
// MARK: - Custom Functions
extension HomeViewController{
    func stylebordersAndCorners(){
        tblSalah.layer.cornerRadius = 12
        tblSalah.layer.masksToBounds = true
        tblSalah.layer.borderWidth = 0.6
        tblSalah.layer.borderColor = UIColor.black.cgColor
     
    }
    func fetchData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.networkManager.fetchSalahTimings("Srinagar")
        }
    }
}
// MARK: - TableviewM Methods

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
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

extension HomeViewController:NetworkManagerDelegate{
    func updateUI(timings: SalahModel) {
        
        DispatchQueue.main.async{ [weak self] in
            print("timings: \(timings)")
            self?.prayers.removeAll()
            self?.lblLocation.text = timings.query
            self?.lblQiblaDirection.text = timings.qibla_direction
            self?.lblPressure.text = "\(timings.today_weather?.pressure ?? "") atm"
            self?.lblTemp.text = "\(timings.today_weather?.temperature ?? "") °C"
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

extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            print("No text entered")
            return
        }
        searchBar.text = ""
        let place = text.replacingOccurrences(of: " ", with: "")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.networkManager.fetchSalahTimings(place)
        }
    }
}
