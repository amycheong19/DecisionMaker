//
//  CollectionList.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct CollectionList: View {
    var collections: [Collection]
    
    @EnvironmentObject private var model: DecisionMakerModel
    @State private var selection: Collection?
    var body: some View {
        
        List(selection: $selection) {
            ForEach(model.collections) { collection in
                NavigationLink(
                    destination: OptionList(collection: collection),
                    tag: collection,
                    selection: $selection) {
                    CollectionRow(collection: .constant(collection))
                }
            }.onDelete(perform: deleteCollection)
        }
        .navigationBarItems(trailing: AddCollectionButton())
    }
    
    func deleteCollection(indexSet: IndexSet){
        indexSet.forEach{
            model.removeCollection($0)
        }
    }
}

struct CollectionList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CollectionList(collections: Collection.all)
                .navigationTitle("Collection")
                .environmentObject(DecisionMakerModel())
        }
        
    }
}

