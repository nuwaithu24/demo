//
//  ListViewController.swift
//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import PKHUD

class ListViewController: UIViewController {

    @IBOutlet weak var mainTB: UITableView!
    
  let viewModel: WonderTableViewViewModel = WonderTableViewViewModel()

        private let disposeBag = DisposeBag()

        private var selectdataload = ReadOnce<WonderCellViewModel>(nil)

        public override func viewDidLoad() {
            super.viewDidLoad()

            bindViewModel()
            
            setupCellTapHandling()

            viewModel.getWonders()
        }

        func bindViewModel() {
            viewModel.wonderCells.bind(to: self.mainTB.rx.items) { tableView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                switch element {
                case .normal(let viewModel):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WonderTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.viewModel = viewModel
                    return cell
                case .error(let message):
                    let cell = UITableViewCell()
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.text = message
                    return cell
                case .empty:
                    let cell = UITableViewCell()
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.text = "No data available"
                    return cell
                }
            }.disposed(by: disposeBag)

            viewModel
                .onShowError
                .map { [weak self] in self?.presentSingleButtonDialog(alert: $0)}
                .subscribe()
                .disposed(by: disposeBag)

            viewModel
                .onShowLoadingHud
                .map { [weak self] in self?.setLoadingHud(visible: $0) }
                .subscribe()
                .disposed(by: disposeBag)
        }

        private func setLoadingHud(visible: Bool) {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
        }

        private func setupCellTapHandling() {
            mainTB
                .rx
                .modelSelected(WonderTableViewCellType.self)
                .subscribe(
                    onNext: { [weak self] wonderCellType in
                        if case let .normal(viewModel) = wonderCellType {
                            self?.selectdataload = ReadOnce(viewModel)
                            self?.performSegue(withIdentifier: "goDetail", sender: self)
                        }
                        if let selectedRowIndexPath = self?.mainTB.indexPathForSelectedRow {
                            self?.mainTB?.deselectRow(at: selectedRowIndexPath, animated: true)
                        }
                    }
                )
                .disposed(by: disposeBag)
        }

      

        public override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            if identifier == "goDetail" {
                return !selectdataload.isRead
            }

            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }

        public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goDetail",
               let destinationViewController = segue.destination as? DetailViewController,
                let viewModel = selectdataload.read()
            {
              destinationViewController.viewModel = UpdateWonderViewModel(wonderCellViewModel: viewModel)
               destinationViewController.updateWonders.asObserver().subscribe(onNext: { [weak self] () in
                   self?.viewModel.getWonders()
                }, onCompleted: {
                    print("ONCOMPLETED")
                }).disposed(by: destinationViewController.disposeBag)
            }

            
        }
    }

    // MARK: - SingleButtonDialogPresenter
    extension ListViewController: SingleButtonDialogPresenter { }
