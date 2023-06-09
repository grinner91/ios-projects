import SwiftUI
import Combine


@MainActor
class AsyncImageDownloaderViewModel: ObservableObject {
    @Published
    var imageWithEscaping: UIImage? = nil
    
    @Published
    var imageWithCombine: UIImage? = nil
    
    @Published
    var imageWithAsyncAwait: UIImage? = nil
    
    
    private var downloader = AsyncImageDownloader()
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchImage() async {
        
        downloader.downloadWithEscaping { [weak self] image, error in
            DispatchQueue.main.async {
                self?.imageWithEscaping = image
            }
        }
        
        downloader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink{ _ in }
            receiveValue: {
               [weak self] image in
                self?.imageWithCombine = image
            }
            .store(in: &cancellables)
        
        
        let image = try? await downloader.downloadWithAsync()
         await MainActor.run {
             self.imageWithAsyncAwait = image
         }
        
    }
    
}
