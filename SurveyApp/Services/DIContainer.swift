//
//  DIContainer.swift
//  SurveyApp
//
//  Created by Антон Петренко on 18/02/2024.
//

import SwiftUI

public protocol Resolver {
    func resolveDependency<T>() -> T
}

public enum ContainerScope {
    /// Create a new instance on each call.
    case transient
    
    /// Create only a single instance and cache it.
    case container
}

class DIContainer: ObservableObject, Resolver {
    
    static let shared = DIContainer()

    private var factories: [ObjectIdentifier: (Resolver) -> Any] = [:]
    private var containerObjects: [ObjectIdentifier: Any] = [:]
    
    // MARK: Public
    
    public func register<T>(scope: ContainerScope, factory: @escaping (Resolver) -> T) {
        let key = key(for: T.self)
        switch scope {
        case .transient:
            factories[key] = factory
        case .container:
            factories[key] = { [weak self] resolver in
                if let instance = self?.containerObjects[key] {
                    return instance
                } else {
                    let instance = factory(resolver)
                    self?.containerObjects[key] = instance
                    return instance
                }
            }
        }
    }
    
    public func resolveDependency<T>() -> T {
        guard let factory = factories[key(for: T.self)] else {
            fatalError("No factory found for \(T.self)")
        }
        return factory(self) as! T
    }
    
    // MARK: Private
    
    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}
