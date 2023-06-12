
import Foundation
import SwiftUI

class ConcurrentTaskGroupViewModel: ObservableObject {
    @Published
    var images: [UIImage] = []
    
    private var imageDownloader = ConcurrentTaskGroupDataManager()
    
    func fetchImages() async {
        //download images with async let
        if let imageList = try? await imageDownloader.fetchImagesWithAsyncLet() {
            await MainActor.run {
                images.append(contentsOf: imageList)
            }
        }
        //download images with TaskGroup
        if let imageList = try? await imageDownloader.fetchImagesWithTaskGroup() {
            await MainActor.run {
                images.append(contentsOf: imageList)
            }
        }
    }
}
