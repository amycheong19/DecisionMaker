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
    
    var metrics: Metrics {
        return Metrics(thumbnailSize: 96, cornerRadius: 16, rowPadding: 0, textPadding: 8)
    }
    
    var body: some View {
        
        Button(action: {
            checked.toggle()
            model.editOptionsToPick(option: option, toggle: checked)
        }) {
            HStack {
                if let urlString = option.origin?.urls.regular, let url = URL(string: urlString) {
                    URLImage(url, expireAfter: Date(timeIntervalSinceNow: 31_556_926.0)) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: metrics.thumbnailSize, height: metrics.thumbnailSize)
                            .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius))
                            .accessibility(hidden: true)
                    }
                } else {

                    if let uiImage = UIImage(named: option.id) ?? UIImage(named: "placeholder") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: metrics.thumbnailSize, height: metrics.thumbnailSize)
                            .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous))
                            .accessibility(hidden: true)
                    }
                    
                }
                
                VStack(alignment: .leading) {
                    Text(option.title)
                        .font(.headline)
                        .lineLimit(nil)
                    Text("Pickr for \(option.picked) time\(option.pluralizer)")
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }.padding(.vertical, metrics.textPadding)
                
                Spacer()
                
                Toggle("Complete", isOn: $checked)
            }
            .contentShape(Rectangle())
            .font(.subheadline)
            .padding(.vertical, metrics.rowPadding)
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