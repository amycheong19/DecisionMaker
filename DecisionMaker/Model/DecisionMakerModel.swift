//
//  DecisionMakerModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation

class DecisionMakerModel: ObservableObject {
    @Published private(set) var checkedOptions: [Option] = []
    @Published private(set) var collections: [Collection] = []
    @Published private(set) var selectedCollectionID: Collection.ID?
    
    @Published var collection = Collection.restaurants
    
    private var idCount = 1000
    
    init() {
        createCollection()
    }

}

extension DecisionMakerModel {
    
    func createCollection(_ collection: Collection? = nil) {
        guard !collections.isEmpty else {
            // initial
            if let jsonCollections = try? Collection.loadJSON() {
                collections.append(contentsOf: jsonCollections)
            }
            return
        }
        
        guard let collection = collection else { return }
        collections.append(collection)
    }
    
    func selectCollection(_ collection: Collection) {
        selectedCollectionID = collection.id
        self.collection = collection
        checkedOptions.removeAll()
        _ = collection.options.compactMap{ addChecked($0) }
    }
    
    func setCollection(_ collection: Collection) {
        guard let indexSet = collections.firstIndex(where: { $0.id == selectedCollectionID }) else {
            return
        }
        collections[indexSet] = collection
        
        do {
            _ = try Collection.save(jsonObject: collections)
        } catch  {
            print(error)
        }
        
    }
    
    func removeCollection(_ collection: Collection) {
        if let index = collections.firstIndex(of: collection) {
            collections.remove(at: index)
        }
    }
    
}

extension DecisionMakerModel {
    func editOptionsToPick(option: Option, toggle: Bool) {
        if toggle {
            addChecked(option)
        } else {
            if checkedOptions.contains(option) {
                removeCheckedOptions(id: option.id)
            }
        }
    }
    
    func addChecked(_ option: Option) {
        checkedOptions.append(option)
    }
    
    func removeCheckedOptions(id: Option.ID){
        let firstIndex = checkedOptions.firstIndex(where: { $0.id == id })!
        checkedOptions.remove(at: firstIndex)
    }
    
    func removeOption(_ i: Int) {
        collection.options.remove(at: i)
        checkedOptions.remove(at: i)
        setCollection(collection)
    }
    
    func addOption(_ title: String) {

        var tempOption = Option(id: "", title: title)
        tempOption.id = tempOption.title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if checkedOptions.contains(tempOption) {
            tempOption.id = "\(tempOption.id)\(idCount)"
            idCount += 1
        }
            
        collection.options.append(tempOption)
        addChecked(tempOption)
        setCollection(collection)
    }
    
}
