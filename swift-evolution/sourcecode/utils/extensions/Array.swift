import Foundation

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result: [Element] = []

        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }

        return result
    }
}

extension Array {
    func shuffle() -> [Element] {
        var list = self
        list.sort { _, _ in
            arc4random() < arc4random()
        }

        return list
    }
}
