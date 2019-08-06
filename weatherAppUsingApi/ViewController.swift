//
//  ViewController.swift
//  weatherAppUsingApi
//
//  Created by IMCS2 on 8/5/19.
//  Copyright © 2019 com.phani. All rights reserved.
//

import UIKit
import WebKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var cityTemperature: UITextField!
    @IBOutlet weak var weatherDetail: UITextView!
    @IBOutlet weak var label: UILabel!
    var text: String = " "
    
    @IBOutlet weak var GetWeather: UIButton!
    
    
    @IBAction func WeatherButton(_ sender: Any) {
        let newTemp = cityTemperature.text!
        if cityTemperature.text?.isEmpty ?? true{
            weatherDetail.text = "Please enter the city name"
        }else{
            let newCity = newTemp.replacingOccurrences(of: " ", with: "%20")
            
            if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + newCity + ",us&appid=fc8ad9c4ee937c37f6283902489ed2a4") {
                print(url)
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    if error == nil{
                        if let unWrappedData = data {
                            let dataString = String(data: unWrappedData, encoding: .utf8)
                            if dataString!.contains("city not found"){
                                DispatchQueue.main.async {
                                    self.weatherDetail.text = "Not found"
                                }
                            }else{
                                do{
                                    var jsonResult = try JSONSerialization.jsonObject(with: unWrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                    print(jsonResult!["base"] as? String)
                                    let weather = jsonResult?["weather"] as? NSArray
                                    
                                    let weatherItem = weather?[0] as? NSDictionary
                                    let description = weatherItem!["description"] as! String
                                    
                                    DispatchQueue.main.async{
                                        self.weatherDetail.text = description
                                    }
                                    
                                }catch{
                                    print("Error while fetching API")
                                }
                            }
                        }
                    }
                    
                }
                task.resume()
                
                
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "rain")!)
        print(text)
        
        
    }
    
    
}

