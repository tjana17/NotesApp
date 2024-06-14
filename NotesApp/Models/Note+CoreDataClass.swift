//
//  Note+CoreDataClass.swift
//  NotesApp
//
//  Created by Jana's MacBook Pro on 6/13/24.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    var title: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? "" // returns the first line of the text.
        }
    
        var desc: String {
            var lines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
            lines.removeFirst()
            return "\(lines.first ?? "")" // return second line.
        }
    
        var time: String {
            return "\(lastUpdated.format())" // return updated time.
        }
}
