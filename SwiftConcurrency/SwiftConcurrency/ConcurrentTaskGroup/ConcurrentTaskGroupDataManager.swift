
import Foundation
import SwiftUI

class ConcurrentTaskGroupDataManager {
    private let imageUrlStr =  "https://picsum.photos/300"
    
    func fetchImagesWithAsyncLet()  async throws -> [UIImage] {
        do {
            async let fetch1 =  fetchImage(urlString: imageUrlStr )
            async let fetch2 =  fetchImage(urlString: imageUrlStr)
            //async let fetch3 =  fetchImage(urlString: imageUrlStr)
            
            let (image1, image2) = await (try fetch1, try fetch2)
            
            return [image1, image2]
            
        } catch  {
            throw URLError(.badURL)
        }
        
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlArray = [
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300"
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlArray.count)
            
            for urlStr in urlArray {
                group.addTask {
                    try? await self.fetchImage(urlString: urlStr)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append( image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let imageUrl = URL(string: urlString)
        else { throw URLError(.badURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}
