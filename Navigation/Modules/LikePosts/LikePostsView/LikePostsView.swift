

import Foundation
import UIKit
import SnapKit

protocol LikePostsViewDelegate: AnyObject {
    func filterPosts()
    func cancelFilter()
}

@available(iOS 16.0, *)
class LikePostsView: UIView {
    
    private weak var delegate: LikePostsViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var rightButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(filterPosts))
    
    lazy var leftButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelFilter))
    
    
    init(delegate: LikePostsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.setupUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurationTableView(
        dataSourse: UITableViewDataSource,
        delegate: UITableViewDelegate
    ) {
        tableView.dataSource = dataSourse
        tableView.delegate = delegate
        tableView.register(PostCustomTableViewCell.self, forCellReuseIdentifier: "tableId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    
    func navigationController(title: String, navigation: UINavigationItem, rightButton: UIBarButtonItem, leftButton: UIBarButtonItem) {
        
        rightButton.tintColor = UIColor(named: "blueColor")
        leftButton.tintColor = #colorLiteral(red: 0.9125478316, green: 0.1491314173, blue: 0, alpha: 1)
        leftButton.isHidden = true
        
        navigation.title = title
        navigation.rightBarButtonItems = [rightButton]
        navigation.rightBarButtonItem = rightButton
        navigation.leftBarButtonItems = [leftButton]
        navigation.leftBarButtonItem = leftButton
    }
    
    private func setupUi() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
    }
    
//    func showAlert(vc: UIViewController, title: String, message: String, button: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: button, style: .default)
//        alert.addAction(action)
//        
//        vc.present(alert, animated: true)
//    }
    
    @objc private func filterPosts() {
        delegate?.filterPosts()
    }
    
    @objc private func cancelFilter() {
        delegate?.cancelFilter()
    }

}
