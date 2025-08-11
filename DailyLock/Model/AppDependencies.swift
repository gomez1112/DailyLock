@Observable
final class AppDependencies {
    let dataService: DataService
    let store: Store
    let haptics: HapticEngine
    let navigation: NavigationContext
    let errorState: ErrorState
    
    init() {
        let container = ModelContainerFactory.createSharedContainer
        self.dataService = DataService(container: container)
        self.navigation = NavigationContext()
        self.haptics = HapticEngine()
        self.errorState = ErrorState()
        let tipLedger = TipLedger(modelContainer: container)
        self.store = Store(tipLedger: tipLedger, errorState: errorState)
    }
}