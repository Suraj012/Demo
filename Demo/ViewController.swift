//
//  ViewController.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//
import UIKit
import SnapKit

open class ViewController: UIViewController {
    
    public var automaticallyAdjustsLeftBarButtonItem = true
    
    public var navigationTitle = "" {
        didSet {
            navigationItem.title = navigationTitle
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
        view.snp.makeConstraints { [unowned self] (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                // Fallback on earlier versions
                make.edges.equalTo(self.view)
            }
        }
        return view
    }()
    
    lazy var disableView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    public var closeBarButtonIcon: UIImage? = UIImage(named: "icn_back", in: Bundle(for: ViewController.self), compatibleWith: nil) {
        didSet {
            closeBarButton.image = closeBarButtonIcon?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    public var closeBarAction: (() -> ())?
    
    private lazy var closeBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "icn_back", in: Bundle(for: ViewController.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate),
                                 style: .plain,
                                 target: self,
                                 action: #selector(closeAction))
        return view
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        // Do any additional setup after loading the view.
        makeUI()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if automaticallyAdjustsLeftBarButtonItem {
            adjustLeftBarButtonItem()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.view.endEditing(true)
    }
    
    deinit {
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    open func makeUI() {
        setUpNavigation()
    }
    
    open func disableView(_ bool: Bool) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        if bool {
            keyWindow?.addSubview(disableView)
            disableView.snp.makeConstraints({ (make) in
                make.edges.equalTo(keyWindow!)
            })
        } else {
            disableView.removeFromSuperview()
        }
    }
    
    // MARK: Adjusting Navigation Item
    func adjustLeftBarButtonItem() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 { // Pushed
            closeBarButtonIcon = UIImage(named: "icn_back", in: Bundle(for: ViewController.self), compatibleWith: nil)
            if closeBarAction == nil {
                closeBarAction = { [weak self] () in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        } else  { // presented
            closeBarButtonIcon = UIImage(named: "icn_close", in: Bundle(for: ViewController.self), compatibleWith: nil)
            if closeBarAction == nil {
                closeBarAction = { [weak self] () in
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    @objc func closeAction() {
        closeBarAction?()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    func setUpNavigation() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBlue
            appearance.titleTextAttributes = [.font:
            UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]

            // Customizing our navigation bar
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
}


