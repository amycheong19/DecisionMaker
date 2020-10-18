//
//  BackFactView.swift
//  Pickr
//
//  Created by Amy Cheong on 18/10/20.
//

import SwiftUI

// Back Card of the Picked option
public struct BackFactView: View {
    public var option: Option

    public var body: some View {
        VStack(alignment: .leading) {
            
            if let origin = option.origin,
               let user = origin.user {
                
                Text("\(option.title.capitalized) Details")
                    .font(.title)
                    .bold()
                
                HStack {
                    Text("Has been Pickr for ")
                        .foregroundColor(.secondary)
                        .font(.body)
                        .fontWeight(.semibold)

                    Text("\(option.picked) time\(option.pluralizer)")
                        .foregroundColor(.blue)
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Photo by")
                        .foregroundColor(.secondary)
                        .font(.body)

                    Text(" \(user.name ?? "Annonymous")")
                        .foregroundColor(.blue)
                        .font(.body)
                        .underline()
                        .onTapGesture {
                            guard let username = user.username,
                                  let url = URL(string: "https://unsplash.com/@\(username)?utm_source=your_app_name&utm_medium=referral"),
                                  UIApplication.shared.canOpenURL(url)
                            else { return }
                            
                            UIApplication.shared.open(url)
                        }
                }
                
                
                HStack {
                    Text("From ")
                        .foregroundColor(.secondary)
                        .font(.body)

                    Text("Unsplash")
                        .foregroundColor(.blue)
                        .font(.body)
                        .underline()
                        .onTapGesture {
                            let url = URL(string: "https://unsplash.com/?utm_source=Pickr&utm_medium=referral")
                            guard let websiteURL = url, UIApplication.shared.canOpenURL(websiteURL)
                            else { return }
                            UIApplication.shared.open(websiteURL)
                        }
                }

            }
        }
        .padding(20)
        .accessibilityElement(children: .combine)

    }
}
