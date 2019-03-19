//
//  CryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by Zoe Schmitt on 3/10/19.
//  Copyright © 2019 Zoe Schmitt. All rights reserved.
//

import UIKit

class CryptoTableViewController: UITableViewController, CoinDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoinData.shared.delegate = self //saying the delegate var in CoinData is equal to cryptoTableViewController class
        CoinData.shared.getPrices()     //go ahead and load the prices
    }
    
    //this gets called when we get new data from the api in coinData
    func newPrices() {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //calls CoinData singleton and counts the amount of symbols there are in the coins array
        //to decide how many rows to set.
        return CoinData.shared.coins.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()    //cell = to an empty UITableViewCell
        
        //let coin = instance of CoinData singleton coins array row wise
        let coin = CoinData.shared.coins[indexPath.row]
        cell.textLabel?.text = "\(coin.symbol) - \(coin.price)"     //text label = coin symbol
        cell.imageView?.image = coin.image      //image view = coin image

        return cell
    }
    

}
