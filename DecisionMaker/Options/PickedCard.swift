//
//  PickedCard.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

struct PickedCard: View {
    var option: Option
    var presenting: Bool
    var closeAction: () -> Void = {}
    
    @State private var like: Bool = false
    @State private var dislike: Bool = false
    
    private var hasVoted: Bool {
        debugPrint("hasVoted? \(like || dislike)")
        return like || dislike
    }
    
    @State private var visibleSide = FlipViewSide.front
    
    var body: some View {
        FlipView(visibleSide: visibleSide) {
            FlipCardGraphic(option: option, style: presenting ? .cardFront : .thumbnail, closeAction: closeAction,
                            flipAction: flipCard)
        } back: {
            FlipCardGraphic(option: option, style: .cardBack, closeAction: closeAction, flipAction: flipCard)
        }
        .contentShape(Rectangle())
        .animation(.flipCard, value: visibleSide)
        .overlay(rateBar, alignment: .bottom)
    }
    
    var rateBar: some View {
        
        VStack(alignment: .leading){
            HStack {
                Button {
                    guard !hasVoted else { //user only has one vote
                        return
                    }
                    debugPrint("LIKE")
                    like.toggle()
                } label: {
                    Image(systemName: like ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .background(Circle()
                                        .fill(Color.white)
                                        .frame(width: 60.0, height: 60.0))
                    
                }
                .offset(y: hasVoted ? 0 : -10)
                .animation(.interpolatingSpring(mass: 1, stiffness: 350, damping: 5, initialVelocity: 5))
                .disabled(hasVoted)
                .padding(.horizontal, 30)
                
                Button {
                    guard !hasVoted else { //user only has one vote
                        return
                    }
                    debugPrint("DISLIKE")
                    dislike.toggle()
                } label: {
                    
                    Image(systemName: dislike ? "hand.thumbsdown.fill" :"hand.thumbsdown")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .background(Circle()
                                        .fill(Color.white)
                                        .frame(width: 60.0, height: 60.0))
                }
                .offset(y: hasVoted ? 0 : -10)
                .animation(.interpolatingSpring(mass: 1, stiffness: 350, damping: 5, initialVelocity: 5))
                .disabled(hasVoted)

                Spacer()
                
            }
            
            Text(hasVoted ? "📮 Voted!" : "🤓 Like what we have pickr for you? " )
                .foregroundColor(.primary)
                .font(.body)
                .fontWeight(.bold)
                .padding(.top, 10.0)
            
        }
        .offset(x: 0, y: 50)
        
    }
    
    func flipCard() {
        visibleSide.toggle()
    }
}
