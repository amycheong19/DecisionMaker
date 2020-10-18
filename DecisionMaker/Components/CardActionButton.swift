//
//  CardActionButton.swift
//  Pickr
//
//  Created by Amy Cheong on 16/9/20.
//

import Foundation
import SwiftUI

struct CardActionButton: View {
    var label: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(Font.title.bold())
                .imageScale(.large)
                .frame(width: 44, height: 44)
                .padding()
                .contentShape(Rectangle())
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
        .accessibility(label: Text(label))
    }
}

struct CardActionButton_Previews: PreviewProvider {
    static var previews: some View {
        CardActionButton(label: "Close", systemImage: "xmark", action: {})
            .previewLayout(.sizeThatFits)
    }
}
