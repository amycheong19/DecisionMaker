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
    
    @State private var presentingRandomAlert = false
    
    var checkedOptions: [Option] {
         return model.checkedOptions
    }

    
    var body: some View {
        List {
            ForEach(model.collection.options){
                
                OptionRow(option: $0)
            }
            .onDelete(perform: deleteOption)
        }
        .onAppear() {
            model.selectCollection(collection)
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
        .padding(.bottom, 30)
        .overlay(bottomBar, alignment: .bottom)
        .navigationBarItems(trailing: AddOptionButton())
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
    

    
    func deleteOption(indexSet: IndexSet){
        indexSet.forEach{
            model.removeOption($0)
        }
    }
}



struct OptionList_Previews: PreviewProvider {
    static let dataStore: DecisionMakerModel = {
        var dataStore = DecisionMakerModel()
        dataStore.selectCollection(.restaurants)
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
