//
//  OptionRow.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI
import UIKit

struct OptionRow: View {
    @Binding var option: Option
    @EnvironmentObject private var model: DecisionMakerModel
    @State private var checked = true

    var body: some View {
        
        Button(action: {
            checked.toggle()
            model.editOptionsToPick(option: option, toggle: checked)
        }) {
            HStack {
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
                
                VStack(alignment: .leading) {
                    Text(option.title)
                        .font(.headline)
                        .lineLimit(nil)
                    Text("Pickr-ed \(option.picked) time\(option.pluralizer)")
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }
                .padding(.vertical, 8.0)
                
                Spacer()
                
                Toggle("Complete", isOn: $checked)
            }
            .contentShape(Rectangle())
            .font(.subheadline)
            .frame(height: 96)
            .accessibilityElement(children: .combine)
            
        }
        .buttonStyle(PlainButtonStyle())
        .toggleStyle(CircleToggleStyle())
    }
}

struct OptionRow_Previews: PreviewProvider {
    static var previews: some View {
        OptionRow(option: .constant(.macdonald))
            .environmentObject(DecisionMakerModel())
    }
}
