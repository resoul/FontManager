import UIKit
import AtomicKit

public enum Fonts {

    public enum Amazon: String, FontRepresentable {
        case emberRegular = "AmazonEmber_Rg"
        case emberDisplayRegular = "AmazonEmberDisplay_Rg"

        public static var familyName: String { "Amazon" }
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

        public static var familyName: String { "Montserrat" }

        // Convenience computed properties
        public var weight: UIFont.Weight {
            switch self {
            case .thin, .thinItalic: return .thin
            case .light, .lightItalic: return .light
            case .regular, .italic: return .regular
            case .medium, .mediumItalic: return .medium
            case .semiBold, .semiBoldItalic: return .semibold
            case .bold, .boldItalic: return .bold
            case .black, .blackItalic: return .black
            }
        }

        public var isItalic: Bool {
            switch self {
            case .blackItalic, .boldItalic, .italic, .lightItalic, .mediumItalic, .semiBoldItalic, .thinItalic:
                return true
            default:
                return false
            }
        }
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

        public static var familyName: String { "Roboto" }

        // Convenience computed properties
        public var weight: UIFont.Weight {
            switch self {
            case .thin, .thinItalic: return .thin
            case .light, .lightItalic: return .light
            case .regular, .italic: return .regular
            case .medium, .mediumItalic: return .medium
            case .bold, .boldItalic: return .bold
            case .black, .blackItalic: return .black
            }
        }

        public var isItalic: Bool {
            switch self {
            case .blackItalic, .boldItalic, .italic, .lightItalic, .mediumItalic, .thinItalic:
                return true
            default:
                return false
            }
        }
    }

    public enum Poppins: String, FontRepresentable {
        case black = "Poppins-Black"
        case blackItalic = "Poppins-BlackItalic"
        case bold = "Poppins-Bold"
        case boldItalic = "Poppins-BoldItalic"
        case italic = "Poppins-Italic"
        case light = "Poppins-Light"
        case lightItalic = "Poppins-LightItalic"
        case medium = "Poppins-Medium"
        case mediumItalic = "Poppins-MediumItalic"
        case regular = "Poppins-Regular"
        case thin = "Poppins-Thin"
        case thinItalic = "Poppins-ThinItalic"

        public static var familyName: String { "Poppins" }

        // Convenience computed properties
        public var weight: UIFont.Weight {
            switch self {
            case .thin, .thinItalic: return .thin
            case .light, .lightItalic: return .light
            case .regular, .italic: return .regular
            case .medium, .mediumItalic: return .medium
            case .bold, .boldItalic: return .bold
            case .black, .blackItalic: return .black
            }
        }

        public var isItalic: Bool {
            switch self {
            case .blackItalic, .boldItalic, .italic, .lightItalic, .mediumItalic, .thinItalic:
                return true
            default:
                return false
            }
        }
    }
}
