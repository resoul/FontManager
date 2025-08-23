import UIKit

public struct FontManager {

    public static func registerFonts<T: FontRepresentable>(fontFamily: T.Type) {
        let bundle = Bundle.module
        
        for font in T.allCases {
            guard let fontURL = bundle.url(forResource: font.rawValue, withExtension: "ttf") else {
                print("Cannot find font \(font.rawValue).ttf")
                continue
            }
            
            guard let fontData = try? Data(contentsOf: fontURL) as CFData,
                  let provider = CGDataProvider(data: fontData),
                  let cgFont = CGFont(provider)
            else {
                print("❌ Could not create CGFont for '\(font.rawValue)'.")
                continue
            }
            
            var error: Unmanaged<CFError>?
            
            if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
                if let err = error?.takeRetainedValue() {
                    let errorDomain = CFErrorGetDomain(err) as String
                    let errorCode = CFErrorGetCode(err)
                    if errorDomain == kCTFontManagerErrorDomain as String && errorCode == 305 {
                        print("✅ Font '\(font.rawValue)' already registered. Continue.")
                    } else {
                        fatalError("❌ Cannot register font '\(font.rawValue)': \(err.localizedDescription)")
                    }
                }
            } else {
                print("Font '\(font)' successfully registered!")
            }
        }
    }
}

public extension UIFont {
    
    static func amazon(_ style: Fonts.Amazon, size: CGFloat) -> UIFont? {
        return UIFont(name: style.rawValue, size: size)
    }
    
    static func montserrat(_ style: Fonts.Montserrat, size: CGFloat) -> UIFont? {
        return UIFont(name: style.rawValue, size: size)
    }
    
    static func roboto(_ style: Fonts.Roboto, size: CGFloat) -> UIFont? {
        return UIFont(name: style.rawValue, size: size)
    }
}

public enum Fonts {
    
    public enum Amazon: String, FontRepresentable {
        case emberRegular = "AmazonEmber_Rg"
        case emberDisplayRegular = "AmazonEmberDisplay_Rg"
    }

    public enum Montserrat: String, FontRepresentable {
        case black = "Montserrat-Black"
        case blackItalic = "Montserrat-BlackItalic"
        case bold = "Montserrat-Bold"
        case boldItalic = "Montserrat-BoldItalic"
        case italic = "Montserrat-Italic"
        case light = "Montserrat-Light"
        case lightItalic = "Montserrat-LightItalic"
        case medium = "Montserrat-Medium"
        case mediumItalic = "Montserrat-MediumItalic"
        case regular = "Montserrat-Regular"
        case semiBold = "Montserrat-SemiBold"
        case semiBoldItalic = "Montserrat-SemiBoldItalic"
        case thin = "Montserrat-Thin"
        case thinItalic = "Montserrat-ThinItalic"
    }

    public enum Roboto: String, FontRepresentable {
        case black = "Roboto-Black"
        case blackItalic = "Roboto-BlackItalic"
        case bold = "Roboto-Bold"
        case boldItalic = "Roboto-BoldItalic"
        case italic = "Roboto-Italic"
        case light = "Roboto-Light"
        case lightItalic = "Roboto-LightItalic"
        case medium = "Roboto-Medium"
        case mediumItalic = "Roboto-MediumItalic"
        case regular = "Roboto-Regular"
        case thin = "Roboto-Thin"
        case thinItalic = "Roboto-ThinItalic"
    }
}

public protocol FontRepresentable: RawRepresentable, CaseIterable where RawValue == String {}

public protocol FontRegisterable: CaseIterable {
    static var allCases: [any StringConvertible] { get }
}

public protocol StringConvertible {
    var stringValue: String { get }
}

extension RawRepresentable where RawValue == String, Self: CaseIterable, Self: FontRegisterable {
    public static var allCases: [any StringConvertible] {
        return allCases.map { $0 as StringConvertible }
    }
}

extension RawRepresentable where RawValue == String, Self: StringConvertible {
    public var stringValue: String {
        return self.rawValue
    }
}
