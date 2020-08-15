//
//  OptionList.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI

struct OptionList: View {
    @EnvironmentObject private var model: DecisionMakerModel

    var collection: Collection
    @State private var presentingAddAlert = false
    @State private var presentingRandomAlert = false
    
    var checkedOptions: [Option] {
        model.checkedOptions.map { Option(for: $0)! }
    }

    
    var body: some View {
        
        List {
            ForEach(collection.options, id: \.id){ option in
                OptionRow(option: option)
            }
            .onDelete(perform: deleteOption)
        }
        .alert(isPresented: $presentingAddAlert) {
            
            Alert(
                title: Text("Payments Disabled"),
                message: Text("The Fruta QR code was scanned too far from the shop, payments are disabled for your protection."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $presentingRandomAlert) {
            guard let randomOptions = checkedOptions.randomElement() else {
                return Alert(
                   title: Text("No option is selected"),
                   message: Text("Select at least one"),
                   dismissButton: .default(Text("OK"))
               )
            }
            
            return Alert(
                title: Text("Selected"),
                message: Text("\(randomOptions.title)"),
                dismissButton: .default(Text("OK"))
            )
        }
        
        .overlay(bottomBar, alignment: .bottom)
        .navigationBarItems(trailing: AddOptionButton(action: addOption))
        .navigationTitle(collection.title)
        
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            Group {
                RandomPickButton(action: randomSelection)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    func randomSelection() {
        presentingRandomAlert = true
    }
    
    func addOption(){
        presentingAddAlert = true
    }
    
    func deleteOption(indexSet: IndexSet){
        
        indexSet.forEach { i in
            let option = collection.options[i]
            model.editOptionsToPick(option: option)
        }

    }
}



struct OptionList_Previews: PreviewProvider {
    static let dataStore: DecisionMakerModel = {
        var dataStore = DecisionMakerModel()
        dataStore.addOptionsToPick(collection: .restaurants)
        return dataStore
    }()
    
    static var previews: some View {
        NavigationView{
            OptionList(collection: .restaurants)
                .navigationTitle("Restaurant")
                .environmentObject(dataStore)
        }
    }
}
