//
//  DecisionMakerModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation

class DecisionMakerModel: ObservableObject {
    @Published private(set) var checkedOptions = Set<Option.ID>()
    @Published private(set) var collections: [Collection] = []
    @Published private(set) var selectedCollectionID: Collection.ID?

//    let defaults = UserDefaults(suiteName: "group.example.decisionmaker")
//
//    private var userCredential: String? {
//        get { defaults?.string(forKey: "DecisionCollections") }
//        set { defaults?.setValue(newValue, forKey: "DecisionCollections") }
//    }
    
    init() {
//        guard let _ = userCredential else { return }
        createCollection()
    }

}

extension DecisionMakerModel {
    
    func selectedCollection() -> Collection? {
        guard let indexSet = collections.firstIndex(where: { $0.id == selectedCollectionID }) else {
            return nil
        }
        return collections[indexSet]
    }
    
    func createCollection(_ collection: Collection? = nil) {
        guard !collections.isEmpty else {
            // initial
            if let jsonCollections = try? Collection.loadJSON(withFilename: "DecisionMakerDatabase") {
                collections.append(contentsOf: jsonCollections)
            }
            return
        }
        
        guard let collection = collection else { return }
        collections.append(collection)
    }
    
    func selectCollection(_ collection: Collection) {
        selectedCollectionID = collection.id
        checkedOptions.removeAll()
        checkedOptions = checkedOptions.union(collection.options.compactMap{ $0.id })
    }
    
    func removeCollection(_ collection: Collection) {
        if let index = collections.firstIndex(of: collection) {
            collections.remove(at: index)
        }
    }
    
    
}

extension DecisionMakerModel {
    func editOptionsToPick(option: Option) {
        if checkedOptions.contains(option.id) {
            removeCheckedOptions(id: option.id)
        } else {
            checkedOptions.insert(option.id)
        }
    }
    
    func removeCheckedOptions(id: Option.ID){
        checkedOptions.remove(id)
    }
    
    
    func removeOption(_ option: Option) {
                
        guard let indexSet = collections.firstIndex(where: { $0.id == selectedCollectionID }) else {
            return
        }
        
        let filteredOptions = collections[indexSet].options.filter { $0.id != option.id }
        collections[indexSet].options = filteredOptions
        selectCollection(collections[indexSet])
        
    }
}
