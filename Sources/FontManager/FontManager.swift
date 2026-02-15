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
            }
        }
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
