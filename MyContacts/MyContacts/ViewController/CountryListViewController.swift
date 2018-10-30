//
//  CountryListViewController.swift
//  MyContacts
//
//  Created by Sujananth on 10/29/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit


protocol CountryListDelegate: class {
    func didSelect(_ country: Country)
}

class CountryListViewController: UIViewController {

    let downloadURLString = "https://restcountries.eu/rest/v1/all"
    var downloadedCountryList: [Country?] = []
    
    @IBOutlet weak var countryListTableview: UITableView!
    weak var delegate: CountryListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countryListTableview.dataSource = self
        self.countryListTableview.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let downloadURL = URL(string: self.downloadURLString) else {
            return
        }
        self.downloadJsonFrom(downloadURL)
    }
    
    func downloadJsonFrom(_ downloadURL: URL) {
        
        let jsonDownloadTask = URLSession.shared.dataTask(with: downloadURL) { (downloadedData, response, error) in
            
            guard let dataResponse = downloadedData, error == nil else {
                print(error?.localizedDescription ?? "Response error")
                return
            }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                self.downcastJsonToRequiredType(jsonResponse)
            } catch {
                print(error.localizedDescription)
            }
        }
        jsonDownloadTask.resume()
    }
    
    //Following function is to downcast type of Any to [Any]
    func downcastJsonToRequiredType(_ json: Any) {
        
        //Folowing json cotains array of value hence downcating to array
        guard let countryList = json as? [Any] else {
            return
        }
        //If Json starts with dictionary [key, value] then, json  as? [String: Any]
        self.createObjectsFrom(countryList)
    }
    
    func createObjectsFrom(_ countryList: [Any]) {
        
        for countries in countryList {
            
            guard let country = countries as? Dictionary<String,Any> else  {
                return
            }
            
            let countryName: String  = country["name"] as! String
            let countryCode: String = country["alpha2Code"] as! String
            
            let countryInfo = Country(countryName: countryName, countryCode: countryCode)
            self.downloadedCountryList.append(countryInfo)
        }
        DispatchQueue.main.async {
            self.countryListTableview.reloadData()
        }
    }
}

extension CountryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.downloadedCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCountryListTableViewCell", for: indexPath)
        let countryInfo: Country? = downloadedCountryList[indexPath.row]
        cell.textLabel?.text = countryInfo?.name
        return cell
    }
}

extension CountryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let selectedCountry = downloadedCountryList[indexPath.row] {
            
            self.delegate?.didSelect(selectedCountry)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
