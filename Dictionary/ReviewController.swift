//
//  ReviewController.swift
//  Dictionary
//
//  Created by Thao Le on 6/2/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FirebaseAuth
import RealmSwift



class CustomCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    var wid: String? = ""
   
}

class ReviewController: UIViewController, WordManagerSubscriber, UITableViewDelegate, UITableViewDataSource {
    let viewId: String = UUID.init().uuidString
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteItem: UIBarButtonItem!
    
    let refreshController: UIRefreshControl = UIRefreshControl.init()
    let reusedCell: String = "Reused cell"
    var words: [Word] = []
    var num: Int = 0
    var wordsToDelete: [String] = []
    var isDeleteAll: Int = 1 {
        didSet {
            if(self.isDeleteAll == 1) {
                deleteItem.title = "Delete All"
            }
            else if(self.isDeleteAll == 2) {
                deleteItem.title = ""
            }
            else {
                deleteItem.title = "Delete"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
//        self.navigationItem.rightBarButtonItem = editButtonItem  // ViewController inherit these property from its parent Navigation controller,
//                                                                // so there is no need to do self.navigationController?.navigationItem . But when to push to another view, it cannot do it by itself, have to navigationcontroller?.push()
        self.title = "Review"
    
//        tableView.register(CustomCell.self, forCellReuseIdentifier: reusedCell)
        
        WordManager.manager.subscribe(subscriber: self)
        
        words = WordManager.manager.fetchWord()
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        wordsToDelete = []
        tableView.isEditing = !tableView.isEditing               // this is used to set the tableview on editing mode
        sender.title = tableView.isEditing ? "Done" : "Edit"
        isDeleteAll = tableView.isEditing ? 1 : 2
    }
    

    @IBAction func deleteAllPressd(_ sender: UIBarButtonItem) {
//        guard let deleteViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteControllerSB") as? DeleteController else {return}
//        deleteViewController.modalPresentationStyle = .overCurrentContext
//        present(deleteViewController, animated: true, completion: nil)

        if(wordsToDelete.isEmpty){
            
            let actionSheet: UIAlertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActions: UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            actionSheet.addAction(cancelActions)
            
            let deleteAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: UIAlertAction.Style.destructive) { (_) in
                for word in self.words {
                    WordManager.manager.deleteWord(id: word.wid)
                }
            }
            actionSheet.addAction(deleteAction)
            
            present(actionSheet, animated: true, completion: nil)
        }
        else {
            print(wordsToDelete.count)
            for word in wordsToDelete {
                wordsToDelete.removeAll(where: {$0 == word})
                WordManager.manager.deleteWord(id: word)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return words.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusedCell, for: indexPath) as? CustomCell else {
            fatalError()
        }
        cell.label.text = words[indexPath.section].vocabulary.capitalized
        cell.wid = words[indexPath.section].wid
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // or you can do edit in the mainstoryboard
        return cell
    }

    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.init(rawValue: 3) ?? UITableViewCell.EditingStyle.none
//        // set the edditing style (3 is the style with circle and check), maybe the default style is delete
//    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "Delete") { (_, _, actionPerformed) in
            WordManager.manager.deleteWord(id: self.words[indexPath.section].wid)
            actionPerformed(true)
        }

//        delete.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        let config = UISwipeActionsConfiguration.init(actions: [delete])
        config.performsFirstActionWithFullSwipe = false        // without it, it will perform the action where it is fully swipe, like when you                                                                 have 2 actions
        return config
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.isEditing) {
            deleteItem.title = "Delete"
            wordsToDelete.append(words[indexPath.section].wid)
        }
        else {
            num = indexPath.section
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: Segue.goToSavedWord.rawValue, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for i in 0..<wordsToDelete.count {
            if (wordsToDelete[i] == words[indexPath.section].wid) {
                wordsToDelete.remove(at: i)
                if(wordsToDelete.isEmpty){
                    deleteItem.title = "Delete All"
                }
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Segue.goToSavedWord.rawValue) {
            guard let destination = segue.destination as? SavedWordDetail else {return}
            let word: Word = words[num]
            destination.word.vocabulary = word.vocabulary
            destination.word.speech = word.speech
            destination.word.usedInSentence = word.usedInSentence
            destination.word.translation = word.translation
        }
    }
    
    func subscriberId() -> String {
        return viewId
    }
    
    func didAddWord(word: Word) {
        words.insert(word.duplicate(), at: 0)
        tableView.insertSections(IndexSet(integer: 0), with: .fade)
    }
    
    func didDeleteWord(wid: String) {
        guard let index = words.firstIndex(where: { $0.wid == wid }) else { return }
        words.remove(at: index)
        tableView.deleteSections(IndexSet(integer: index), with: .fade)
        print(tableView.isEditing)
        if(wordsToDelete.isEmpty){
            deleteItem.title = "Delete All"
        }
        if(words.isEmpty){
            tableView.isEditing = false
            deleteItem.title = ""
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        
        UtilityFunctions.deleteWord(wid: wid)
    }
    
    func didSavedInSentence(wid: String, content: String) {
        words.first(where: {$0.wid == wid})?.usedInSentence = content
    }
  
}


