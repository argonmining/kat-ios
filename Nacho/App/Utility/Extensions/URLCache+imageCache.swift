import Foundation

extension URLCache {
    static let imageCache = URLCache(
        memoryCapacity: 256_000_000,
        diskCapacity: 512_000_000
    )
}
