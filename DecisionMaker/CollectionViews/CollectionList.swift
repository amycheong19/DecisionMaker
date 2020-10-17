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
        
        Form{
            ForEach(model.collections) { collection in
                if self.editMode == .active {
                    Text(collection.title)
                        .onTapGesture {
                            showAlert.toggle()
                            tempTitle = collection.title
                            model.selectCollection(collection)
                        }
                        
                } else  {
                    NavigationLink(
                        destination: OptionList(collection: collection),
                        tag: collection,
                        selection: $selection) {
                        CollectionRow(collection: .constant(collection))
                    }
                }
            }
            .onDelete(perform: deleteCollection)
        }
        .background(alertControl)
        .navigationBarItems(leading: EditButton(),
                            trailing: AddCollectionButton(mode: .constant(.add)))
        .environment(\.editMode, $editMode)
    }
    
    func deleteCollection(indexSet: IndexSet){
        indexSet.forEach{
            model.removeCollection($0)
        }
    }
    
    var alertControl: some View {
        AlertControl(textString: $tempTitle,
                     show: $showAlert,
                     mode: .constant(.edit),
                     title: "Edit Collection Name",
                     message: "What do you want us to pickr for you? (More than 3 characters)")
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

