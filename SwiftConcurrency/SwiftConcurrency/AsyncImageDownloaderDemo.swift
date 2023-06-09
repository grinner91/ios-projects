
import SwiftUI


struct AsyncImageDownloaderDemo: View {
    
    @StateObject
    private var viewModel = AsyncImageDownloaderViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Async image downloader...")
                
                if let image = viewModel.imageWithEscaping {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(25)
                        .frame(width: 300, height: 300)
                    
                }
                
                if let image = viewModel.imageWithCombine {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(25)
                        .frame(width: 300, height: 300)
                    
                }
                
                if let image = viewModel.imageWithAsyncAwait {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(25)
                        .frame(width: 300, height: 300)
                    
                }
                //
                AsyncImage(url: URL(string: "https://picsum.photos/300"),
                           content: { image in
                         image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(25)
                        .frame(width: 300, height: 300)
                        .padding()
                }, placeholder: {
                    ProgressView()
                })
                
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchImage()
            }
        }
    }
}

struct AsyncImageDownloaderDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageDownloaderDemo()
    }
}

