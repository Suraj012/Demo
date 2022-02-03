//
//  DetailViewController.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: ViewController {
    
    var cityData: CityCellViewModel?
    var foodData: FoodCellViewModel?
    var isCity: Bool = false
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        scrollView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        })
        return view
    }()
    
    private lazy var cityImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    private lazy var cityDescLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    // MARK: ViewController Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func makeUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.automaticallyAdjustsLeftBarButtonItem = true
        
        navigationItem.title = isCity ? cityData?.name : foodData?.name
        scrollContentView.addSubview(cityImageView)
        cityImageView.snp.makeConstraints({(make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        })
        scrollContentView.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints({(make) in
            make.top.equalTo(cityImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        })
        scrollContentView.addSubview(cityDescLabel)
        cityDescLabel.snp.makeConstraints({(make) in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.greaterThanOrEqualToSuperview().inset(24)
        })
    }
}

extension DetailViewController {
    func populateData() {
        cityNameLabel.text = isCity ? cityData?.name : foodData?.name
        cityDescLabel.text = isCity ? cityData?.description : ""
        guard let imageURL = URL(string: isCity ? cityData?.image ?? "" : foodData?.image ?? "") else { return }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.cityImageView.image = image
                }
            }
    }
}
