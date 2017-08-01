//
//  ModalServicosController.swift
//  MapsApp
//
//  Created by Blanko Mac-dev on 01/08/17.
//  Copyright © 2017 Leo Valentim. All rights reserved.
//

import UIKit

struct TipoServico {
    var titulo: String
    var preco: String
}

struct Servico {
    var titulo: String
    var tipos: [TipoServico]
    var icon: UIImage
}

class ModalServicosController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var servicos: [Servico] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.servicos = [
            Servico(titulo: "Uber", tipos: [
                    TipoServico(titulo: "UberPOOL", preco: "R$10.00"),
                    TipoServico(titulo: "UberX", preco: "R$15.00"),
                    TipoServico(titulo: "UberSelect", preco: "R$20.00")
                ], icon: UIImage(named: "Uber-icon")!)
        ]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servicos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicoCell", for: indexPath) as! ServicoCell
        
        cell.servicoTitle.text = self.servicos[indexPath.row].titulo
        cell.servicoIcon.image = self.servicos[indexPath.row].icon
        for i in 0 ... (self.servicos[indexPath.row].tipos.count - 1) {
            if i < cell.tipos.count && i < self.servicos[indexPath.row].tipos.count {
                cell.tipos[i].isHidden = false
                cell.tipos[i].text = "\(self.servicos[indexPath.row].tipos[i].titulo): \(self.servicos[indexPath.row].tipos[i].preco)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }

}
