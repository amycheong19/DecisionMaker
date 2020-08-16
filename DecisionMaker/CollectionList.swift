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
            ForEach(collections) { collection in
                NavigationLink(
                    destination: OptionList(collection: collection),
                    tag: collection,
                    selection: $selection) {
                    CollectionRow(collection: collection)
                }
            }
        }
//        .navigationBarItems(trailing: AddOptionButton())

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

