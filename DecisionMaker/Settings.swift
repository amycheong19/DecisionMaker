//
//  Settings.swift
//  Pickr
//
//  Created by Amy Cheong on 20/9/20.
//

import SwiftUI
import UIKit



struct Settings: View {
    @EnvironmentObject private var model: DecisionMakerModel
    @State var isPresented1: Bool = false
    @State var isPresented2: Bool = false
    @State var isPresented3: Bool = false
    
    var body: some View {
        
                    Form {
                        Section(header: Text("ABOUT PICKR")) {
                            // 1
                            Button(action: { self.isPresented1.toggle() }) {
                                HStack {
                                    Image(systemName: SettingsContent.Info.privacyPolicy.iconString)
                                    Text(SettingsContent.Info.privacyPolicy.title)
                                }
                            }.sheet(isPresented: $isPresented1) {
                                WebContentView(link: .constant(SettingsContent.Info.privacyPolicy.link))
                            }
                            // 2
                            Button(action: { self.isPresented2.toggle() }) {
                                HStack {
                                    Image(systemName: SettingsContent.Info.termsAndConditions.iconString)
                                    Text(SettingsContent.Info.termsAndConditions.title)
                                }
                            }.sheet(isPresented: $isPresented2) {
                                WebContentView(link: .constant(SettingsContent.Info.termsAndConditions.link))
                            }
                            
                            //3
                            Button(action: { self.isPresented3.toggle() }) {
                                HStack {
                                    Text ("Rate Pickr in AppStore")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        
                                }
                            }.sheet(isPresented: $isPresented3) {
                                Text("🦘")
//                                openAppStore()
                            }
                        }
                        
                    }
                    .overlay(bottomBar, alignment: .bottom)
                    .navigationTitle("Settings")

    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://apple.com/app/id839686104") {
            UIApplication.shared.open(url)
        }
    }
    
    var bottomBar: some View {
        HStack(spacing: 18) {
            Spacer()
            VStack(alignment: .center) {
                Text("Made by @amycheong 🤓")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        guard let url = URL(string: "https://twitter.com/amycheong19"),
                              UIApplication.shared.canOpenURL(url)
                        else { return }
                        
                        UIApplication.shared.open(url)
                    }
                
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text("App Version \(appVersion)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            Spacer()
        }
    }

}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(DecisionMakerModel())
    }
}

extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarHidden(true)
    }
}
