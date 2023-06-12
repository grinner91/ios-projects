

import SwiftUI

struct ConcurrentTaskGroupDemo: View {
    @StateObject
    private var viewModel = ConcurrentTaskGroupViewModel()
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                }
            }
            .navigationBarTitle("TaskGroup images...")
            .task {
                await viewModel.fetchImages()
            }
        }
    }
}

struct ConcurrentTaskGroupDemo_Previews: PreviewProvider {
    static var previews: some View {
        ConcurrentTaskGroupDemo()
    }
}
