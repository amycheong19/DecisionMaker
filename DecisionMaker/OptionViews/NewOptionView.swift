//
//  NewOptionView.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 26/8/20.
//

import SwiftUI
import Combine

struct NewOptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var model: DecisionMakerModel
    @ObservedObject  private var tfModel = TextFieldModel()
    
    @State private var title = ""
    
    var body: some View {
        
        NavigationView(content: {
            Form{
                Section {
                    TextField("Title", text: $title).modifier(ClearButton(text: $title))

                    TextField("Image Search (Optional)", text: $tfModel.searchText)
                        .onChange(of: tfModel.searchText) { value in
                            tfModel.debounceText()
                        }
                    if let url = tfModel.searchURL {
                        URLImage(url, placeholder: Image(systemName: "circle"))
                    }
                }
            }
            .navigationBarTitle("New Option")
            .navigationBarItems(trailing: closeButton)
            .padding(.bottom, 30)
            .overlay(bottomBar, alignment: .bottom)
        })
        
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            Group {
                BottomBarButton(action: createNewOption,
                                title: "Create New")
                    .disabled(disableForm)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    private var closeButton: some View {
        return Button(action: dismissView) {
            Image(systemName: "xmark")
                .frame(height: 36)
        }
    }
    
    var disableForm: Bool {
        title.isEmpty || title.count < 3
    }
    
    func createNewOption() {
        model.addOption(with: title,
                        imageString: tfModel.searchURL?.absoluteString)
        dismissView()
    }
    
    func dismissView(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewOptionView_Previews: PreviewProvider {
    static var previews: some View {
        NewOptionView()
    }
}
