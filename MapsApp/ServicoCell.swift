//
//  ServicoCell.swift
//  MapsApp
//
//  Created by Blanko Mac-dev on 01/08/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit

class ServicoCell: UITableViewCell {

    @IBOutlet weak var servicoIcon: UIImageView!
    @IBOutlet weak var servicoTitle: UILabel!
    @IBOutlet weak var servicoPrecoTipo1: UILabel!
    @IBOutlet weak var servicoPrecoTipo2: UILabel!
    @IBOutlet weak var servicoPrecoTipo3: UILabel!
    
    var tipos: [UILabel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tipos = [self.servicoPrecoTipo1, self.servicoPrecoTipo2, self.servicoPrecoTipo3]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
