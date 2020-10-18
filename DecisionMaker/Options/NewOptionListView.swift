//
//  NewOptionListView.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

struct NewOptionListView: View {
    @EnvironmentObject private var model: DecisionMakerModel
    var collection: Collection
    @State private var editMode = EditMode.inactive
    
    var headerText: String {
        return editMode == .active ? "Edit mode" : "Pickr mode"
    }
    
    var body: some View {
        ZStack {
            Form {
                Section (header: Text(headerText)) {
                    ForEach(collection.options) { option in
                        if editMode == .active {
                            OptionEditRowView(option: .constant(option))
                                
                        } else if editMode == .inactive {
                            // Pickr mode
                            OptionRow(option: .constant(option))
                        }
                    }.animation(nil)
                }
            }
            .id(UUID())
            .padding(.bottom, 80)
            .overlay(bottomBar, alignment: .bottom)
            .navigationBarItems(trailing: EditButton())
            .navigationTitle(collection.title)
            .environment(\.editMode, $editMode)
            .animation(nil)
        }
        
    }
    
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            if self.editMode == .active {
                BottomBarButton(action: addNewOption,
                                title: "Add New Option")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
            } else  {
                // Pickr mode
                BottomBarButton(action: randomSelection,
                                title: "Pickr For Me!")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
            }
            
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    func addNewOption() {
        debugPrint("addNewOption")
    }
    
    func randomSelection() {
        debugPrint("randomSelection")
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
