//
//  UIView+Extensions.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import UIKit

internal extension UIView {
    func firstUITableView() -> UIScrollView? {
        for subview in subviews {
            if let scrollView = subview as? UITableView {
                return scrollView
            }
            else if let scrollView = subview.firstUITableView() {
                return scrollView
            }
        }
        
        return nil
    }
}
