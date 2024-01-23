//
//  SavedPlacesViewController.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 21/01/24.
//

import UIKit

class SavedPlacesViewController: UIViewController {
   
    var salahDetails = [SavedPlaceViewModel]()
    var networkManager = NetworkManager()
    @IBOutlet var tblSavedPlaces: UITableView!{
        didSet{
            tblSavedPlaces.register(SavedPlacesTableViewCell.nib, forCellReuseIdentifier: SavedPlacesTableViewCell.identifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved Places"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaceTapped))
        tblSavedPlaces.delegate = self
        tblSavedPlaces.dataSource = self
        networkManager.delegate = self
        DatabaseManager.shared.fetchPlacesFromCoreData { fetchedPlaces in
            self.salahDetails = fetchedPlaces
        }
    
    }
    
    @objc func cancelPressed(_ sender: UIButton){
        let targetCell = sender.tag
        DatabaseManager.shared.deletePlace(placeName: salahDetails[targetCell].query)
        salahDetails.remove(at: targetCell)
        self.tblSavedPlaces.reloadData()
    }

}
// MARK: - Custom Methods
extension SavedPlacesViewController{
    @objc func addPlaceTapped(){
    
        let ac = UIAlertController(title: "Add place", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Enter the place..."
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel) {[weak self, weak ac] _ in
            guard let newPlace = ac?.textFields?[0].text else { return }
            print("The place that you just added is: \(newPlace)")
            self?.addPlace(newPlace)
            
        })
        
        present(ac, animated: true)
    }
    func addPlace(_ place: String){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.networkManager.fetchSalahTimings(place)
    
        }
    }
}


extension SavedPlacesViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salahDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedPlacesTableViewCell.identifier , for: indexPath) as! SavedPlacesTableViewCell
        cell.configure(place: salahDetails[indexPath.row])
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DatabaseManager.shared.deletePlace(placeName: salahDetails[indexPath.row].query)
            salahDetails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}


// MARK: - NetworkManger Delegate
extension SavedPlacesViewController:NetworkManagerDelegate{
    func updateUI(timings: SalahModel) {
        
        DispatchQueue.main.async{ [weak self] in
            print("timings: \(timings)")
            
            let times = [["Fajr",timings.items[0].fajr],["Dhuhr",timings.items[0].dhuhr],["Asr",timings.items[0].asr],["Maghrib",timings.items[0].maghrib],["Isha",timings.items[0].isha]]
            let salahDetails = SavedPlaceViewModel(query: timings.query, qiblaDirection: timings.qibla_direction, temp: timings.today_weather?.temperature ?? " " , pressure: timings.today_weather?.pressure ?? " ",times: times )
            
            self?.salahDetails.append(salahDetails)
            DatabaseManager.shared.saveToCoreData(place: salahDetails )
            self?.tblSavedPlaces.reloadData()
         
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
