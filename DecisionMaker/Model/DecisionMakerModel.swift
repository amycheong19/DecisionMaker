//
//  DecisionMakerModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation
import Combine

class DecisionMakerModel: ObservableObject {
    @Published private(set) var checkedOptions: [Option] = []
    @Published private(set) var collections: [Collection] = []
    @Published private(set) var selectedCollectionID: Collection.ID?
    @Published var collection = Collection.restaurants
    
    private var idCount = 1000
    
    init() {
        createCollection()
    }
    
}

extension DecisionMakerModel {
    
    func addCollection(with title: String) {
        var tempCollection = Collection(id: "", title: title)
        tempCollection.id = tempCollection.title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if collections.firstIndex(where: { $0.title == title }) != nil {
            tempCollection.id = "\(tempCollection.id)\(idCount)"
            idCount += 1
        }
        collections.append(tempCollection)
        saveCollections()
    }
    
    
    func createCollection(_ collection: Collection? = nil) {
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
        _ = collection.options.compactMap{ addChecked($0) }
    }
    
    func removeCollection(_ i: Int) {
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
    func editOptionsToPick(option: Option, toggle: Bool) {
        if toggle {
            addChecked(option)
        } else {
            if checkedOptions.contains(option) {
                removeCheckedOptions(id: option.id)
            }
        }
    }
    
    func edit(optionID: String){
        
        guard let firstIndex = collection.options.firstIndex(where: { $0.id == optionID }) else { return }
        
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
    
    func addOption(with title: String, imageString: String? = nil) {
        
        var tempOption = Option(id: "", title: title, imageURLString: imageString)
        tempOption.id = tempOption.title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if checkedOptions.contains(tempOption) {
            tempOption.id = "\(tempOption.id)\(idCount)"
            idCount += 1
        }
        
        collection.options.append(tempOption)
        addChecked(tempOption)
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

class TextFieldModel: ObservableObject {    
    private var cancellable: AnyCancellable?
    @Published var searchText: String = ""
    @Published var searchedPhoto: UnsplashPhoto?
    private static let sessionProcessingQueue = DispatchQueue(label: "SessionProcessingQueue")
    
    func debounceText() {

        cancellable = AnyCancellable(
        $searchText
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { searchText in
                if searchText.count > 2 {
                    self.searchImage(with: searchText)
                }
          }
        )
      }
    

    func searchImage(with text: String = "random")  {
        
        if let url = URL.with(query: text) {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(PhotoConfiguration.shared.accessKey, forHTTPHeaderField: "Authorization")
            
            cancellable =
                URLSession.shared.dataTaskPublisher(for: urlRequest)
                .subscribe(on: TextFieldModel.sessionProcessingQueue)
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
                        print(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] value in
                    self?.searchedPhoto = value.results.randomElement()
                    if let downloadLocation = self?.searchedPhoto?.links?.download_location {
                        self?.downloadImage(with: downloadLocation)
                    }
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
