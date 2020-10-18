//
//  HTMLStringView.swift
//  Pickr
//
//  Created by Amy Cheong on 20/9/20.
//

import SwiftUI
import UIKit
import WebKit

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
