enum NFTStyleItem: String {
    case head = "Head"
    case face = "Face"
    case mood = "Mood"
    case collar = "Collar"
    case outfit = "Outfit"
    case role = "Role"
    case tail = "Tail"
    case background = "Background"

    func style(from array: [NFTAttribute]) -> String? {
        for item in array {
            if item.traitType == rawValue {
                return item.value
            }
        }
        return nil
    }

    static func imageUniqueId(from array: [NFTAttribute]) -> String {
        func value(style: NFTStyleItem) -> String? {
            for attribute in array {
                if attribute.traitType == style.rawValue {
                    return attribute.value
                }
            }
            return nil
        }

        var result = ""
        [
            NFTStyleItem.head,
            NFTStyleItem.face,
            NFTStyleItem.mood,
            NFTStyleItem.collar,
            NFTStyleItem.outfit,
            NFTStyleItem.tail,
            NFTStyleItem.background
        ].forEach {
            if let value = value(style: $0) {
                result += value
            }
        }
        return result
    }
}
