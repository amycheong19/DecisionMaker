//
//  RandomPickButton.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct BottomBarButton: View {
    var action: () -> Void
    var height: CGFloat {
        return 35
    }
    
    var title: String
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.headline.bold())
                .frame(height: height)
                .frame(minWidth: 100, maxWidth: 400)
                .foregroundColor(.white)
                .background(Color.primaryGradientColor)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RandomPickButton_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarButton(action: {}, title: "Pick for Me!")
            .frame(width: 300)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
