//
//  AddOptionButton.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct AddOptionButton: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @State private var presentingAddAlert = false
    
    var body: some View {
        Button(action: addOption, label: {
            Label("Add", systemImage: "plus")
        })
        .alert(isPresented: $presentingAddAlert) {
            Alert(
                title: Text("Payments Disabled"),
                message: Text("The Fruta QR code was scanned too far from the shop, payments are disabled for your protection."),
                dismissButton: .default(Text("OK"))
            )
        }
        .accessibility(label: Text("Add Option Button"))
        
    }

    func addOption(){
        presentingAddAlert = true
        model.addOption(Option.pizzaHut)
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
