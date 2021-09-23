//
//  HomeController.swift
//  ToDo
//
//  Created by Александр Меренков on 9/14/21.
//

import UIKit
import CoreData

protocol GetTextProtocol {
    func sendText(text: String, index: Int)
}

class HomeController: UIViewController, GetTextProtocol {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var cellCount = 1
    private var haveDataInCore = false
    private var arrNote = [String]()
    private let inserts = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
                        
    var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.tableFooterView = UIView()
        
        if checkValueInDatabase() {
            haveDataInCore = true
        }
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
                
//        tableView.backgroundColor = .systemBackground
        tableView.backgroundColor = .init(red: 11/255, green: 19/255, blue: 43/255, alpha: 1)
    }
    
    @objc func addNewCell() {
        cellCount += 1
        arrNote.append("")
        UIView.animate(withDuration: 0.5) {
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
        self.refreshControl.endRefreshing()
        
    }
    
    func sendText(text: String, index: Int) {
        if arrNote.count == index {
            saveValue(text: text, index: index)
        } else {
            updateValue(text: text, index: index)
        }
    }
    
    func checkValueInDatabase() -> Bool {
        if !readValue() {
            return false
        }
        return true
    }
    
    func saveValue(text: String, index: Int) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "List", in: context) else { return }
        
        let newValue = NSManagedObject(entity: entity, insertInto: context)
        
        newValue.setValue(index, forKey: "idCell")
        newValue.setValue(text, forKey: "textNote")
        arrNote.append(text)
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func readValue() -> Bool {
        guard let context = context else { return false }
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        
        do {
            let result = try context.fetch(featchRequest)
            if result.count == 0 {
                return false
            }
            arrNote = []
            for data in result {
                if let data = data as? NSManagedObject {
                    arrNote.append(data.value(forKey: "textNote") as? String ?? "")
                }
            }
            cellCount = result.count
        } catch {
            print(error)
        }
        return true
    }
    
    func updateValue(text: String, index: Int) {
        guard let context = context else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        fetchRequest.predicate = NSPredicate(format: "idCell == %@", "\(index)")
        do {
            let result = try context.fetch(fetchRequest)
            guard let value = result.first as? NSManagedObject else { return }
            value.setValue(text, forKey: "textNote")
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteValue(text: String) {
        guard let context = context else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        fetchRequest.predicate = NSPredicate(format: "textNote = %@", text)
        do {
            let result = try context.fetch(fetchRequest)
            guard let value = result.first as? NSManagedObject else { return }
            context.delete(value)
            try context.save()
        } catch {
            print(error)
        }
    }
}

//  MARK: - extension
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifire, for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        cell.delegateText = self

        if haveDataInCore {
//            print out note in reverse order
            let index = arrNote.count - indexPath.row - 1
            cell.setTextFieldText(title: arrNote[index], index: index)
            if cellCount - 1 == indexPath.row{
                haveDataInCore = false
            }
        }else {
            cell.setTextFieldText(title: "", index: arrNote.count)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            cellCount -= 1
           
//            print out note in reverse order
            let index = arrNote.count - indexPath.row - 1
            print("cellCount \(cellCount), arrNote.count \(arrNote.count), index \(index)")
            if arrNote.count != 0 {
                deleteValue(text: arrNote[index])
                arrNote.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        
//            tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
