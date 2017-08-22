//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Jaydeep Patoliya on 12/08/17.
//

import UIKit

enum LeftMenu: Int {
    case home = 0
    case managePlace
    case setAlert
    case go
    case nonMenu
    case signOut
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol, GIDSignInUIDelegate, MyGoogleObjDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Manage Places", comment: "") ,NSLocalizedString("Set Alert", comment: ""),NSLocalizedString("GO", comment: ""), NSLocalizedString("NonMenu", comment: "")]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "SwiftViewController") as! SwiftViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let javaViewController = storyboard.instantiateViewController(withIdentifier: "JavaViewController") as! JavaViewController
        self.javaViewController = UINavigationController(rootViewController: javaViewController)
        
        let goViewController = storyboard.instantiateViewController(withIdentifier: "GoViewController") as! GoViewController
        self.goViewController = UINavigationController(rootViewController: goViewController)
        
        let nonMenuController = storyboard.instantiateViewController(withIdentifier: "NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
        
        //For Google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        self.imageHeaderView.signInButton.isHidden = false
    }
    
    func signInFinished(){
        
        self.imageHeaderView.signInButton.isHidden = true
        self.imageHeaderView.welcomeLable.isHidden = true
        self.imageHeaderView.profileImage.isHidden = false
        self.imageHeaderView.nameLable.isHidden = false
        self.imageHeaderView.emailLable.isHidden = false
        
        let user = GIDSignIn.sharedInstance().currentUser
        let url =  user?.profile.imageURL(withDimension: 80)
        let data = try? Data(contentsOf: url!)
        
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.imageHeaderView.profileImage.image = UIImage(data: data!)
        let firstName = user?.profile.givenName
        let lastName = user?.profile.familyName
        self.imageHeaderView.nameLable.text = firstName!+" "+lastName!
        self.imageHeaderView.emailLable.text = user?.profile.email
        menus.append(NSLocalizedString("Sign Out", comment: ""))
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .managePlace:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .setAlert:
            self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
        case .go:
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
        case .nonMenu:
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        case .signOut:
            handleSignOut()
            
        }
    }
    
    func handleSignOut(){
        GIDSignIn.sharedInstance().signOut()
        self.imageHeaderView.signInButton.isHidden = false
        self.imageHeaderView.welcomeLable.isHidden = false
        self.imageHeaderView.profileImage.isHidden = true
        self.imageHeaderView.nameLable.isHidden = true
        self.imageHeaderView.emailLable.isHidden = true
        menus.removeLast()
        self.tableView.reloadData()
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .home, .managePlace, .setAlert, .go, .nonMenu, .signOut:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .home, .managePlace, .setAlert, .go, .nonMenu, .signOut:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
