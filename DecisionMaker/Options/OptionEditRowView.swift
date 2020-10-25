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
    @ObservedObject var rowModel: OptionEditRowViewModel
    @State private var checked = true
    @Binding var state: OptionListState
    
    
    var onCommit: (Result<Option, InputError>) -> Void = { _ in }
    
    private func returnCommitStatus() {
        
        if !rowModel.searchText.isEmpty {
            if rowModel.option.title.isEmpty {
                rowModel.option.title = rowModel.searchText
            }
            self.onCommit(.success(rowModel.option))
        } else {
            self.onCommit(.failure(.empty))
        }
    }
    
    
    var body: some View {
        
        HStack {
            Button(action: {
                checked.toggle()
                let impactLight = UIImpactFeedbackGenerator(style: .light)
                impactLight.impactOccurred()
                model.editOptionsToPick(option: rowModel.option, toggle: checked)
            }) {
                Toggle("Complete", isOn: $checked)
                    .frame(width: 40)
            }.onAppear {
                checked = model.isChecked(option: rowModel.option)
            }
            .onChange(of: model.checkedOptions) { value in
                debugPrint("onChange: \(value)")
                checked = model.isChecked(option: rowModel.option)
            }
            .disabled(state == .new)
            .buttonStyle(PlainButtonStyle())
            .toggleStyle(CircleToggleStyle())

            
            // New option
            if let origin = rowModel.option.origin {
                if let urlString = origin.urls.regular,
                   let url = URL(string: urlString) {
                    URLImage(url,
                             expireAfter: Date(timeIntervalSinceNow: 31_556_926.0)) { proxy in
                        proxy.image.listThumbnailStyle
                    }
                }
            }
            
            VStack(alignment: .leading) {
                
                if rowModel.option.id.isEmpty {
                    TextField("New option",
                              text: $rowModel.searchText,
                              onCommit: {
                                returnCommitStatus()
                              }).introspectTextField(customize: { (textfield) in
                                textfield.returnKeyType = .done
                                textfield.becomeFirstResponder()
                              })
                        .accessibility(identifier: AI.OptionRowView.newOptionTextField)
                        .disableAutocorrection(true)
                        .font(.headline)
                        .modifier(ClearButton(text: $rowModel.searchText))
                        .onChange(of: rowModel.searchText) { value in
                            rowModel.debounceText()
                        }
                } else {
                    Text(rowModel.option.title)
                            .font(.headline)
                            .lineLimit(nil)
                    
                    HStack{
                        Text("Pickr-ed")
                            .foregroundColor(.secondary)
                        Text("\(rowModel.option.picked) time\(rowModel.option.pluralizer)")
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                    }
                    
                }
                
                // Add Unsplash user link
                if let origin = rowModel.option.origin,
                   let user = origin.user {
                    HStack(spacing: 0) {
                        Text("Photo by")
                            .foregroundColor(.secondary)
                            .font(.caption2)
                        
                        Text(" \(user.name ?? "Annonymous")")
                            .foregroundColor(.pinkG)
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
        
    }
}

struct OptionEditRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            OptionEditRowView(rowModel: OptionEditRowViewModel(option: .macdonald), state: .constant(.new))
        }
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
        .environmentObject(DecisionMakerModel())
        
    }
}
