//
//  CryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by Zoe Schmitt on 3/10/19.
//  Copyright © 2019 Zoe Schmitt. All rights reserved.
//

import UIKit

private let headerHeight: CGFloat = 100.0
private let netWorthHeight: CGFloat = 45.0


class CryptoTableViewController: UITableViewController, CoinDataDelegate {
    
    var amountLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoinData.shared.getPrices()     //go ahead and load the prices
    }
    
    //this helps with loading (telling the delegate we are now back on this view controller)
    override func viewWillAppear(_ animated: Bool) {
        
        CoinData.shared.delegate = self //saying the delegate var in CoinData is equal to cryptoTableViewController class
        tableView.reloadData()
        displayNetWorth()
        navigationController?.title = "Crypto Currencies"
    }
    
    //this gets called when we get new data from the api in coinData
    func newPrices() {
        //tells the table view to reload the 2 tableview functions
        tableView.reloadData()
        displayNetWorth()
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight))
        headerView.backgroundColor = UIColor.white
        
        let netWorthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: netWorthHeight))
        netWorthLabel.text = "My crypto networth"
        netWorthLabel.textAlignment = .center
        headerView.addSubview(netWorthLabel)
        
        amountLabel.frame = CGRect(x: 0, y: netWorthHeight, width: view.frame.size.width, height: headerHeight - netWorthHeight)
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont.boldSystemFont(ofSize: 60.0)
        headerView.addSubview(amountLabel)
        
        displayNetWorth()
        
        return headerView
    }
    
    func displayNetWorth() {
        
        amountLabel.text = CoinData.shared.netWorthAsString()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
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
        
        if coin.amount != 0.0 {
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString()) - \(coin.amount)"
        }
        else {
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
        }
        
        cell.imageView?.image = coin.image      //image view = coin image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //instance of coinViewController
        let coinVC = CoinViewController()
        
        //coinVC.coin is = to whatever coin was selected
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        
        //pretty much a showsegue!
        navigationController?.pushViewController(coinVC, animated: true)
    }

}
