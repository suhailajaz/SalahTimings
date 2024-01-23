//
//  DatabaseManager.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 23/01/24.
//

import Foundation
import CoreData
import UIKit

struct DatabaseManager{
    
    static let shared = DatabaseManager()
    init(){}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveToCoreData(place: SavedPlaceViewModel){
        
        
            let savedPlaceEntity = SavedPlacesCD(context: context)
            let savedTimes = Time(context: context)
            
            savedPlaceEntity.city = place.query
            savedPlaceEntity.qiblaDirection = place.qiblaDirection
            savedPlaceEntity.temp = place.temp
            savedPlaceEntity.pressure = place.pressure
            
            savedTimes.fajr = place.times[0][1]
            savedTimes.dhuhr = place.times[1][1]
            savedTimes.asr = place.times[2][1]
            savedTimes.maghrib = place.times[3][1]
            savedTimes.isha = place.times[4][1]
            
            savedPlaceEntity.times = savedTimes
            
    
        
        saveCD()
    }
    
    func fetchPlacesFromCoreData(completion: @escaping ([SavedPlaceViewModel])->(Void)){
        var fetchedPlaces = [SavedPlaceViewModel]()
        
        let fetchRequest: NSFetchRequest<SavedPlacesCD> = SavedPlacesCD.fetchRequest()
        do{
            let fetchedObjects = try context.fetch(fetchRequest)
            for fetchedObject in fetchedObjects {
                let times: [[String]] = [["fajr",fetchedObject.times?.fajr ?? ""],
                                         ["dhuhr",fetchedObject.times?.dhuhr ?? ""],
                                         ["asr",fetchedObject.times?.asr ?? ""],
                                         ["maghrib",fetchedObject.times?.maghrib ?? ""],
                                         ["isha",fetchedObject.times?.isha ?? ""]]
                
                let fetchedPlace = SavedPlaceViewModel(query: fetchedObject.city ?? "",
                                                       qiblaDirection: fetchedObject.qiblaDirection ?? "",
                                                       temp: fetchedObject.temp ?? "",
                                                       pressure: fetchedObject.pressure ?? "",
                                                       times: times)
                fetchedPlaces.append(fetchedPlace)
            }
            completion(fetchedPlaces)
            
        }catch{
            print("Errror fetching saved places from coredata: \n\(error)")
        }
    }
   
    func deletePlace(placeName: String){
        let fetchRequest: NSFetchRequest<SavedPlacesCD> = SavedPlacesCD.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "city == %@", placeName)

        do {
           
            let matchingPlaces = try context.fetch(fetchRequest)

            
            if let placeToDelete = matchingPlaces.first {
                
                context.delete(placeToDelete)

                saveCD()

                print("Place '\(placeName)' deleted successfully.")
            } else {
                print("Place '\(placeName)' not found.")
            }

        } catch {
            print("Error deleting car: \(error.localizedDescription)")
        }
    }
    
    func saveCD(){
        do {
            try context.save()
            print("Places Saved Successfullt")
        } catch {
            print("Error saving places: \(error.localizedDescription)")
        }
    }
    
}
