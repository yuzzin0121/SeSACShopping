//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit
import SnapKit

// 메인 화면
class MainViewController: UIViewController, ViewProtocol {
    let noSearchWordBackgroundView = UIView()
    let noSearchWordImageView = UIImageView()
    let noSearchWordLabel = UILabel()
    let searchKeywordTableView = UITableView(frame: .zero, style: .grouped)
    var recentSearchList: [String] = [] {
        didSet {
            isEmpty(recentSearchList.isEmpty)
            searchKeywordTableView.reloadData()
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
        
        configureNavigationItem()
        configureSearchBar()
        configureHierarchy()
        setupContstraints()
        configureView()
        configureTableView()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nickname = UserDefaultManager.shared.nickname
        recentSearchList = UserDefaultManager.shared.searchKeywords
        isEmpty(recentSearchList.isEmpty)
    }
    
    // 모두 지우기 버튼 클릭했을 때
    @objc func removeAllButtonClicked() {
        recentSearchList.removeAll()
        UserDefaultManager.shared.searchKeywords = recentSearchList
    }
    
    // 최근 검색어 존재 유무에 따라 UI 설정
    func isEmpty(_ isEmpty: Bool) {
        if isEmpty == true {
            noSearchWordBackgroundView.alpha = 1
            searchKeywordTableView.alpha = 0
        } else {
            noSearchWordBackgroundView.alpha = 0
            searchKeywordTableView.alpha = 1
        }
    }
    
    func configureTableView() {
        searchKeywordTableView.backgroundColor = ColorStyle.backgroundColor 
        searchKeywordTableView.delegate = self
        searchKeywordTableView.dataSource = self
        searchKeywordTableView.rowHeight = 52
        searchKeywordTableView.sectionHeaderTopPadding = 0
        searchKeywordTableView.register(RecentKeywordHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentKeywordHeaderView.identifier)
        searchKeywordTableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
    }
    
    
    // tabbar. navigationItem 설정
    func configureNavigationItem() {
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
    
    func configureHierarchy() {
        [noSearchWordBackgroundView, searchKeywordTableView].forEach {
            view.addSubview($0)
        }
        
        [noSearchWordImageView, noSearchWordLabel].forEach {
            noSearchWordBackgroundView.addSubview($0)
        }
    }
    
    func configureView() {
        navigationController?.setupBarAppearance()
        view.backgroundColor = ColorStyle.backgroundColor
        noSearchWordBackgroundView.backgroundColor = ColorStyle.backgroundColor
        noSearchWordImageView.design(image: ImageStyle.empty, contentMode: .scaleAspectFit)
        noSearchWordLabel.design(text: "최근 검색어가 없어요", font: .boldSystemFont(ofSize: 17), textAlignment: .center)
    }
    
    func setupContstraints() {
        noSearchWordBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noSearchWordImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(noSearchWordBackgroundView).inset(8)
            make.height.equalTo(268)
        }
        
        noSearchWordLabel.snp.makeConstraints { make in
            make.top.equalTo(noSearchWordImageView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(noSearchWordBackgroundView).inset(8)
        }
        
        searchKeywordTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

