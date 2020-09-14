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
    let ciContext = CIContext()

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
                       let url = URL(string: searched.urls.thumb),
                       let user = searched.user {

                        URLImage(url,
                                 placeholder: {
                                    ProgressView($0) { progress in
                                        ZStack {
                                            if progress > 0.0 {
                                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                                            }
                                            else {
                                                CircleActivityView().stroke(lineWidth: 50.0)
                                            }
                                        }
                                    }
                                    .frame(width: 50.0, height: 50.0)
                                 },
                                 content: {
                                    $0.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: metrics.thumbnailSize, height: metrics.thumbnailSize)
                                        .shadow(radius: 10.0)
                                        .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius))
                                 })
                        
                        HStack(spacing: 0) {
                            Text("Photo by")
                                .foregroundColor(.secondary)
                                .font(.caption2)

                            Text(" \(user.name ?? "Annonymous")")
                                .foregroundColor(.blue)
                                .font(.caption2)
                                .underline()
                                .onTapGesture {
                                    
                                    guard let username = user.username,
                                          let url = URL(string: "https://unsplash.com/@\(username)?utm_source=your_app_name&utm_medium=referral"),
                                          UIApplication.shared.canOpenURL(url)
                                    else { return }
                                    
                                    UIApplication.shared.open(url)
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
    
    var metrics: Metrics {
        return Metrics(thumbnailSize: 200, cornerRadius: 16, rowPadding: 0, textPadding: 8)
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
