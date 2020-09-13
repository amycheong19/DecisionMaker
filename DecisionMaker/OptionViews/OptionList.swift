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
    
    @ObservedObject var alertModel = AlertModel()
    
    var body: some View {
        List {
            ForEach(model.collection.options){
                OptionRow(option: .constant($0))
            }
            .onDelete(perform: deleteOption)
        }
        .onAppear() {
            model.selectCollection(collection)
        }
        .alert(isPresented: $alertModel.flag) {
            guard let randomOption = model.checkedOptions.randomElement(), model.checkedOptions.count > 1 else {
                return Alert(
                   title: Text("No option is selected"),
                   message: Text("Select at least two"),
                   dismissButton: .default(Text("OK"))
               )
            }

            return
                Alert(title: Text("We have PICKED for you!"), message: Text("Are you going to choose \(randomOption.title)?"),
                    primaryButton: Alert.Button.default(Text("Yes, I 'll follow!"), action: {
                        model.edit(option: randomOption)
                        alertModel.flag = false
                    }),
                    secondaryButton: Alert.Button.destructive(Text("No, I have second thought"), action: {
                        alertModel.flag = false
                    })
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
        alertModel.flag = true
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

class AlertModel: ObservableObject {
    @Published var flag = false
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
