//
//  RandomPickButton.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

struct RandomPickButton: View {
    var action: () -> Void
    var height: CGFloat {
        return 45
    }
    
    var body: some View {
        Button(action: action) {
            Text("Pick For Me!")
                .font(Font.headline.bold())
                .frame(height: height)
                .frame(minWidth: 100, maxWidth: 400)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .contentShape(Rectangle())
        }
        .buttonStyle(SquishableButtonStyle())
    }
}

struct RandomPickButton_Previews: PreviewProvider {
    static var previews: some View {
        RandomPickButton(action: {})
            .frame(width: 300)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
