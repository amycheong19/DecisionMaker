//
//  NewOptionListView.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

struct NewOptionListView: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @ObservedObject var alertModel = AlertModel()
    @Namespace private var namespace

    //States
    @State private var editMode = EditMode.inactive
    @State var presentAddNewItem = false
    @State var selectedID: String?
    
    var collection: Collection
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BottomBarButton(action: randomSelection,
                                title: "Pickr For Me!")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 5)
                    .disabled(disablePick)
                    .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
                
             
                List {
                    ForEach (model.collection.options) { option in
                        OptionEditRowView(tfModel: NewTextFieldModel(option: option)) {
                            result in
                            switch result {
                            case .success(let option):
                                model.editOption(with: option)
                            default:
                                debugPrint(result)
                            }

                        }
                    }
                    .onDelete(perform: deleteOption)

                    // When user press on new option
                    if presentAddNewItem {
                        // Only for newly add option
                        OptionEditRowView(tfModel: NewTextFieldModel()) { result in
                            switch result {
                            case .success(let option):
                                debugPrint(option)
                                model.addOption(with: option)
                            default:
                                debugPrint(result)
                            }
                            self.presentAddNewItem.toggle()
                        }
                    }
                }.onAppear() {
                    model.selectCollection(collection)
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
                .padding()
                .accentColor(Color(UIColor.systemRed))
                
            }
            .navigationBarTitle(collection.title)
            
            // Picked Card
            VisualEffectBlur()
                .edgesIgnoringSafeArea(.all)
                .opacity(alertModel.flag ? 1 : 0)
            
                if let randomOption = randomOptions(), alertModel.flag {
                    PickedCard(option: randomOption, presenting: alertModel.flag, closeAction: deselectIngredient)
                        .matchedGeometryEffect(id: randomOption.id, in: namespace, isSource: alertModel.flag)
                        .aspectRatio(0.75, contentMode: .fit)
                        .shadow(color: Color.black.opacity(alertModel.flag ? 0.2 : 0), radius: 20, y: 10)
                        .padding(20)
                        .opacity(alertModel.flag ? 1 : 0)
                        .zIndex(alertModel.flag ? 1 : 0)

                }
        }
        
        
        
    }
    
    
    
    
    private func addNewOption() {
        debugPrint("addNewOption")
        presentAddNewItem.toggle()
    }
    
    private func randomSelection() {
        UIApplication.shared.endEditing()
        alertModel.flag = true
    }
    
    private func randomOptions() -> Option? {
        guard let option = model.checkedOptions.randomElement() else { return nil }
        DispatchQueue.main.async {
            selectedID = option.id
        }
        return option
    }
    
    private func deselectIngredient() {
        withAnimation(.closeCard) {
            alertModel.flag = false
            model.addOptionPickedCount(optionID: selectedID ?? "")
        }
    }
    
    private var disablePick: Bool {
        return model.collection.options.count < 1 || model.checkedOptions.count < 1
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
