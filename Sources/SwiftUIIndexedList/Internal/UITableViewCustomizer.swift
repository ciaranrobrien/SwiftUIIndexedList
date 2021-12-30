//
//  UITableViewCustomizer.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

internal struct UITableViewCustomizer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let tableView = uiView.superview?.superview?.firstUITableView()
            else { return }
            
            tableView.showsVerticalScrollIndicator = false
        }
    }
}
