
import SwiftUI
import Combine


class AsyncImageDownloader {
    
    private let imageUrl = URL(string: "https://picsum.photos/300")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let res = response  as? HTTPURLResponse,
            res.statusCode >= 200 && res.statusCode < 300
        else {
            return nil
        }
        
        return image
    }
    
    func downloadWithEscaping(completionHandler:
                              @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        
//        guard let url = imageUrl else {
//            print("No image url")
//            completionHandler(nil, nil)
//            return
//        }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            //donwloaded successfully
            completionHandler(image, nil)
            
        }.resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: imageUrl)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: imageUrl, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch  {
            throw error
        }
    }
    
    
}
