//
//  NotesListCell.swift
//  NotesApp
//
//  Created by Jana's MacBook Pro on 6/11/24.
//

import UIKit

class NotesListCell: UITableViewCell {

    static let identifier = "NotesListCell"
    
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var descriptionLbl: UILabel!
    @IBOutlet weak private var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(note: Note) {
        titleLbl.text = note.title
        descriptionLbl.text = note.desc
        timeLbl.text = note.time
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
