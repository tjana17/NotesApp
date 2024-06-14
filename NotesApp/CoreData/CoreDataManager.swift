//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Jana's MacBook Pro on 6/13/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "NotesApp")
    
    let persistentContainer : NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    //MARK: - Save, Delete Functions
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error occured while saving: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - Helper Functions: - Create, Fetch, Delete
extension CoreDataManager {
    func createNote() -> Note {
        let note = Note(context: viewContext)
        //Initialize the variables
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        
        save()
        
        return note
    }
    
    func fetchNotes(_ filter: String? = nil) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let filter = filter {
            //Using apple's NSPerdicate function.
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("An error occured while fetching")
            return []
        }
    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        save()
    }
}
