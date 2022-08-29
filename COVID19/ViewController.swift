//
//  ViewController.swift
//  COVID19
//
//  Created by kup on 2022/08/29.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var peChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
                
            case let .failure(error):
                debugPrint("error \(error)")
            }
            
        })
        // Do any additional setup after loading the view.
    }
    
    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void){
            let url = "https://api.corona-19.kr/korea/country/new/"
            let param = [
                "serviceKey": "eYtzNq24Vg6BUHC8lXOLaR1vdZGiAJEbs"
            ]
            
            AF.request(url, method: .get, parameters: param)
                .responseData(completionHandler: {response in
                    switch response.result{
                    case let .success(data):
                        do{
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(CityCovidOverview.self, from: data)
                            completionHandler(.success(result))
                        }catch{
                            completionHandler(.failure(error))
                        }
                    case let .failure(error):
                        completionHandler(.failure(error))
                    }
                })
            
        }
}

