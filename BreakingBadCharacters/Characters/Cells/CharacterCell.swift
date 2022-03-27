//
//  CharacterCell.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import UIKit
import Kingfisher

class CharacterCell: UITableViewCell {
    
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var characterNameLabel: UILabel!
    @IBOutlet var characterNameBackground: UIView!
    
    var character: Character? {
        didSet{
            guard let character = character else { return }
            configureView(character: character)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        characterNameBackground.alpha = 0.4
    }
    
    override func prepareForReuse() {
        characterImageView.image = nil
        characterNameLabel.text = nil
    }
    
    private func configureView(character: Character){
        self.characterNameLabel.text = character.characterName
        guard let url = character.imageUrl else { return }
        self.characterImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
    
}
