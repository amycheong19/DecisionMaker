//
//  DecisionMakerModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation
import Combine
import Mixpanel

class DecisionMakerModel: ObservableObject {
    @Published private(set) var checkedOptions: [Option] = []
    @Published private(set) var collections: [Collection] = []
    @Published private(set) var selectedCollectionID: Collection.ID?
    @Published var collection = Collection.restaurants
    
    private var idCount = 1
    
    init() {
        initiateCollection()
    }
    
}

extension DecisionMakerModel {
    
    func addCollection(with title: String) {
        let id = "New Collection".lowercased()
        let tempTitle = title.isEmpty ? "New Collection - \(idCount)": title
        var tempCollection = Collection(id: id, title: tempTitle)
        
        if collections.firstIndex(where: { $0.id == tempCollection.id }) != nil {
            tempCollection.id = "\(tempCollection.id)\(idCount)"
            idCount += 1
            tempCollection.title = title.isEmpty ? "New Collection - \(idCount)": title
        }
        collections.append(tempCollection)
//        AnalyticsManager.shared.track(event: <#T##String?#>, properties: <#T##Properties?#>)
        AnalyticsManager.shared.track(event: "Collection - Add new",
                                      properties: AnalyticsManager.setCollection(collection: tempCollection) )
        saveCollections()
    }
    
    func editCollection(with newTitle: String) {
        
        guard let indexSet = collections.firstIndex(where: { $0.id == selectedCollectionID }) else {
            return
        }
        var tempCollection = collections[indexSet]
        tempCollection.title = newTitle
        collections[indexSet] = tempCollection
        
        AnalyticsManager.shared.track(event: "Collection - Edit name",
                                      properties: AnalyticsManager.setCollection(collection: tempCollection))
        
        saveCollections()
    }
    
    
    func initiateCollection(_ collection: Collection? = nil) {
        if let jsonCollections = try? Collection.loadJSON() {
            collections.append(contentsOf: jsonCollections)
        }
        
        guard !collections.isEmpty else {
            // initial
            if let jsonCollections = try? Collection.loadJSON() {
                collections.append(contentsOf: jsonCollections)
            }
            return
        }
        
        guard let collection = collection else { return }
        collections.append(collection)
    }
    
    func selectCollection(_ collection: Collection) {
        selectedCollectionID = collection.id
        self.collection = collection
        checkedOptions.removeAll()
        AnalyticsManager.shared.track(event: "Collection - Select",
                                      properties: AnalyticsManager.setCollection(collection: collection))
        
        _ = collection.options.compactMap{ addChecked($0) }
    }
    
    func removeCollection(_ i: Int) {
        AnalyticsManager.shared.track(event: "Collection - Remove",
                                      properties: AnalyticsManager.setCollection(collection: collections[i]))
        collections.remove(at: i)
        saveCollections()
    }
    
    func saveCollections() {
        do {
            _ = try Collection.save(jsonObject: collections)
        } catch  {
            print(error)
        }
    }
    
}

// MARK: - Options
extension DecisionMakerModel {
    
    func isChecked(option: Option) -> Bool {
        return checkedOptions.contains(option)
    }
    
    func editOptionsToPick(option: Option, toggle: Bool) {
        if toggle {
            addChecked(option)
        } else {
            if checkedOptions.contains(option) {
                removeCheckedOptions(id: option.id)
            }
        }
    }
    
    func dislikePickedOption(option: Option, toggle: Bool) {
        editOptionsToPick(option: option, toggle: false)
    }
    
    func addOptionPickedCount(optionID: String){
        guard let firstIndex = collection.options.firstIndex(where: { $0.id == optionID }) else { return }
        guard let checkIndex = checkedOptions.firstIndex(where: { $0.id == optionID }) else { return }
        
        checkedOptions[checkIndex].pickedIncrement()
        collection.options[firstIndex].pickedIncrement()
        saveOptions(with: collection)
    }
    
    func addChecked(_ option: Option) {
        checkedOptions.append(option)
    }
    
    func removeCheckedOptions(id: Option.ID){
        let firstIndex = checkedOptions.firstIndex(where: { $0.id == id })!
        checkedOptions.remove(at: firstIndex)
    }
    
    func removeOption(_ i: Int) {
        collection.options.remove(at: i)
        checkedOptions.remove(at: i)
        saveOptions(with: collection)
    }
    
    func addOption(with title: String, origin: UnsplashPhoto? = nil) {
        
        var tempOption = Option(id: "", title: title, origin: origin)
        tempOption.id = tempOption.title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if collection.options.contains(tempOption) {
            tempOption.id = "\(tempOption.id)\(idCount)"
            idCount += 1
        }
        
        collection.options.append(tempOption)
        addChecked(tempOption)
        saveOptions(with: collection)
    }
    
    func addOption(with option: Option) {
        
        var tempOption = option
        tempOption.id = tempOption.title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if collection.options.contains(tempOption) {
            tempOption.id = "\(tempOption.id)\(idCount)"
            idCount += 1
        }
        
        collection.options.append(tempOption)
        addChecked(tempOption)
        saveOptions(with: collection)
        
    }
    
    func editOption(with option: Option) {
        guard let firstIndex = collection.options.firstIndex(where: { $0.id == option.id }) else { return }
        
        collection.options[firstIndex] = option
        saveOptions(with: collection)
        
    }
    
    // Save options into JSON
    func saveOptions(with collection: Collection) {
        guard let indexSet = collections.firstIndex(where: { $0.id == selectedCollectionID }) else {
            return
        }
        collections[indexSet] = collection
        saveCollections()
    }
    
    
}

class OptionEditRowViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    @Published var searchText: String = ""
    @Published var option: Option
    var index: Int
    
    static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")
    
    static func newOption() -> Option {
        Option(id: "", title: "")
    }
    
    init(option: Option = OptionEditRowViewModel.newOption(), index: Int) {
        self.option = option
        self.index = index
        searchText = option.title
    }
    
    func debounceText() {
        
        cancellable = AnyCancellable(
            $searchText
                .removeDuplicates()
                .debounce(for: 0.3, scheduler: DispatchQueue.main)
                .sink { searchText in
                    if searchText.count > 2 && self.searchText != self.option.title {
                        self.searchImage(with: searchText) { _ in }
                    }
                }
        )
    }
    
    
    func searchImage(with text: String = "random", completionHandler: @escaping (Option?) -> Void)  {
        
        if let url = URL.with(query: text) {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(PhotoConfiguration.shared.accessKey, forHTTPHeaderField: "Authorization")
            
            cancellable =
                URLSession.shared.dataTaskPublisher(for: urlRequest)
                .subscribe(on: OptionEditRowViewModel.sessionProcessingQueue)
                .map({
                    return $0.data
                })
                .decode(type: PhotoResults.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (suscriberCompletion) in
                    switch suscriberCompletion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionHandler(nil)
                        print(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] value in
                    guard let `self` = self else { return }
                    if let origin = value.results.randomElement() {
                        self.option.origin = origin
                        if let downloadLocation = origin.links?.download_location {
                            self.downloadImage(with: downloadLocation)
                        }
                    }
                    completionHandler(self.option)
                })
        }
    }
    
    private func downloadImage(with urlString: String)  {
        
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(PhotoConfiguration.shared.accessKey, forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest){ [weak self] data, response, error in
                debugPrint("response: \(response) | error: \(error)")
            }.resume()
        }
    }
}
