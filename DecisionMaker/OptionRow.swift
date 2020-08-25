//
//  OptionRow.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct OptionRow: View {
    var option: Option

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
                option.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: metrics.thumbnailSize, height: metrics.thumbnailSize)
                    .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius))
                    .accessibility(hidden: true)

                VStack(alignment: .leading) {
                    Text(option.title)
                        .font(.headline)
                        .lineLimit(1)
                    Text("Last updated: 12 July 2020")
                        .foregroundColor(.secondary)
                        .lineLimit(1)
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
    
    struct Metrics {
        var thumbnailSize: CGFloat
        var cornerRadius: CGFloat
        var rowPadding: CGFloat
        var textPadding: CGFloat
    }
}

struct OptionRow_Previews: PreviewProvider {
    static var previews: some View {
        OptionRow(option: .macdonald)
            .environmentObject(DecisionMakerModel())
    }
}
