//
//  AlertModel.swift
//  Pickr
//
//  Created by Amy Cheong on 21/10/20.
//

import Foundation

class AlertModel: ObservableObject {
    @Published var flag = false
    @Published var selectedOptionID = ""
}
