import Foundation

public struct FeatureFlag: Decodable {
  public let flag: String
}

// MARK: - Hashable && Equatable

extension FeatureFlag: Hashable, Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(flag)
  }

  public static func == (lhs: FeatureFlag, rhs: FeatureFlag) -> Bool {
    lhs.flag == rhs.flag
  }
}
