//
//  WeatherViewController.swift
//  2019_ios_final
//
//  Created by User15 on 2019/6/12.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var town: [Town] = [Town]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return town.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        cell.townLabel.text = town[indexPath.row].name
        NetworkController.shared.getWeather(townID: town[indexPath.row].id) { (weather) in
            if let feltTemp = weather.felt_air_temp, let realTemp = weather.temperature, let humidity = weather.humidity  {
                DispatchQueue.main.async {
                    cell.feltTempLabel.text = feltTemp.description
                    cell.realTempLabel.text = realTemp.description
                    cell.humidityLabel.text = humidity.description
                }
            }
        }
        return cell
    }
    
    
    
    @IBOutlet weak var weatherTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTable.delegate = self
        weatherTable.dataSource = self
        
    }
}
