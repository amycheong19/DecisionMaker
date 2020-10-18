//
//  TextFieldModel.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 8/9/20.
//
import Foundation
import Combine

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
