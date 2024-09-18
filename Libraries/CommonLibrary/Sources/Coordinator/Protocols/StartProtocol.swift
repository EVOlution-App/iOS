public protocol StartProtocol: AnyObject {
    associatedtype StartType

    func start() -> StartType
}
