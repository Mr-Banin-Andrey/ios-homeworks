
import Foundation
import UIKit
import SnapKit

protocol DocumentsViewDelegate: AnyObject {
    func addImage()
}

class DocumentsView: UIView {
    
    private weak var delegate: DocumentsViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    
    init(delegate: DocumentsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCellId")
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func navigationController(
        navigation: UINavigationItem,
        title: String
    ) {
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(addImage))
        
        rightButton.tintColor = UIColor(named: "blueColor")
        
        navigation.title = title
        navigation.rightBarButtonItems = [rightButton]
        navigation.rightBarButtonItem = rightButton
    }
    
    private func setupUI() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    @objc private func addImage() {
        delegate?.addImage()
    }
}
