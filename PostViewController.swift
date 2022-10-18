//
//  PostViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class PostViewController: UIViewController {
    
    var titleView = Post(title: "Заголовок 2")
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .cyan
//      setupUI()
        setupConstraints()
        titleLabel.text = titleView.title
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddTapped))
        navigationItem.rightBarButtonItems = [add]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddTapped))
    }
    
//    func setupUI() {
//        setupConstraints()
//        titleLabel.text = titleView.title
//    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.firstBaselineAnchor, constant: 65),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func showAddTapped() {
        let addTapped = InfoViewController()
        navigationController?.pushViewController(addTapped, animated: true)
    }
}
