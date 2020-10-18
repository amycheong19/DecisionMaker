//
//  View+Extension.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
