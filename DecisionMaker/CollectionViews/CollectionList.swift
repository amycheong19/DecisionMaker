//
//  CollectionList.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct CollectionList: View {
    var collections: [Collection]
    @State private var editMode = EditMode.inactive
    @EnvironmentObject private var model: DecisionMakerModel
    @State private var selection: Collection?
    @State var tempTitle: String = ""
    @State private var showAlert = false
    
    var body: some View {
        
        Form {
            Section(header: Text("The more options to pickr, the merrier! ☀️"),
                    footer: Text("Decision making, like coffee, \nneeds cooling process - George Washington ☕️")){

                ForEach(model.collections) { collection in
//                    let collection = model.collections[index]
                    
                    if self.editMode == .active {
                        Text(collection.title)
                            .onTapGesture {
                                showAlert.toggle()
                                tempTitle = collection.title
                                model.selectCollection(collection)
                            }
                    } else  {
                        NavigationLink(
                            destination:
                                NewOptionListView(collection: collection),
                            tag: collection,
                            selection: $selection) {
                            CollectionRow(collection: .constant(collection))
                        }
//                        .accessibility(identifier: AI.CollectionListView.collection(at: index))
                    }
                }
                .onDelete(perform: deleteCollection)
            }
            
        }.onAppear{
            AnalyticsManager.shared.track(event: "Collection List View",
                                          properties: AnalyticsManager.setCollectionCount(collections: collections))
        }
        .background(alertControl)
        .navigationBarItems(leading: EditButton()
                                .accessibility(identifier: AI.CollectionListView.editButton),
                            trailing: AddCollectionButton(mode: .constant(.add)))
        .environment(\.editMode, $editMode)
    }
    
    func deleteCollection(indexSet: IndexSet){
        indexSet.forEach{
            HapticGenerator.changedNotification()
            model.removeCollection($0)
        }
    }
    
    var alertControl: some View {
        AlertControl(textString: $tempTitle,
                     show: $showAlert,
                     mode: .constant(.edit),
                     title: "Edit Pickr Collection",
                     message: "What do you want us to pickr for you?")
    }
}



struct CollectionList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CollectionList(collections: Collection.all)
                .navigationTitle("Collection")
                .environmentObject(DecisionMakerModel())
        }
        
    }
}

