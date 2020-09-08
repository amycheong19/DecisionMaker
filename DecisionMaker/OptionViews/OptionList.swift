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
            guard let randomOption = model.checkedOptions.randomElement(), model.checkedOptions.count > 1 else {
                return Alert(
                   title: Text("No option is selected"),
                   message: Text("Select at least two"),
                   dismissButton: .default(Text("OK"))
               )
            }

            return Alert(
                title: Text("Selected"),
                message: Text("\(randomOption.title)"),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding(.bottom, 80)
        .overlay(bottomBar, alignment: .bottom)
        .navigationBarItems(trailing: AddOptionButton())
        .navigationTitle(collection.title)
        
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            Group {
                BottomBarButton(action: randomSelection,
                                title: "Pick For Me!")
                    .disabled(disablePick)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    func randomSelection() {
        presentingRandomAlert = true
    }

    var disablePick: Bool {
        return model.collection.options.count < 1
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