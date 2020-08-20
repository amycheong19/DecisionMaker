//
//  DecisionMakerModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation

class DecisionMakerModel: ObservableObject {
    @Published private(set) var checkedOptions = Array<Option.ID>()
    @Published private(set) var collections: [Collection] = []
    @Published private(set) var selectedCollectionID: Collection.ID?
    
    @Published var collection = Collection.restaurants
    
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
        debugPrint(checkedOptions)
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
            if checkedOptions.contains(option.id) {
                removeCheckedOptions(id: option.id)
            }
        }
    }
    
    func addChecked(_ option: Option) {
        checkedOptions.append(option.id)
    }
    
    func removeCheckedOptions(id: Option.ID){
        let firstIndex = checkedOptions.firstIndex(of: id)!
        debugPrint(firstIndex)
        debugPrint(checkedOptions)
        checkedOptions.remove(at: firstIndex)
        debugPrint(checkedOptions)
    }
    
    func removeOption(_ i: Int) {
        collection.options.remove(at: i)
        checkedOptions.remove(at: i)
        setCollection(collection)
    }
    
    func addOption(_ option: Option) {
        collection.options.append(option)
        addChecked(option)
        setCollection(collection)
    }
    
}
