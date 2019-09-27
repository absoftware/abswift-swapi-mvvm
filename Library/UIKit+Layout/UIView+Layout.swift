//
//  UIView+Layout.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

/// This extension simplifies code related to constraints.
extension UIView {
    
    // MARK: - Subviews
    
    func addSubview(_ view: UIView, completion: (_ view: UIView) -> Void) {
        self.addSubview(view)
        completion(view)
    }
    
    func insertSubview(_ view: UIView, at index: Int, completion: (_ view: UIView) -> Void) {
        self.insertSubview(view, at: index)
        completion(view)
    }
    
    // MARK: - Size
    
    @discardableResult
    func width(_ width: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func height(_ height: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Size to other size
    
    @discardableResult
    func width(to anchor: NSLayoutDimension, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func height(to anchor: NSLayoutDimension, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.heightAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Constraints equal to parent
    
    @discardableResult
    func left(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.leftAnchor.constraint(equalTo: self.superview!.leftAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func top(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func right(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func right(offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func bottom(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func bottom(offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func fill(inset: CGFloat = 0.0) {
        self.top(offset: inset)
        self.right(offset: -inset)
        self.bottom(offset: -inset)
        self.left(offset: inset)
    }
    
    // MARK: - Safe constraints equal to parent
    
    @discardableResult
    func leftSafe(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            let constraint = self.leftAnchor.constraint(
                equalTo: self.superview!.safeAreaLayoutGuide.leftAnchor,
                constant: offset)
            constraint.isActive = true
            return constraint
        } else {
            return self.left(offset: offset)
        }
    }
    
    @discardableResult
    func topSafe(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            let constraint = self.topAnchor.constraint(
                equalTo: self.superview!.safeAreaLayoutGuide.topAnchor,
                constant: offset)
            constraint.isActive = true
            return constraint
        } else {
            return self.top(offset: offset)
        }
    }
    
    @discardableResult
    func rightSafe(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            let constraint = self.rightAnchor.constraint(
                equalTo: self.superview!.safeAreaLayoutGuide.rightAnchor,
                constant: offset)
            constraint.isActive = true
            return constraint
        } else {
            return self.right(offset: offset)
        }
    }
    
    @discardableResult
    func bottomSafe(offset: CGFloat = 0.0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            let constraint = self.bottomAnchor.constraint(
                equalTo: self.superview!.safeAreaLayoutGuide.bottomAnchor,
                constant: offset)
            constraint.isActive = true
            return constraint
        } else {
            return self.bottom(offset: offset)
        }
    }
    
    // MARK: - Constraints equal to anchor
    
    @discardableResult
    func left(to anchor: NSLayoutXAxisAnchor, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.leftAnchor.constraint(equalTo: anchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func top(to anchor: NSLayoutYAxisAnchor, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.topAnchor.constraint(equalTo: anchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func right(to anchor: NSLayoutXAxisAnchor, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.rightAnchor.constraint(equalTo: anchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func bottom(to anchor: NSLayoutYAxisAnchor, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.bottomAnchor.constraint(equalTo: anchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Constraints equal to view controller
    
    @discardableResult
    func leftSafe(to viewController: UIViewController, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            constraint = self.leftAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leftAnchor, constant: offset)
        } else {
            constraint = self.leftAnchor.constraint(equalTo: viewController.view.leftAnchor, constant: offset)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func topSafe(to viewController: UIViewController, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            constraint = self.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: offset)
        } else {
            constraint = self.topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor, constant: offset)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func rightSafe(to viewController: UIViewController, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            constraint = self.rightAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.rightAnchor, constant: offset)
        } else {
            constraint = self.rightAnchor.constraint(equalTo: viewController.view.rightAnchor, constant: offset)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func bottomSafe(to viewController: UIViewController, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            constraint = self.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: offset)
        } else {
            constraint = self.bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor, constant: offset)
        }
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Center equal to parent
    
    @discardableResult
    func centerX(offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerY(offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Center equal to view
    
    @discardableResult
    func centerX(to view: UIView, offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerY(to view: UIView, offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Center equal to anchor
    
    @discardableResult
    func centerX(to anchor: NSLayoutXAxisAnchor, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.centerXAnchor.constraint(equalTo: anchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerY(to anchor: NSLayoutYAxisAnchor, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: anchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
}
