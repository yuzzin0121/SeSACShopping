//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit
import SnapKit

// 메인 화면
class MainViewController: BaseViewController {
    let mainView = MainView()
    var recentSearchList: [String] = [] {
        didSet {
            isEmpty(recentSearchList.isEmpty)
            mainView.searchKeywordTableView.reloadData()
        }
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    var nickname: String? {
        didSet {
            navigationItem.title = "떠나고싶은 \(nickname!)님의 새싹쇼핑"
        }
    }

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
        configureTableView()
//        hideKeyboardWhenTapArround()
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nickname = UserDefaultManager.shared.nickname
        recentSearchList = UserDefaultManager.shared.searchKeywords
        isEmpty(recentSearchList.isEmpty)
    }
    
    func hideKeyboardWhenTapArround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        searchController.searchBar.endEditing(true)
    }
    
    // 모두 지우기 버튼 클릭했을 때
    @objc func removeAllButtonClicked() {
        recentSearchList.removeAll()
        UserDefaultManager.shared.searchKeywords = recentSearchList
    }
    
    // 최근 검색어 존재 유무에 따라 UI 설정
    func isEmpty(_ isEmpty: Bool) {
        if isEmpty == true {
            mainView.noSearchWordBackgroundView.alpha = 1
            mainView.searchKeywordTableView.alpha = 0
        } else {
            mainView.noSearchWordBackgroundView.alpha = 0
            mainView.searchKeywordTableView.alpha = 1
        }
    }
    
    func configureTableView() {
        mainView.searchKeywordTableView.backgroundColor = ColorStyle.backgroundColor
        mainView.searchKeywordTableView.delegate = self
        mainView.searchKeywordTableView.dataSource = self
    }
    
    
    // tabbar. navigationItem 설정
    override func configureNavigationItem() {
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recentKeywordHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentKeywordHeaderView.identifier) as! RecentKeywordHeaderView
        
        recentKeywordHeaderView.removeAllButton.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
        
        return recentKeywordHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as! RecentSearchTableViewCell
        
        cell.removeButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.configureCell(item: recentSearchList[indexPath.row])
        cell.removeButton.addTarget(self, action: #selector(removeKeyword), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("dfsdfs")
        let keyword = recentSearchList[indexPath.row]
        if keyword == "" { return }
        saveSearchKeyword(keyword: keyword)
        showDetailVC(keyword: keyword)
    }
    
}

extension MainViewController: UISearchBarDelegate {
    // 검색 버튼 클릭했을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if text == "" { return }
        searchBar.text = ""
//        view.endEditing(true)
        searchBarCancelButtonClicked(searchBar)
        saveSearchKeyword(keyword: text)
        showDetailVC(keyword: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func saveSearchKeyword(keyword: String) {
        var keywordArray = UserDefaultManager.shared.searchKeywords
        
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            keywordArray.insert(keyword, at: 0)
        } else {
            keywordArray.insert(keyword, at: 0)
        }
        
        UserDefaultManager.shared.searchKeywords = keywordArray
    }
}

