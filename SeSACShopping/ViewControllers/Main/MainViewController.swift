//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

// 메인 화면
class MainViewController: UIViewController, ViewProtocol {
    let searchController = UISearchController(searchResultsController: nil)
    
    var nickname: String? {
        didSet {
            navigationItem.title = "떠나고싶은 \(nickname!)님의 새싹쇼핑"
        }
    }
    
    @IBOutlet weak var noSearchWordBackgroundView: UIView!
    @IBOutlet weak var noSearchWordImageView: UIImageView!
    @IBOutlet weak var noSearchWordLabel: UILabel!
    @IBOutlet weak var recentSearchLabel: UILabel!
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var tableTopView: UIView!
    @IBOutlet weak var searchKeywordTableView: UITableView!
    var recentSearchList: [String] = [] {
        didSet {
            if recentSearchList.isEmpty {
                noSearchWordBackgroundView.alpha = 1
                searchKeywordTableView.alpha = 0
                tableTopView.alpha = 0
            }
            searchKeywordTableView.reloadData()
        }
    }

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSearchBar()
        designViews()
        configureTableView()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nickname = UserDefaultManager.shared.nickname
        recentSearchList = UserDefaultManager.shared.searchKeywords
        if recentSearchList.isEmpty {   // 최근 검색어가 없을 경우
            noSearchWordBackgroundView.alpha = 1
            searchKeywordTableView.alpha = 0
            
        } else {
            noSearchWordBackgroundView.alpha = 0
            searchKeywordTableView.alpha = 1
            tableTopView.alpha = 1
        }
    }
    
    @IBAction func removeAllButtonClicked(_ sender: UIButton) {
        recentSearchList.removeAll()
        UserDefaultManager.shared.searchKeywords = recentSearchList
    }
    
    func configureTableView() {
        searchKeywordTableView.backgroundColor = ColorStyle.backgroundColor 
        searchKeywordTableView.delegate = self
        searchKeywordTableView.dataSource = self
        searchKeywordTableView.rowHeight = 52
        
        let searchKeywordNib = UINib(nibName: RecentSearchTableViewCell.identifier, bundle: nil)
        searchKeywordTableView.register(searchKeywordNib, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
    }
    
    // tabbar. navigationItem 설정
    func configureView() {
        navigationController?.setupBarAppearance()
        let nickname = UserDefaultManager.shared.nickname
        self.navigationItem.title = "떠나고싶은 \(nickname)님의 새싹쇼핑"
        
        self.tabBarController?.tabBar.unselectedItemTintColor = .gray
        self.tabBarController?.tabBar.tintColor = ColorStyle.pointColor
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // searchbar 설정
    func configureSearchBar() {
        searchController.searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = .lightGray
        searchController.searchBar.searchTextField.backgroundColor = ColorStyle.deepDarkGray
    }
    
    // 뷰 디자인
    func designViews() {
        navigationController?.setupBarAppearance()
        view.backgroundColor = ColorStyle.backgroundColor
        noSearchWordBackgroundView.backgroundColor = ColorStyle.backgroundColor
        noSearchWordImageView.design(image: ImageStyle.empty, contentMode: .scaleAspectFit)
        noSearchWordLabel.design(text: "최근 검색어가 없어요", font: .boldSystemFont(ofSize: 17), textAlignment: .center)
        tableTopView.backgroundColor = ColorStyle.backgroundColor
        recentSearchLabel.design(text: "최근 검색", font: .boldSystemFont(ofSize: 14))
        removeAllButton.design(title: "모두 지우기", font: .boldSystemFont(ofSize: 14), titleColor: ColorStyle.pointColor, backgroundColor: .clear)
    }
    
    @objc func removeKeyword(sender: UIButton) {
        recentSearchList.remove(at: sender.tag)
        UserDefaultManager.shared.searchKeywords = recentSearchList
    }
    
    func showDetailVC(keyword: String) {
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let SearchResultVC = MainSB.instantiateViewController(identifier: SearchResultViewController.identifier) as! SearchResultViewController
        SearchResultVC.searchKeyword = keyword
        navigationController?.pushViewController(SearchResultVC, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as! RecentSearchTableViewCell
        
        cell.removeButton.tag = indexPath.row
        cell.configureCell(item: recentSearchList[indexPath.row])
        cell.removeButton.addTarget(self, action: #selector(removeKeyword), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = recentSearchList[indexPath.row]
        if keyword == "" { return }
        showDetailVC(keyword: keyword)
    }
}

extension MainViewController: UISearchBarDelegate {
    // 검색 버튼 클릭했을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        if text == "" { return }
        searchBar.text = ""
        var keywordArray = UserDefaultManager.shared.searchKeywords
        keywordArray.insert(text!, at: 0)
        UserDefaultManager.shared.searchKeywords = keywordArray
        
        showDetailVC(keyword: text!)
    }
}

