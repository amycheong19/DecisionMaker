//
//  AddOptionButton.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct AddOptionButton: View {
    @State private var isPresented = false
    @EnvironmentObject private var model: DecisionMakerModel

    
    var body: some View {
        Button(action: addOption, label: {
            Label("", systemImage: "plus")
        })
        .fullScreenCover(isPresented: $isPresented, content: {
            NewOptionView().environmentObject(model)
        })
        .accessibility(label: Text("Add Button"))
        
    }

    func addOption(){
        isPresented = true
    }
}

struct AddOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        AddOptionButton()
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(DecisionMakerModel())
    }
}
