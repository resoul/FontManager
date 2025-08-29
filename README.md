# FontManager

[![Swift Package Manager compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS-lightgrey.svg)](https://swift.org/package-manager/)
[![Swift](https://img.shields.io/badge/swift-5.9-orange.svg)](https://swift.org)

`FontManager` is a modern Swift Package that provides a sophisticated and efficient way to manage custom fonts (such as Montserrat, Roboto, and Amazon fonts) in iOS and tvOS applications. Built with AtomicKit integration for dependency injection, logging, and architectural patterns.

## ✨ Features

- 🎨 **Selective Font Loading**: Load only the font families you need to optimize app size
- 🏗️ **Dependency Injection**: Fully integrated with AtomicKit's DI container
- 📝 **Comprehensive Logging**: Detailed font registration logging with configurable levels
- 🔧 **Type-Safe API**: Strongly typed font access with compile-time safety
- 🚀 **Performance Optimized**: Thread-safe operations with efficient font caching
- 🛡️ **Error Handling**: Robust error handling with fallback fonts
- 🏛️ **Architectural Patterns**: Service-oriented design following SOLID principles
- 📊 **Font Metadata**: Access font weight and style information programmatically

## 🚀 Getting Started

### 1. Adding Dependencies

Add both `FontManager` and `AtomicKit` to your Xcode project. In your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/resoul/FontManager.git", from: "2.0.0"),
    .package(url: "https://github.com/resoul/AtomicKit.git", from: "1.0.0")
]
```

### 2. Configure Dependency Injection

Set up the FontManager module in your app's dependency configuration:

```swift
import FontManager
import AtomicKit

// In your app's configuration (AppDelegate or App init)
Configurator.configure(
    services: [FontModule()],
    container: SafeContainer.shared
)
```

### 3. Register Fonts

#### Simple Registration
```swift
import FontManager

// Using the injected service
class MyViewController: UIViewController {
    @FontServiceInjected private var fontService: FontService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register specific font family
        fontService.registerFonts(fontFamily: Fonts.Montserrat.self)
    }
}
```

#### Advanced Registration with Builder Pattern
```swift
import FontManager
import AtomicKit

// Using the builder pattern for advanced configuration
let fontManager = FontManagerBuilder()
    .enableLogging(.debug)
    .addFontFamily(Fonts.Montserrat.self)
    .addFontFamily(Fonts.Roboto.self)
    .build()

// Or register all available fonts
fontManager.registerAllAvailableFonts()
```

### 4. Using Fonts

#### Basic Usage
```swift
import UIKit
import FontManager

let titleLabel = UILabel()
titleLabel.font = UIFont.montserrat(.bold, size: 24)

let bodyLabel = UILabel()
bodyLabel.font = UIFont.roboto(.regular, size: 16)
```

#### With Fallback Support
```swift
// Automatically falls back to system font if custom font unavailable
let titleLabel = UILabel()
titleLabel.font = UIFont.montserratWithFallback(.bold, size: 24, fallback: .bold)

let subtitleLabel = UILabel()
subtitleLabel.font = UIFont.robotoWithFallback(.light, size: 14, fallback: .light)
```

#### Using Dependency Injection
```swift
class ProfileViewController: UIViewController {
    @FontServiceInjected private var fontService: FontService
    @LoggerInjected private var logger: Logger
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFonts()
    }
    
    private func setupFonts() {
        // Check if font family is registered
        guard fontService.isRegistered(Fonts.Montserrat.self) else {
            logger.warning("Montserrat font family not registered")
            return
        }
        
        // Use specific font
        if let font = fontService.getFont(Fonts.Montserrat.semiBold, size: 18) {
            titleLabel.font = font
        }
    }
}
```

## 🎨 Available Fonts

### Montserrat Family
```swift
Fonts.Montserrat.thin
Fonts.Montserrat.light
Fonts.Montserrat.regular
Fonts.Montserrat.medium
Fonts.Montserrat.semiBold
Fonts.Montserrat.bold
Fonts.Montserrat.black
// + Italic variants for all weights
```

### Roboto Family
```swift
Fonts.Roboto.thin
Fonts.Roboto.light
Fonts.Roboto.regular
Fonts.Roboto.medium
Fonts.Roboto.bold
Fonts.Roboto.black
// + Italic variants for all weights
```

### Amazon Family
```swift
Fonts.Amazon.emberRegular
Fonts.Amazon.emberDisplayRegular
```

## 🏗️ Architecture

FontManager follows modern iOS architecture patterns:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   FontService   │    │   FontManager    │    │  AtomicKit DI   │
│   (Protocol)    │◄───│ (Implementation) │◄───│   Container     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ▲                        │                       │
         │                        ▼                       │
┌─────────────────┐    ┌──────────────────┐               │
│  UIFont+Ext     │    │     Logging      │               │
│  (Extensions)   │    │   Integration    │               │
└─────────────────┘    └──────────────────┘               │
         ▲                        │                       │
         │                        ▼                       │
┌─────────────────┐    ┌──────────────────┐               │
│   View Layer    │    │  Error Handling  │               │
│ (UI Components) │    │   & Fallbacks    │◄──────────────┘
└─────────────────┘    └──────────────────┘
```

## 🔧 Advanced Configuration

### Custom Font Configuration
```swift
let configuration = FontConfiguration(
    families: [Fonts.Montserrat.self, Fonts.Roboto.self],
    enableLogging: true,
    logLevel: .debug
)

let fontManager = FontManagerBuilder()
    .with(configuration: configuration)
    .build()
```

### Modular Registration
```swift
// Register fonts in specific modules
class DesignModule: ServiceModule {
    func configure(container: Container) {
        // Register FontService
        container.registerSingleton(FontService.self) { _ in
            let fontManager = FontManager()
            fontManager.registerFonts(fontFamily: Fonts.Montserrat.self)
            return fontManager
        }
    }
}
```

## 📊 Font Metadata

Access font information programmatically:

```swift
let style = Fonts.Montserrat.semiBold
print(style.familyName)  // "Montserrat"
print(style.weight)      // UIFont.Weight.semibold
print(style.isItalic)    // false

// Use metadata for dynamic font selection
let fonts = Fonts.Montserrat.allCases.filter { !$0.isItalic }
let regularFonts = fonts.filter { $0.weight == .regular }
```

## 🐛 Debugging

Enable detailed logging to troubleshoot font registration:

```swift
// Enable debug logging
AtomicLogger.shared = ConsoleLogger(minimumLevel: .debug)

// Font registration will now log:
// 🎨 Starting font registration for family: Montserrat
// ✅ Font 'Montserrat-Regular' successfully registered  
// 🎨 Font registration completed for Montserrat
```

## 📱 SwiftUI Integration

```swift
import SwiftUI
import FontManager

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.custom(Fonts.Montserrat.bold.rawValue, size: 24))
            
            Text("Subtitle")
                .font(.custom(Fonts.Roboto.light.rawValue, size: 16))
        }
    }
}
```

## 🧪 Testing

FontManager includes comprehensive testing utilities:

```swift
import XCTest
@testable import FontManager

class FontManagerTests: XCTestCase {
    func testFontRegistration() {
        let fontManager = FontManager()
        
        fontManager.registerFonts(fontFamily: Fonts.Montserrat.self)
        
        XCTAssertTrue(fontManager.isRegistered(Fonts.Montserrat.self))
        XCTAssertNotNil(fontManager.getFont(Fonts.Montserrat.regular, size: 16))
    }
}
```

## 🚀 Performance Tips

1. **Selective Loading**: Only register font families you actually use
2. **Early Registration**: Register fonts during app startup for best performance
3. **Caching**: FontManager automatically caches registered fonts
4. **Thread Safety**: All operations are thread-safe by design

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines for more details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- 📚 [Documentation](https://github.com/yourusername/fontmanager/wiki)
- 🐛 [Issues](https://github.com/yourusername/fontmanager/issues)
- 💬 [Discussions](https://github.com/yourusername/fontmanager/discussions)

---

**Built with ❤️ using AtomicKit architecture patterns**