//
//  Image+Extension.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI


extension Image {
    var listThumbnailStyle: some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: metrics.thumbnailSize,
                   height: metrics.thumbnailSize)
            .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous))
            .accessibility(hidden: true)
    }
    
    private var metrics: Metrics {
        return Metrics(thumbnailSize: 96, cornerRadius: 16)
    }
    
}
