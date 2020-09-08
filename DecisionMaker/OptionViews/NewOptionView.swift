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
    
    
    var body: some View {
        
        NavigationView(content: {
            Form{
                Section {
                    TextField("Title", text: $tfModel.searchText)
                        .modifier(ClearButton(text: $tfModel.searchText))
                        .onChange(of: tfModel.searchText) { value in
                            tfModel.debounceText()
                        }
                    
                    
                    if let searched = tfModel.searchedPhoto,
                       let url = URL(string: searched.urls.thumb), let user = searched.user {
                        URLImage(url, placeholder: Image(systemName: "circle"))

                        HStack(spacing: 0) {
                            Text("Photo by")
                                .foregroundColor(.secondary)
                                .font(.caption2)

                            Text(" \(user.name)")
                                .foregroundColor(.blue)
                                .font(.caption2)
                                .underline()
                                .onTapGesture {
                                    let url = URL(string: "https://unsplash.com/@\(user.username)?utm_source=your_app_name&utm_medium=referral")
                                    guard let websiteURL = url, UIApplication.shared.canOpenURL(websiteURL)
                                    else { return }
                                    UIApplication.shared.open(websiteURL)
                                }
                            
                            Text(" / ")
                                .foregroundColor(.secondary)
                                .font(.caption2)

                            Text("Unsplash")
                                .foregroundColor(.blue)
                                .font(.caption2)
                                .underline()
                                .onTapGesture {
                                    let url = URL(string: "https://unsplash.com/?utm_source=Pickr&utm_medium=referral")
                                    guard let websiteURL = url, UIApplication.shared.canOpenURL(websiteURL)
                                    else { return }
                                    UIApplication.shared.open(websiteURL)
                                }
                        }
                        
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
        tfModel.searchText.isEmpty || tfModel.searchText.count < 2
    }
    
    func createNewOption() {
        model.addOption(with: tfModel.searchText,
                        imageString: tfModel.searchedPhoto?.urls.thumb)
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
