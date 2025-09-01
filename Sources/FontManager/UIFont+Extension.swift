import UIKit
import AtomicKit

public extension UIFont {

    static func amazon(_ style: Fonts.Amazon, size: CGFloat) -> UIFont? {
        let container = SafeContainer.shared
        let fontService: FontService = container.resolve(FontService.self)
        return fontService.getFont(style, size: size)
    }

    static func montserrat(_ style: Fonts.Montserrat, size: CGFloat) -> UIFont? {
        let container = SafeContainer.shared
        let fontService: FontService = container.resolve(FontService.self)
        return fontService.getFont(style, size: size)
    }

    static func roboto(_ style: Fonts.Roboto, size: CGFloat) -> UIFont? {
        let container = SafeContainer.shared
        let fontService: FontService = container.resolve(FontService.self)
        return fontService.getFont(style, size: size)
    }

    static func poppins(_ style: Fonts.Poppins, size: CGFloat) -> UIFont? {
        let container = SafeContainer.shared
        let fontService: FontService = container.resolve(FontService.self)
        return fontService.getFont(style, size: size)
    }

    static func amazonWithFallback(_ style: Fonts.Amazon, size: CGFloat, fallback: UIFont.Weight = .regular) -> UIFont {
        return amazon(style, size: size) ?? UIFont.systemFont(ofSize: size, weight: fallback)
    }

    static func montserratWithFallback(_ style: Fonts.Montserrat, size: CGFloat, fallback: UIFont.Weight = .regular) -> UIFont {
        return montserrat(style, size: size) ?? UIFont.systemFont(ofSize: size, weight: fallback)
    }

    static func robotoWithFallback(_ style: Fonts.Roboto, size: CGFloat, fallback: UIFont.Weight = .regular) -> UIFont {
        return roboto(style, size: size) ?? UIFont.systemFont(ofSize: size, weight: fallback)
    }

    static func poppinsWithFallback(_ style: Fonts.Poppins, size: CGFloat, fallback: UIFont.Weight = .regular) -> UIFont {
        return roboto(style, size: size) ?? UIFont.systemFont(ofSize: size, weight: fallback)
    }
}
