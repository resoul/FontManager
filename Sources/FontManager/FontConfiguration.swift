import UIKit
import AtomicKit

public protocol FontRepresentable: RawRepresentable, CaseIterable where RawValue == String {
    static var familyName: String { get }
}

public protocol FontRegisterable: CaseIterable {
    static var allCases: [any StringConvertible] { get }
}

public protocol StringConvertible {
    var stringValue: String { get }
}

@resultBuilder
public struct FontStyleBuilder {
    public static func buildBlock(_ styles: FontRepresentable...) -> [FontRepresentable] {
        return styles
    }
}

public struct FontConfiguration {
    public let families: [any FontRepresentable.Type]
    public let enableLogging: Bool
    public let logLevel: LogLevel

    public init(
        families: [any FontRepresentable.Type] = [],
        enableLogging: Bool = true,
        logLevel: LogLevel = .info
    ) {
        self.families = families
        self.enableLogging = enableLogging
        self.logLevel = logLevel
    }

    public static var `default`: FontConfiguration {
        return FontConfiguration(
            families: [Fonts.Montserrat.self, Fonts.Roboto.self, Fonts.Poppins.self, Fonts.Amazon.self]
        )
    }
}
