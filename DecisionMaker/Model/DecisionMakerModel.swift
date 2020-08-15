//
//  DecisionMakerModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation

class DecisionMakerModel: ObservableObject {
    @Published private(set) var checkedOptions = Set<Option.ID>()
    @Published private(set) var collection: Collection?
    
    func editOptionsToPick(option: Option) {
        if checkedOptions.contains(option.id) {
            checkedOptions.remove(option.id)
        } else {
            checkedOptions.insert(option.id)
        }
    }
    
    
    func addOptionsToPick(collection: Collection) {
        checkedOptions.removeAll()
        checkedOptions = checkedOptions.union(collection.options.compactMap{ $0.id })
    }
    
    func removeOption(position: Int) {
        collection?.removeOption(at: position)
    }
    
    func addCollection(position: Int) {
        
    }

}
