//
//  NewOptionListView.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

enum OptionListState {
    case new
    case existing
}

struct NewOptionListView: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @ObservedObject var alertModel = AlertModel()
    @Namespace private var namespace
    
    //States
    @State private var editMode = EditMode.inactive
    @State var presentAddNewItem = false
    @State var selectedID: String?
    @State var state: OptionListState = .existing
    
    var collection: Collection
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BottomBarButton(action: randomSelection,
                                title: state == .new ? "Adding new option": "Pickr For Me!")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 5)
                    .disabled(disablePick)
                    .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
                    .accessibility(identifier: AI.OptionListView.pickrButton)
                
                List {
                    ForEach(model.collection.options.indices, id: \.self) { index in
                        let option = model.collection.options[index]
                        OptionEditRowView(rowModel: OptionEditRowViewModel(option: option, index: index), state: $state) {
                            result in
                            switch result {
                            case .success(let option):
                                state = .existing
                                model.editOption(with: option)
                            default: break
                            }
                        }.accessibility(identifier: AI.OptionListView.option(at: index))
                    }
                    .onDelete(perform: deleteOption)
                    
                    // When user press on new option
                    if presentAddNewItem {
                        // Only for newly add option
                        OptionEditRowView(rowModel: OptionEditRowViewModel(index: model.collection.options.count), state: $state) { result in
                            switch result {
                            case .success(let option):
                                debugPrint(option)
                                model.addOption(with: option)
                            default: break
                            }
                            state = .existing
                            self.presentAddNewItem.toggle()
                        }
                    }
                }.onAppear() {
                    model.selectCollection(collection)
                    AnalyticsManager.shared.track(event: "Option List View")
                }
                
                // Add Button
                Button(action: addNewOption) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("New Option")
                    }
                    
                }
                .accessibility(identifier: AI.OptionListView.newOptionButton)
                .padding()
                .accentColor(.pinkG)
                
            }
            .navigationBarTitle(collection.title)
            
            
            // Picked Card
            if let randomOption = randomOptions(), alertModel.flag {
                
                if let _ = randomOption.origin {
                    VisualEffectBlur()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(alertModel.flag ? 1 : 0)
                    
                    PickedCard(option: randomOption, presenting: alertModel.flag,
                               closeAction: deselectIngredient)
                        .matchedGeometryEffect(id: randomOption.id, in: namespace,
                                               isSource: alertModel.flag)
                        .aspectRatio(0.75, contentMode: .fit)
                        .shadow(color: Color.black.opacity(alertModel.flag ? 0.2 : 0),
                                radius: 20, y: 10)
                        .padding(20)
                        .opacity(alertModel.flag ? 1 : 0)
                        .zIndex(alertModel.flag ? 1 : 0)
                    
                } else {
                    VStack{
                        
                    }.alert(isPresented: $alertModel.flag, content: {
                        Alert(title: Text("Pickr this for you"),
                              message: Text(randomOption.title),
                              dismissButton: .default(Text("OK")) {
                                model.addOptionPickedCount(optionID: randomOption.id)
                            })
                    })
                }
            }
        }
    }
    
    private func addNewOption() {
        presentAddNewItem.toggle()
        state = presentAddNewItem ? .new : .existing

    }
    
    private func randomSelection() {
        alertModel.flag = true
    }
    
    private func randomOptions() -> Option? {
        guard let option = model.checkedOptions.randomElement() else { return nil }
        DispatchQueue.main.async {
            selectedID = option.id
        }
        AnalyticsManager.shared.track(event: "Selected option", properties: AnalyticsManager.setOption(option: option))
        
        return option
    }
    
    private func deselectIngredient() {
        alertModel.flag = false
        if let selectedID = selectedID {
            model.addOptionPickedCount(optionID: selectedID)
        }
    }
    
    private var disablePick: Bool {
        return model.collection.options.count < 1 || model.checkedOptions.count < 1 || state == .new
    }
    
    private func deleteOption(indexSet: IndexSet){
        indexSet.forEach{
            model.removeOption($0)
        }
    }
}

struct NewOptionListView_Previews: PreviewProvider {
    static let dataStore: DecisionMakerModel = {
        var dataStore = DecisionMakerModel()
        dataStore.selectCollection(.restaurants)
        return dataStore
    }()
    
    static var previews: some View {
        NavigationView{
            NewOptionListView(collection: .restaurants)
                .navigationTitle("Restaurant")
                .environmentObject(dataStore)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
