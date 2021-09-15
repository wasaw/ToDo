//
//  HomeController.swift
//  ToDo
//
//  Created by Александр Меренков on 9/14/21.
//

import UIKit

class HomeController: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var cellCount = 1
    private let inserts = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifire)
        tableView.rowHeight = 60
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.refreshControl = refreshControl
        refreshControl.isHidden = true 
        refreshControl.addTarget(self, action: #selector(addNewCell), for: .valueChanged)
        
        tableView.backgroundColor = .lightGray
    }
    
    @objc func addNewCell() {
        cellCount += 1
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifire, for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            cellCount -= 1
//            tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


