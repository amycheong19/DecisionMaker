//
//  CollectionRow.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct CollectionRow: View {
    var collection: Collection
    
    var metrics: Metrics {
        return Metrics(cornerRadius: 16, rowPadding: 0, textPadding: 8)
    }
    
    var pluralizer: String { collection.options.count == 1 ? "" : "s" }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(collection.title)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(collection.options.count) option\(pluralizer)")
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, metrics.textPadding)
            
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
    
    struct Metrics {
        var cornerRadius: CGFloat
        var rowPadding: CGFloat
        var textPadding: CGFloat
    }


}

struct CollectionRow_Previews: PreviewProvider {
    static var previews: some View {
        CollectionRow(collection: .restaurants)
    }
}
