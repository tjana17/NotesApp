//
//  NotesListVC.swift
//  NotesApp
//
//  Created by Jana's MacBook Pro on 6/11/24.
//

import UIKit


protocol NotesListDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class NotesListVC: UIViewController {
    
    static let identifier = "NotesListVC"
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var notesCountLbl: UILabel!
    
    private var filteredNotes: [Note] = []
    private var searchController = UISearchController()
    
    private var notes: [Note] = [] {
        didSet {
            let notesCount = "\(notes.count) \(notes.count == 1 ? "Note" : "Notes")"
            notesCountLbl.text = notesCount
            filteredNotes = notes
        }
    }

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setupSearchBar()
        fetchNotes()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setNoteIndex(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }

    @IBAction func createNoteTapped(_ sender: UIButton) {
        navigateToEdit(createNote())
    }
    
    private func navigateToEdit(_ note: Note) {
        let vc = storyboard?.instantiateViewController(identifier: EditNoteVC.identifier) as! EditNoteVC
        vc.note = note
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actionary Methods
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        // Update tableView
        notes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func fetchNotes() {
        notes = CoreDataManager.shared.fetchNotes()
    }

    private func deleteNote(_ note: Note) {
        // Update the list
        deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
    
    private func searchNotes(_ text: String) {
        notes = CoreDataManager.shared.fetchNotes(text)
        tableView.reloadData()
    }
}

//MARK: - UISearchController Delegates
extension NotesListVC: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotes(query)
    }
    
    func search(_ query: String) {
        if query.count >= 1 {
            filteredNotes = notes.filter { $0.text.lowercased().contains(query.lowercased())
            }
        } else{
            filteredNotes = notes
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - UITableView DataSource
extension NotesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesListCell.identifier) as? NotesListCell else { return UITableViewCell ()}
        cell.setupCell(note: filteredNotes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - UITableView Delegates
extension NotesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToEdit(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - NotesList Delegate
extension NotesListVC: NotesListDelegate {
    
    func refreshNotes() {
        notes = notes.sorted { $0.lastUpdated > $1.lastUpdated }
        tableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = setNoteIndex(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // It doesn't come back when we search from array.
        notes.remove(at: setNoteIndex(id: id, in: notes).row)
    }
}
