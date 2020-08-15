//
//  AddOptionButton.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct AddOptionButton: View {
    @EnvironmentObject private var model: DecisionMakerModel
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Label("Add", systemImage: "plus")
        })
        .accessibility(label: Text("Add Option Button"))
        
    }

}

struct AddOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        AddOptionButton(action: {})
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(DecisionMakerModel())
    }
}
