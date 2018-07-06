//
//  NoteCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

protocol NoteDelegate: class {
    func returnNote(note: String?)
    func scrollToBottom()
}

class NoteCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noteLabel: ActivityLabel!
    @IBOutlet weak var noteTextView: NoteTextView!
    weak var delegate : NoteDelegate?
    
    var bpReading : BloodPressureReading! {
        didSet {
            if let note = bpReading.note {
                noteTextView.text = note
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.dmsCloudyBlue
        containerView.layer.shadowColor = UIColor.dmsCloudyBlueTwo.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 1.0
        noteTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.returnNote(note: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.scrollToBottom()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 151

    }
}
