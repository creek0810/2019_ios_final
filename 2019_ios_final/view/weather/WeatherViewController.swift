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
    var townWeather: [Weather] = [Weather]()
    var weaterPic: [UIImage] = [UIImage]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return town.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        cell.townLabel.text = town[indexPath.row].name
        NetworkController.shared.getWeather(townID: town[indexPath.row].id) { (weather, image) in
            DispatchQueue.main.async {
                cell.weatherImage.image = image
                if let humidity = weather.humidity, let feltTemp = weather.felt_air_temp, let realTemp = weather.temperature {
                    cell.humidityLabel.text = humidity.description
                    cell.feltTempLabel.text = feltTemp.description
                    cell.realTempLabel.text = realTemp.description
                }
            }
            
        }
        return cell
    }

    @IBOutlet weak var weatherTable: UITableView!
    
    override func viewDidLoad() {
        
        weatherTable.delegate = self
        weatherTable.dataSource = self
        super.viewDidLoad()
    }
}
