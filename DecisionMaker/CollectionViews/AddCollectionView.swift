//
//  AddCollectionView.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 6/9/20.
//

import SwiftUI

struct AddCollectionButton: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @State private var text = ""
    @State private var showAlert = false
    @Binding var mode: AlertMode
    
    var body: some View {
        Button(action: add, label: {
            Label("", systemImage: "plus")
        })
        .background(alertControl)
        .accessibility(label: Text("Add Button"))
        
    }
    
    func add() {
        self.showAlert = true
    }
    
    var alertControl: some View {
        AlertControl(textString: self.$text,
                     show: self.$showAlert,
                     mode: $mode,
                     title: "Create Pickr collection",
                     message: "What do you want us to pickr for you? (More than 3 characters)")
        
    }
    
}

struct AddCollectionButton_Previews: PreviewProvider {
    static var previews: some View {
        AddCollectionButton(mode: .constant(.add))
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(DecisionMakerModel())
    }
}

