//
//  OptionList.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI

struct OptionList: View {
    @EnvironmentObject private var model: DecisionMakerModel
    var collection: Collection
    
    @ObservedObject var alertModel = AlertModel()
    @Namespace private var namespace
    @State var selectedID: String?

    var body: some View {
        
        ZStack {
            List {
                ForEach(model.collection.options){
                    OptionRow(option: .constant($0))
                }
                .onDelete(perform: deleteOption)
            }
            .onAppear() {
                model.selectCollection(collection)
            }
            .padding(.bottom, 80)
            .overlay(bottomBar, alignment: .bottom)
            .navigationBarItems(trailing: AddOptionButton())
            .navigationTitle(collection.title)
            
            VisualEffectBlur()
                .edgesIgnoringSafeArea(.all)
                .opacity(alertModel.flag ? 1 : 0)
            
                if let randomOption = randomOptions(), alertModel.flag {
                    PickedCard(option: randomOption, presenting: alertModel.flag, closeAction: deselectIngredient)
                        .matchedGeometryEffect(id: randomOption.id, in: namespace, isSource: alertModel.flag)
                        .aspectRatio(0.75, contentMode: .fit)
                        .shadow(color: Color.black.opacity(alertModel.flag ? 0.2 : 0), radius: 20, y: 10)
                        .padding(20)
                        .opacity(alertModel.flag ? 1 : 0)
                        .zIndex(alertModel.flag ? 1 : 0)

                }
        }
        
        
       
//        .alert(isPresented: $alertModel.flag) {
//            guard let randomOption = model.checkedOptions.randomElement(), model.checkedOptions.count > 1 else {
//                return Alert(
//                    title: Text("No option is selected"),
//                    message: Text("Select at least two"),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//
//            return
//                Alert(title: Text("We have PICKED for you!"), message: Text("Are you going to choose \(randomOption.title)?"),
//                      primaryButton: Alert.Button.default(Text("Yes, I 'll choose \(randomOption.title)!"),
//                                                          action: {
//                                                            model.edit(option: randomOption)
//                                                            alertModel.flag = false
//                                                          }),
//                      secondaryButton: Alert.Button.destructive(Text("No, I have second thought"), action: {
//                        alertModel.flag = false
//                      })
//                )
//        }
//        .padding(.bottom, 80)
//        .overlay(bottomBar, alignment: .bottom)
//        .navigationBarItems(trailing: AddOptionButton())
//        .navigationTitle(collection.title)
        
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            BottomBarButton(action: randomSelection,
                            title: "Pick For Me!")
            .disabled(disablePick)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    func randomSelection() {
        alertModel.flag = true
    }
    
    func randomOptions() -> Option? {
        guard let option = model.checkedOptions.randomElement() else { return nil }
        DispatchQueue.main.async {
            selectedID = option.id
        }
        return option
    }
    
    func deselectIngredient() {
        withAnimation(.closeCard) {
            alertModel.flag = false
            model.edit(optionID: selectedID ?? "")
        }
    }
    
    var disablePick: Bool {
        return model.collection.options.count < 1 || model.checkedOptions.count < 2
    }
    
    func deleteOption(indexSet: IndexSet){
        indexSet.forEach{
            model.removeOption($0)
        }
    }
}

class AlertModel: ObservableObject {
    @Published var flag = false
    @Published var selectedOptionID = ""
}


struct OptionList_Previews: PreviewProvider {
    static let dataStore: DecisionMakerModel = {
        var dataStore = DecisionMakerModel()
        dataStore.selectCollection(.restaurants)
        return dataStore
    }()
    
    static var previews: some View {
        NavigationView{
            OptionList(collection: .restaurants)
                .navigationTitle("Restaurant")
                .environmentObject(dataStore)
        }
    }
}


struct PickedCard: View {
    var option: Option
    var presenting: Bool
    var closeAction: () -> Void = {}
    
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
    }
    
    func flipCard() {
        visibleSide.toggle()
    }
}
