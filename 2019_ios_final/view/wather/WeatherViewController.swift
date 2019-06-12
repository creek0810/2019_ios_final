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
            print(weather)
            if let felt_air_temp = weather.felt_air_temp {
                DispatchQueue.main.async {
                    cell.realTempLabel.text = felt_air_temp.description
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
