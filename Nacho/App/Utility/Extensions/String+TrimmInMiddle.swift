import Foundation

extension String {
    func trimmedInMiddle(toLength length: Int, shiftStartBy shift: Int = 0) -> String {
        guard self.count > length, length > 3 else {
            return self
        }
        
        let totalTrimLength = self.count - length
        let shiftClamped = max(0, min(totalTrimLength, shift))

        let prefixLength = (length - 3) / 2 + shiftClamped
        let suffixLength = length - 3 - (prefixLength - shiftClamped)

        let prefix = self.prefix(prefixLength)
        let suffix = self.suffix(suffixLength)

        return "\(prefix)...\(suffix)"
    }
}
