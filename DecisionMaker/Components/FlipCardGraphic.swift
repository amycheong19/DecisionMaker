//
//  FlipCardGraphic.swift
//  Pickr
//
//  Created by Amy Cheong on 16/9/20.
//

import SwiftUI

struct FlipCardGraphic: View {
    var option: Option
    var style: Style
    var closeAction: () -> Void = {}
    var flipAction: () -> Void = {}
    
    var card: CardTitle = CardTitle.vertical

    enum Style {
        case cardFront
        case cardBack
        case thumbnail
    }
    
    var displayingAsCard: Bool {
        style == .cardFront || style == .cardBack
    }
    
    var shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
    let cardCrop = Crop()
    let thumbnailCrop = Crop(yOffset: 0, scale: 1)
    
    var body: some View {
        ZStack {
            
            image
            
            if style != .cardBack {
                title
            }
            
            if style == .cardFront {
                cardControls(for: .front)
                    .foregroundColor(card.color)
                    .opacity(card.opacity)
                    .blendMode(card.blendMode)
            }
            
            if style == .cardBack {
                VisualEffectBlur(blurStyle: .systemThinMaterial, vibrancyStyle: .fill) {
                    BackFactView(option: option)
                        .padding(.bottom, 70)                        
                    cardControls(for: .back)
                }
            }
        }
        .frame(minWidth: 130, maxWidth: 400, maxHeight: 500)
        .clipShape(shape)
        .overlay(
            shape
                .inset(by: 0.5)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .contentShape(shape)
        .accessibilityElement(children: .contain)
        
        
    }
    
    var image: some View {
        GeometryReader { geo in
            
            if let urlString = option.origin?.urls.regular,
               let url = URL(string: urlString) {
                
                URLImage(url, expireAfter: Date(timeIntervalSinceNow: 31_556_926.0)) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(displayingAsCard ? cardCrop.scale : thumbnailCrop.scale)
                        .offset(displayingAsCard ? cardCrop.offset : thumbnailCrop.offset)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(x: style == .cardBack ? -1 : 1)
                        

                }
                
                
            } else {
                if let uiImage = UIImage(named: "placeholder") {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(displayingAsCard ? cardCrop.scale : thumbnailCrop.scale)
                        .offset(displayingAsCard ? cardCrop.offset : thumbnailCrop.offset)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(x: style == .cardBack ? -1 : 1)
                }
                    
            }
            
        }
        .accessibility(hidden: true)
    }
    
    var title: some View {
        Text(option.title.uppercased())
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .lineLimit(1)
            .foregroundColor(card.color)
            .rotationEffect(displayingAsCard ? card.rotation: .degrees(0))
            .opacity(card.opacity)
            .blendMode(card.blendMode)
            .animatableFont(size: displayingAsCard ? card.fontSize : 40, weight: .bold)
            .minimumScaleFactor(0.25)
            .offset(displayingAsCard ? card.offset : .zero)
    }
    
    func cardControls(for side: FlipViewSide) -> some View {
        VStack {
            if side == .front {
                CardActionButton(label: "Close", systemImage: "xmark.circle.fill", action: closeAction)
                    .scaleEffect(displayingAsCard ? 1 : 0.5)
                    .opacity(displayingAsCard ? 1 : 0)
            }
            Spacer()
            CardActionButton(
                label: side == .front ? "Open BackFactView" : "Close BackFactView",
                systemImage: side == .front ? "info.circle.fill" : "arrow.left.circle.fill",
                action: flipAction
            )
            .scaleEffect(displayingAsCard ? 1 : 0.5)
            .opacity(displayingAsCard ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}




/// Defines a state for the `Ingredient` to transition from when changing between card and thumbnail
struct Crop {
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    var scale: CGFloat = 1
    
    var offset: CGSize {
        CGSize(width: xOffset, height: yOffset)
    }
}
