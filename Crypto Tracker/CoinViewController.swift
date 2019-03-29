//
//  CoinViewController.swift
//  Crypto Tracker
//
//  Created by Zoe Schmitt on 3/18/19.
//  Copyright © 2019 Zoe Schmitt. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHeight: CGFloat = 300.0
private let imageSize: CGFloat = 100.0
private let priceLabelHeight: CGFloat = 25.0


class CoinViewController: UIViewController, CoinDataDelegate {

    var chart = Chart() //chart is = to a new chart object
    var coin: Coin?     //optional Coin var
    var priceLabel = UILabel()
    var youOwnLabel = UILabel()
    var worthLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let coin = coin {
            CoinData.shared.delegate = self //saying the delegate var in CoinData is equal to current ViewController class
            edgesForExtendedLayout = []     //makes the chart stay under the nav bar
            view.backgroundColor = UIColor.white //background color = white
            title = coin.symbol
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
            
            chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight) //chart size
            chart.yLabelsFormatter = {
                CoinData.shared.doubleToMoneyString(randomDouble: $1)
                //gonna control the format of the y's on the chart
            }
            chart.xLabels = [5,10,15,20,25,30]
            chart.xLabelsFormatter = {
                String(Int(round(30 - $1))) + "d"
            }
            
            view.addSubview(chart)  //adding the graph
            
            let imageView = UIImageView(frame: CGRect(x: view.frame.size.width / 2 - imageSize / 2, y: chartHeight, width: imageSize, height: imageSize))
            imageView.image = coin.image
            view.addSubview(imageView)
            
            //pricelabel is declared world wide bc it needs to be used in a function below. all others created locally
            priceLabel.frame = CGRect(x: 0, y: chartHeight + imageSize, width: view.frame.size.width, height: priceLabelHeight)
            priceLabel.textAlignment = .center
            view.addSubview(priceLabel)
            
            youOwnLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight, width: view.frame.size.width, height: priceLabelHeight)
            youOwnLabel.textAlignment = .center
            youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(youOwnLabel)
            
            worthLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight * 2, width: view.frame.size.width, height: priceLabelHeight)
            worthLabel.textAlignment = .center
            worthLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(worthLabel)

            
            coin.getHistoricalData()   //calls func gethistoricaldata which appends api historical data to an array historicaldata
            newPrices()
        }
    }
    @objc func editTapped() {
        if let coin = coin {
            let alert = UIAlertController(title: "How much \(coin.symbol)", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField)
                in
                textField.placeholder = "\(self.coin!.amount)"
                textField.keyboardType = .decimalPad
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {( action) in
                if let text = alert.textFields?[0].text {
                    if let amount = Double(text) {
                        self.coin?.amount = amount
                        self.newPrices()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)   //let chart = array historical data
            series.area = true  //shading area under the chart
            chart.add(series)   //add series to chart
        }
    }
    
    func newPrices() {
        if let coin = coin {
            priceLabel.text = coin.priceAsString()
            youOwnLabel.text = "You own \(coin.amount) \(coin.symbol)"
            worthLabel.text = coin.amountAsString()
        }
    }

}
