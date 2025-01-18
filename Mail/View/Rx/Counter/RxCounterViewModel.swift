import RxSwift
import RxCocoa
import UIKit

struct CounterViewModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
}

protocol CounterViewModelOutput {
    var counterText: Driver<String?> { get }
}

protocol CounterViewModelType {
    var output: CounterViewModelOutput? { get }
    func setup(input: CounterViewModelInput)
}

final class RxCounterViewModel: CounterViewModelType {
    var output: CounterViewModelOutput?
    
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        self.output = self
        resetCount()
    }
    
    func setup(input: CounterViewModelInput) {
        input.countUpButton
            .subscribe (onNext: { [weak self] in
                self?.incrementCount()
            })
            .disposed(by: disposeBag)
        input.countDownButton
            .subscribe (onNext: { [weak self] in
                self?.decrementCount()
            })
            .disposed(by: disposeBag)
        input.countResetButton
            .subscribe (onNext: { [weak self] in
                self?.resetCount()
            })
            .disposed(by: disposeBag)
    }
    
    private func incrementCount() {
        let count = countRelay.value + 1
        countRelay.accept(count)
    }
    
    private func decrementCount() {
        let count = countRelay.value - 1
        countRelay.accept(count)
    }
    
    private func resetCount() {
        countRelay.accept(initialCount)
    }
}

extension RxCounterViewModel: CounterViewModelOutput {
    var counterText: RxCocoa.Driver<String?> {
        return countRelay
            .map { "Rx パターン:\($0)"}
            .asDriver(onErrorJustReturn: nil)
    }
}
