
import SwiftUI


struct AsyncLetDemo: View {
    @State private var images: [UIImage] = []
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let url = URL(string: "https://picsum.photos/300")
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
                .navigationTitle("Async Let 🧐")
                .onAppear {
                    startFetchImagesTask()
                }
            }
        }
    }
    
    func startFetchImagesTask() {
        Task {
            do {
                async let fetch1 = fetchImage()
                async let fetch2 = fetchImage()
                
                let (image1, image2) = await (try fetch1, try fetch2)
                    
                self.images.append(contentsOf: [image1, image2])
                
        
            } catch {
                print("\(error)")
            }
        }
        
    }

    func fetchImage() async throws -> UIImage {
        do {
            let (data, res) = try await URLSession.shared.data(from: url!)
            
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
            
        } catch let err {
            print("error: \(err.localizedDescription)")
            throw err
        }
    }
}

struct AsyncLetDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetDemo()
    }
}
