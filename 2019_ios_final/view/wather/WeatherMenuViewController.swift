//
//  WeatherMenuViewController.swift
//  2019_ios_final
//
//  Created by User15 on 2019/6/12.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class WeatherMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var city: [City] = [City]()

    @IBOutlet weak var cityTable: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherMenuCell", for: indexPath) as! WeatherMenuTableViewCell
        cell.nameLabel.text = city[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showWeather", sender: city[indexPath.row].towns)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTable.delegate = self
        cityTable.dataSource = self
        NetworkController.shared.getCity { (city) in
            self.city = city
            DispatchQueue.main.async {
                self.cityTable.reloadData()
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeather" {
            let controller = segue.destination as! WeatherViewController
            controller.town = sender as! [Town]
        }
    }
    

}
