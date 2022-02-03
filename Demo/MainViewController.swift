//
//  MainViewController.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation
import UIKit


final class MainViewController: ViewController {
    
    // MARK: Outlets
    
    private lazy var cityHeader: UILabel = {
        let view = UILabel()
        view.text = "Main Cities in Japan"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    private lazy var cityHeaderView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 1, y: 50, width: 276, height: 40))
        view.backgroundColor = UIColor.white
        view.addSubview(cityHeader)
        cityHeader.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(16)
        })
        return view
    }()
    
    
    private lazy var foodHeaderLabel: UILabel = {
        let view = UILabel()
        view.text = "Most Popular Japanese Food"
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    private lazy var foodHeaderView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 1, y: 50, width: 276, height: 40))
        view.backgroundColor = UIColor.white
        view.addSubview(foodHeaderLabel)
        foodHeaderLabel.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(16)
        })
        return view
    }()
    
    let refreshControl = UIRefreshControl()
        
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(CityTableCell.self, forCellReuseIdentifier: "\(CityTableCell.self)")
        view.register(FoodTableCell.self, forCellReuseIdentifier: "\(FoodTableCell.self)")
        view.register(ErrorTableViewCell.self, forCellReuseIdentifier: "\(ErrorTableViewCell.self)")
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.allowsSelection = true
        return view
    }()
    
    var cityViewModel: [CityCellViewModel] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    var foodViewModel: [FoodCellViewModel] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    
    // MARK: ViewController Lifecycles
    override func viewDidLoad() {
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        super.viewDidLoad()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getCityList(){
            self.getFoodList()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func makeUI() {
        super.makeUI()
        self.navigationController?.navigationBar.isHidden = false
        self.automaticallyAdjustsLeftBarButtonItem = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Demo"
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(0.0)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
        getLocalCityList()
        getLocalFoodList()
    }
    // MARK: Actions
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cityViewModel.isEmpty ? 1 : cityViewModel.count
        case 1:
            return foodViewModel.isEmpty ? 1 : foodViewModel.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if cityViewModel.isEmpty == true {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ErrorTableViewCell.self)", for: indexPath) as? ErrorTableViewCell else {
                    return UITableViewCell()
                }
                cell.bind(title: "Error", description: "No City Found, Please try again later")
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CityTableCell.self)", for: indexPath) as? CityTableCell else {
                    return UITableViewCell()
                }
                cell.bind(viewModel: cityViewModel[indexPath.row])
                return cell
            }
        case 1:
            if foodViewModel.isEmpty == true {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ErrorTableViewCell.self)", for: indexPath) as? ErrorTableViewCell else {
                    return UITableViewCell()
                }
                cell.bind(title: "Error", description: "No Food Found, Please try again later")
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FoodTableCell.self)", for: indexPath) as? FoodTableCell else {
                    return UITableViewCell()
                }
                cell.bind(viewModel: foodViewModel[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return cityHeaderView
        case 1:
            return foodHeaderView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if(indexPath.section == 0){
            mainView.isCity = true
            mainView.cityData = self.cityViewModel[indexPath.row]
        }else {
            mainView.isCity = false
            mainView.foodData = self.foodViewModel[indexPath.row]
        }
        self.navigationController?.pushViewController(mainView, animated: true)
    }
}

extension MainViewController {
    func getLocalCityList() {
        LocalDataStorageClass().fetchCityData(completion: { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.cityViewModel = response.map({ CityCellViewModel(data: $0) })
                }
                break
            case .failure(_):
                self.getCityList(){}
        }
        })
    }
    
    func getLocalFoodList() {
        LocalDataStorageClass().fetchFoodData(completion: { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.foodViewModel = response.map({ FoodCellViewModel(data: $0) })
                }
                break
            case .failure(_):
                self.getFoodList()
            }
        })
    }
    
    func getCityList(completion: @escaping () -> ()) {
       NetworkController().getCityList(){ (result) in
           switch result {
           case .success(let response):
               DispatchQueue.main.async {
                   self.cityViewModel = response.map({ CityCellViewModel(data: $0) })
               }
               completion()
               break
           case .failure(let aError):
               DispatchQueue.main.async {
                   self.refreshControl.endRefreshing()
                   let alert = UIAlertController(title: "", message: aError.description, preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
               break
           }
       }
    }
    
    func getFoodList() {
        NetworkController().getFoodList(){ (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.foodViewModel = response.map({ FoodCellViewModel(data: $0) })
                }
                break
            case .failure(let aError):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    let alert = UIAlertController(title: "", message: aError.description, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                break
            }
        }
    }
}
