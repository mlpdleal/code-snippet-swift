// default code snippet for work to file and save data in ios filemanage
// 

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
}

// example of code to use 

import Foundation

class Favorites: ObservableObject {
    
    private var resorts: Set<String>
    //private let saveKey: String = "Favorites"
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("Favorites")
    
    init(){
        do {
            let data = try Data(contentsOf: savePath)
            resorts = try JSONDecoder().decode(Set<String>.self, from: data)
        } catch{
            resorts = []
        }
    }
    
    func contains(_ resort: Resort) -> Bool{
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort){
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort){
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(resorts)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
}