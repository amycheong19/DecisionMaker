//
//  OptionEditRowView.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

enum InputError: Error {
    case empty
}

struct OptionEditRowView: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @ObservedObject var tfModel: NewTextFieldModel
    @State private var checked = true
    @State var isFirstResponder = false
    
    var onCommit: (Result<Option, InputError>) -> Void = { _ in }
    
    private func returnCommitStatus() {
        if !tfModel.searchText.isEmpty {
            self.onCommit(.success(tfModel.option))
        } else if !tfModel.option.title.isEmpty {
            self.onCommit(.success(tfModel.option))
        }else {
            self.onCommit(.failure(.empty))
        }
    }
    
    
    var body: some View {
        
        HStack {
            Button(action: {
                checked.toggle()
                model.editOptionsToPick(option: tfModel.option, toggle: checked)
            }) {
                Toggle("Complete", isOn: $checked)
                    .frame(width: 40)
                
            }.onChange(of: model.checkedOptions, perform: { value in
                checked = model.isChecked(option: tfModel.option)
                debugPrint("ON CHANGE: \(value) \(checked)")
            })
            .buttonStyle(PlainButtonStyle())
            .toggleStyle(CircleToggleStyle())
            
            
            // New option
            if let origin = tfModel.option.origin {
                if let urlString = origin.urls.regular,
                   let url = URL(string: urlString) {
                    URLImage(url,
                             expireAfter: Date(timeIntervalSinceNow: 31_556_926.0)) { proxy in
                        proxy.image.listThumbnailStyle
                    }
                    
                }
            } else {
                Image("placeholder").listThumbnailStyle
            }
            
            VStack(alignment: .leading) {
                
                TextField("New option",
                          text: $tfModel.searchText,
                          onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                print("TextField focused")
                            } else {
                                print("TextField focus removed")
                                returnCommitStatus()
                                
                            }
                          },
                          onCommit: {
                            
                            returnCommitStatus()
                          })
                    .font(.headline)
//                    .onAppear {
//                        tfModel.searchText = option.title
//                    }
                    .modifier(ClearButton(text: $tfModel.searchText))
                    .onChange(of: tfModel.searchText) { value in
                        tfModel.debounceText()
                    }
                
                // Add Unsplash user link
                if let origin = tfModel.option.origin,
                   let user = origin.user {
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
                    }
                }
            }
            .padding(.vertical, 8.0)
            
            Spacer()
            
        }
        .frame(height: 96)
        .contentShape(Rectangle())
        .font(.subheadline)
        .accessibilityElement(children: .combine)
        
    }
}

//struct OptionEditRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        Group {
//            OptionEditRowView(tfModel: NewTextFieldModel(option: .macdonald),
//                              checked: true)
//        }
//        .padding(.horizontal)
//        .previewLayout(.sizeThatFits)
//        .environmentObject(DecisionMakerModel())
//        
//    }
//}
