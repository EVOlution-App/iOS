import Foundation

public typealias Warnings = [Warning]

public struct Warning: Codable {
  public let message: String?
  public let stage: String?
  public let kind: String?
}
