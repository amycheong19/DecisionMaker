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
        
    }
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            BottomBarButton(action: randomSelection,
                            title: "Pickr For Me!")
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
                    
                }.padding(.horizontal, 30)
                
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
                
                
                Spacer()
                
            }
            
            Text("Like what we have pickr for you?  ")
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
