import UIKit
import AtomicKit

// MARK: - Font Service Protocol
public protocol FontService {
    func registerFonts<T: FontRepresentable>(fontFamily: T.Type)
    func registerAllAvailableFonts()
    func isRegistered<T: FontRepresentable>(_ fontFamily: T.Type) -> Bool
    func getFont<T: FontRepresentable>(_ style: T, size: CGFloat) -> UIFont?
}

// MARK: - Font Manager Implementation
public final class FontManager: FontService {
    @LoggerInjected private var logger: Logger

    private var registeredFonts: Set<String> = []
    private let lock = NSLock()

    public init() {}

    public func registerFonts<T: FontRepresentable>(fontFamily: T.Type) {
        lock.lock()
        defer { lock.unlock() }

        let bundle = Bundle.module
        let familyName = String(describing: fontFamily)

        logger.info("🎨 Starting font registration for family: \(familyName)", metadata: [
            "family": familyName,
            "totalFonts": fontFamily.allCases.count
        ])

        var successCount = 0
        var failureCount = 0

        for font in fontFamily.allCases {
            let fontName = font.rawValue

            // Check if already registered
            if registeredFonts.contains(fontName) {
                logger.debug("Font '\(fontName)' already registered, skipping", metadata: [
                    "font": fontName,
                    "family": familyName
                ])
                successCount += 1
                continue
            }

            guard let fontURL = bundle.url(forResource: fontName, withExtension: "ttf") else {
                logger.warning("Cannot find font file: \(fontName).ttf", metadata: [
                    "font": fontName,
                    "family": familyName
                ])
                failureCount += 1
                continue
            }

            do {
                let fontData = try Data(contentsOf: fontURL) as CFData

                guard let provider = CGDataProvider(data: fontData),
                      let cgFont = CGFont(provider) else {
                    logger.error("Could not create CGFont for '\(fontName)'", metadata: [
                        "font": fontName,
                        "family": familyName
                    ])
                    failureCount += 1
                    continue
                }

                var error: Unmanaged<CFError>?

                if CTFontManagerRegisterGraphicsFont(cgFont, &error) {
                    registeredFonts.insert(fontName)
                    logger.debug("✅ Font '\(fontName)' successfully registered", metadata: [
                        "font": fontName,
                        "family": familyName
                    ])
                    successCount += 1
                } else {
                    if let err = error?.takeRetainedValue() {
                        let errorDomain = CFErrorGetDomain(err) as String
                        let errorCode = CFErrorGetCode(err)

                        if errorDomain == kCTFontManagerErrorDomain as String && errorCode == 105 {
                            // Font already registered
                            registeredFonts.insert(fontName)
                            logger.debug("✅ Font '\(fontName)' was already registered in system", metadata: [
                                "font": fontName,
                                "family": familyName
                            ])
                            successCount += 1
                        } else {
                            logger.error("Failed to register font '\(fontName)': \(err.localizedDescription)", metadata: [
                                "font": fontName,
                                "family": familyName,
                                "errorCode": errorCode,
                                "errorDomain": errorDomain
                            ])
                            failureCount += 1
                        }
                    }
                }
            } catch {
                logger.error("Failed to load font data for '\(fontName)': \(error.localizedDescription)", metadata: [
                    "font": fontName,
                    "family": familyName,
                    "error": error.localizedDescription
                ])
                failureCount += 1
            }
        }

        logger.info("🎨 Font registration completed for \(familyName)", metadata: [
            "family": familyName,
            "successful": successCount,
            "failed": failureCount,
            "total": fontFamily.allCases.count
        ])
    }

    public func registerAllAvailableFonts() {
        logger.info("🎨 Starting registration of all available font families")

        registerFonts(fontFamily: Fonts.Amazon.self)
        registerFonts(fontFamily: Fonts.Montserrat.self)
        registerFonts(fontFamily: Fonts.Roboto.self)

        logger.info("🎨 All font families registration completed", metadata: [
            "totalRegisteredFonts": registeredFonts.count
        ])
    }

    public func isRegistered<T: FontRepresentable>(_ fontFamily: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        return fontFamily.allCases.allSatisfy { registeredFonts.contains($0.rawValue) }
    }

    public func getFont<T: FontRepresentable>(_ style: T, size: CGFloat) -> UIFont? {
        let fontName = style.rawValue

        guard registeredFonts.contains(fontName) else {
            logger.warning("Attempting to use unregistered font: \(fontName)", metadata: [
                "font": fontName,
                "size": size
            ])
            return nil
        }

        return UIFont(name: fontName, size: size)
    }
}

public struct FontModule: ServiceModule {
    public init() {}

    public func configure(container: Container) {
        container.registerSingleton(FontService.self) { _ in
            FontManager()
        }

        container.registerSingleton(FontManager.self) { container in
            container.resolve(FontService.self) as! FontManager
        }
    }
}

@propertyWrapper
public struct FontServiceInjected {
    @Injected private var fontService: FontService

    public var wrappedValue: FontService {
        return fontService
    }

    public init() {}
}
