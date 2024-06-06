
import Foundation
import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func useSelectedFilter(selectedFilter: Filters)
}

final class FiltersViewController: UIViewController {
    //MARK: - Properties
    private lazy var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var filtersArray: [Filters] = Filters.allCases
    var selectedFilter: Filters?
    var selectedIndexPath: IndexPath?
    weak var delegate: FiltersViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        addElements()
        createNavigationBar()
        setupConstraints()
    }
    
    //MARK: - Private Function
    private func addElements(){
        view.addSubview(filtersTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            filtersTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func createNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "buttonFilters.title".localized
    }
    
    private func createSeparatorImageView(cell: UITableViewCell) {
        let separatorImageView = UIImageView()
        separatorImageView.image = UIImage(named: "custom_separator")
        separatorImageView.tag = 100
        separatorImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(separatorImageView)
        
        NSLayoutConstraint.activate([
            separatorImageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
            separatorImageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16),
            separatorImageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            separatorImageView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
    
// MARK: - Extension UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        cell.textLabel?.text = filtersArray[indexPath.row].rawValue.localized
        cell.accessoryView = nil
        if filtersArray[indexPath.row] == selectedFilter {
            selectedIndexPath = indexPath
            let checkmarkImageView = UIImageView(image: UIImage(named: "checkmark"))
            cell.accessoryView = checkmarkImageView
        }
        cell.viewWithTag(100)?.removeFromSuperview()
        if indexPath.row != filtersArray.count - 1 {
            createSeparatorImageView(cell: cell)
        }
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedFilter = selectedFilter, selectedFilter != filtersArray[indexPath.row] {
            let lastIndexPath = filtersArray.firstIndex(of: selectedFilter)
            tableView.cellForRow(at: IndexPath(row: lastIndexPath ?? 0, section: 0))?.accessoryView = nil
            self.selectedFilter = filtersArray[indexPath.row]
            let checkmarkImageView = UIImageView(image: UIImage(named: "checkmark"))
            tableView.cellForRow(at: indexPath)?.accessoryView = checkmarkImageView
            UserDefaults.standard.set(self.selectedFilter?.rawValue, forKey: "selectedFilter")
        }
        delegate?.useSelectedFilter(selectedFilter: self.selectedFilter ?? Filters.allTrackers)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
}
