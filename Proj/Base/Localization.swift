//
//  Localization.swift
//  Workphone
//
//  Created by Vitalii Yevtushenko on 11/15/17.
//  Copyright © 2017 Smarsh. All rights reserved.
//

import Foundation
import RxSwift

/// Creates an observable for given localization key.
///
/// - Parameter key: Localization key.
/// - Returns: Observable of the key translation in current localization.
public func L(_ key: String) -> Observable<String> {
    return Localization
        .current
        .asObservable()
        .subscribeOn(MainScheduler.instance)
        .map { $0.localize(key) }
}

/// Localize string.
///
/// - Parameter key: String to localize.
/// - Returns: Localized string.
public func LL(_ key: String) -> String {
    return Localization.current.value.localize(key)
}

/// Encapsulates current localization of the application.
public class Localization {

    /// Current localization.
    public static var current = Variable(Localization.auto())

    /// ISO language code.
    public let langCode: String

    var base: [String: String]
    var lang: [String: String]

    /// Desired constructor
    ///
    /// - Parameter langCode: ISO language code.
    public init(langCode: String) {
        self.langCode = langCode

        let bundle = Bundle.main

        guard let baseUrl = bundle.url(forResource: "Base", withExtension: "lproj") else {
            fatalError("There is no 'Base.lproj' directory in the application bundle.")
        }

        self.base = NSDictionary(contentsOf: baseUrl.appendingPathComponent("Localizable.strings")) as? [String:String] ?? [:]

        guard let langUrl = bundle.url(forResource: langCode, withExtension: "lproj") else {
            self.lang = [:]
            return
        }

        let langUrl2 = langUrl.appendingPathComponent("Localizable.strings")
        
        guard FileManager.default.fileExists(atPath: langUrl2.path) else {
            self.lang = [:]
            return
        }
        
        self.lang = NSDictionary(contentsOf: langUrl2) as? [String:String] ?? [:]
    }

    func localize(_ l: String) -> String {
        if let lang = lang[l] { return lang }
        if let base = base[l] { return base }
        return l
    }

    /// Create localization from current user locale.
    ///
    /// - Returns: Created localization.
    public static func auto() -> Localization {
        return Localization(langCode: Locale.preferredLanguages.first ?? "en")
    }
}
