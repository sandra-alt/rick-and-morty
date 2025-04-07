//
//  UITableViewCell+Extension.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
