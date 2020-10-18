//
//  OptionEditRowView.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

struct OptionEditRowView: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @ObservedObject  private var tfModel = TextFieldModel()
    
    @State private var checked = true
    @Binding var option: Option
    
    
    var body: some View {
//        Button(action: {
//            checked.toggle()
//            model.editOptionsToPick(option: option, toggle: checked)
//        }) {
            HStack {
//                // New option
//                if let searched = tfModel.searchedPhoto,
//                   let url = URL(string: searched.urls.regular),
//                   let user = searched.user {
//
//                    URLImage(url,
//                             placeholder: {
//                                ProgressView($0) { progress in
//                                    ZStack {
//                                        if progress > 0.0 {
//                                            CircleProgressView(progress).stroke(lineWidth: 8.0)
//                                        }
//                                        else {
//                                            CircleActivityView().stroke(lineWidth: 50.0)
//                                        }
//                                    }
//                                }
//                                .frame(width: 50.0, height: 50.0)
//                             },
//                             content: {
//                                $0.image.listThumbnailStyle
//                             })
//                } else {
                    // Existing option
                if let urlString = option.origin?.urls.regular, let url = URL(string: urlString) {
                    URLImage(url,
                             expireAfter: Date(timeIntervalSinceNow: 31_556_926.0)) { proxy in
                        proxy.image
                            .listThumbnailStyle
                    }

                } else {

                    if let uiImage = UIImage(named: option.id) ?? UIImage(named: "placeholder") {
                        Image(uiImage: uiImage)
                            .listThumbnailStyle
                    }
                    
                }
//                }
                
                
                VStack(alignment: .leading) {
                    TextField("New option",
                              text: $tfModel.searchText)
                        .font(.headline)
                        .onAppear {
                            tfModel.searchText = option.title
                        }
                        .modifier(ClearButton(text: $tfModel.searchText))
                        .onChange(of: tfModel.searchText) { value in
                            tfModel.debounceText()
                        }
                }
                .padding(.vertical, 8.0)
                
                Spacer()
                
            }
            .frame(height: 96)
            .contentShape(Rectangle())
            .font(.subheadline)
            .accessibilityElement(children: .combine)
            .animation(nil)
            
//        }
//        .animation(nil)
//        .buttonStyle(PlainButtonStyle())
//        .toggleStyle(CircleToggleStyle())

        
    }
}

struct OptionEditRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            OptionEditRowView(option: .constant(.macdonald))
            OptionEditRowView(option: .constant(.burgerKing))
        }
        .frame(width: 250, alignment: .leading)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
        .environmentObject(DecisionMakerModel())
        
        
    }
}
