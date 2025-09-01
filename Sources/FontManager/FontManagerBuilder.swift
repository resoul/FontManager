import UIKit
import AtomicKit

public final class FontManagerBuilder {
    private var configuration: FontConfiguration = .default

    public init() {}

    public func with(configuration: FontConfiguration) -> FontManagerBuilder {
        self.configuration = configuration
        return self
    }

    public func enableLogging(_ level: LogLevel = .info) -> FontManagerBuilder {
        self.configuration = FontConfiguration(
            families: configuration.families,
            enableLogging: true,
            logLevel: level
        )
        return self
    }

    public func addFontFamily<T: FontRepresentable>(_ family: T.Type) -> FontManagerBuilder {
        var families = configuration.families
        families.append(family)
        self.configuration = FontConfiguration(
            families: families,
            enableLogging: configuration.enableLogging,
            logLevel: configuration.logLevel
        )
        return self
    }

    public func build() -> FontManager {
        let fontManager = FontManager()

        // Configure logging if enabled
        if configuration.enableLogging {
            let logger = ConsoleLogger(minimumLevel: configuration.logLevel, category: "FontManager")
            AtomicLogger.shared = CompositeLogger(loggers: [AtomicLogger.shared, logger])
        }

        // Register all specified font families
        for family in configuration.families {
            switch family {
            case is Fonts.Amazon.Type:
                fontManager.registerFonts(fontFamily: Fonts.Amazon.self)
            case is Fonts.Montserrat.Type:
                fontManager.registerFonts(fontFamily: Fonts.Montserrat.self)
            case is Fonts.Roboto.Type:
                fontManager.registerFonts(fontFamily: Fonts.Roboto.self)
            case is Fonts.Poppins.Type:
                fontManager.registerFonts(fontFamily: Fonts.Poppins.self)
            default:
                break
            }
        }

        return fontManager
    }
}