//
//  ViewController.swift
//  gt-hw-4-5
//
//  Created by ake11a on 2022-11-14.
//

import UIKit
import SnapKit
import RealmSwift

class ViewController: UIViewController {
    
//    var notes: [Note]? = [
//    Note(name: "Buy list", description: "Milk")]
   
    let realm = try! Realm()
    
    var notes: Results<NoteRealm>?
    
    var buttonSizeCoefficient: CGFloat = 5
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "toDo")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "To DO"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView()
     
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "note_cell")
        tableView.backgroundColor = UIColor(red: 90 / 255, green: 115 / 255, blue: 199 / 255, alpha: 255 / 255)
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.separatorInset.bottom = 5
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
       
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .green
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 40)
        
        button.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        button.layer.cornerRadius = (view.frame.width / buttonSizeCoefficient) / 2
        return button
    }()
    
    private lazy var newNoteTextField: UITextField = {
        let textField = UITextField();
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 90 / 255, green: 115 / 255, blue: 199 / 255, alpha: 255 / 255)
        
        notes = realm.objects(NoteRealm.self)
        
        setupSubviews()
    }

    func setupSubviewsSnap() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            //make.top.equalTo(view.safeAreaLayoutGuide.bottomAnchor)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(notesTableView)
        notesTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-40)
            make.width.height.equalTo(view.frame.width / 4)
        }

    }

    func setupSubviews() {
       
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(notesTableView)
        view.addSubview(addButton)
        
        let titleImageViewTop = titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let titleImageViewLeading = titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        let titleImageViewWidth = titleImageView.widthAnchor.constraint(equalToConstant: 60)
        let titleImageViewHeight = titleImageView.heightAnchor.constraint(equalToConstant: 30)

        let titleLabelTop = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let titleLabelLeading = titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 10)
        let titleLabelTrailing = titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let titleLabelHeight = titleLabel.heightAnchor.constraint(equalToConstant: 30)
        
        let notesTableViewTop = notesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        let notesTableViewLeading = notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        let notesTableViewTrailing = notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        let notesTableViewBottom = notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        let addButtonTrailing = addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        let addButtonBottom = addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        let addButtonWidth = addButton.widthAnchor.constraint(equalToConstant: view.frame.width / buttonSizeCoefficient)
        let addButtonHeight = addButton.heightAnchor.constraint(equalToConstant: view.frame.width / buttonSizeCoefficient)
        
        NSLayoutConstraint.activate([
            titleImageViewTop, titleImageViewLeading, titleImageViewWidth, titleImageViewHeight,
            titleLabelTop, titleLabelTrailing, titleLabelLeading, titleLabelHeight,
            notesTableViewTop, notesTableViewTrailing, notesTableViewLeading, notesTableViewBottom,
            addButtonTrailing, addButtonBottom, addButtonWidth, addButtonHeight
        ])
    }
    
    @objc func addNote() {
        
        let alertController = UIAlertController(title: "New note", message: "Text the note", preferredStyle: .alert)
        
        alertController.addTextField { text in
            self.newNoteTextField = text
        }
        
        let actionAdd = UIAlertAction(title: "Add", style: .destructive) { [self] action in
            
            let newNote = NoteRealm()
            newNote.name = newNoteTextField.text!
            
            try! realm.write( {
                realm.add(newNote)
            })
            
            notesTableView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            ()
        }
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = notes?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note_cell", for: indexPath) as! NoteTableViewCell
        if let name = notes?[indexPath.section].name {
            cell.textLabel?.text = name
        }
        cell.imageView?.image = UIImage(systemName: "poweroff")
        cell.detailTextLabel?.text = "subtitle"
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write( {
                realm.delete(notes![indexPath.row])
            })
            
            notesTableView.reloadData()
        }
    }
}
