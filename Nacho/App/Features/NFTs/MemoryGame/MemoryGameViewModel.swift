import SwiftUI
import Observation

@Observable
final class MemoryGameViewModel {
    
    let images: [String]

    init(images: [String]) {
        self.images = images
    }
}
