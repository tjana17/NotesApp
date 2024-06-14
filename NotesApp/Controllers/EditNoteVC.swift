//
//  EditNoteVC.swift
//  NotesApp
//
//  Created by Jana's MacBook Pro on 6/11/24.
//

import UIKit

class EditNoteVC: UIViewController {

    static let identifier = "EditNoteVC"
    var note: Note!
    weak var delegate: NotesListDelegate?
    @IBOutlet weak private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note?.text
    }
    

    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Update & Delete Func
    private func updateNote() {
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        delegate?.refreshNotes()
    }
    
    private func deleteNote() {
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }

}


// MARK: - UITextView Delegate
extension EditNoteVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        note?.title.isEmpty ?? true ? deleteNote() : updateNote()
    }
}
