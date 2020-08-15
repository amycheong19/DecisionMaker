//
//  Menu.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI

struct Menu: View {
    
    var body: some View {
        CollectionList(collections: Collection.all)
            .navigationTitle("Collections")
    }
}

struct OptionCollection_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
            .environmentObject(DecisionMakerModel())
    }
}
