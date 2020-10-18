//
//  AlertControl.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 6/9/20.
//

import SwiftUI
import UIKit

enum AlertMode {
    case add
    case edit
}

struct AlertControl: UIViewControllerRepresentable {
    @EnvironmentObject private var model: DecisionMakerModel
    @Binding var textString: String
    @Binding var show: Bool
    @Binding var mode: AlertMode

    var title: String = ""
    var message: String = ""

    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControl>) -> UIViewController {
        return UIViewController() // holder controller - required to present alert
    }

    func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControl>) {
        guard context.coordinator.alert == nil else { return }
        if self.show {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert
            
            

            alert.addTextField { textField in
                textField.placeholder = "Enter Name"
                if mode == .edit {
                    textField.text = textString
                }
                
                textField.autocapitalizationType = .sentences
                textField.clearButtonMode = .whileEditing
                textField.delegate = context.coordinator
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                // your action here
            })
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { value in
                
                if mode == .add {
                    model.addCollection(with: textString)
                } else {
                    model.editCollection(with: textString)
                }
                
            })

            DispatchQueue.main.async { // must be async !!
                viewController.present(alert, animated: true, completion: {
                    self.show = false  // hide holder after alert dismiss
                    context.coordinator.alert = nil
                })
            }
        }
    }

    func makeCoordinator() -> AlertControl.Coordinator {
        Coordinator(self)
    }

   
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: AlertControl
        init(_ control: AlertControl) {
            self.control = control
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textString = ""
            }
            return true
        }
    }
}
