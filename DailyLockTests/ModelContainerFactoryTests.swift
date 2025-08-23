import Testing
import SwiftData
@testable import DailyLock

@MainActor
@Suite("ModelContainerFactory Tests")
struct ModelContainerFactoryTests {
    
    
    @Test("createSharedContainer creates a ModelContainer")
    func testCreateSharedContainer() {
        let container = ModelContainerFactory.createSharedContainer
        #expect(type(of: container) == ModelContainer.self)
    }

    @Test("createPreviewContainer creates container with sample data")
    func testCreatePreviewContainer() throws {
        let container = ModelContainerFactory.createPreviewContainer
        #expect(type(of: container) == ModelContainer.self)
        let context = container.mainContext
        // Check for sample data
        let fetchDescriptor = FetchDescriptor<MomentumEntry>()
        let entries = try context.fetch(fetchDescriptor)
        #expect(!entries.isEmpty, "Sample data should be present in preview container")
    }

    @Test("configuration returns correct memory storage")
    func testConfigurationInMemory() {
        let config = ModelContainerFactory.configuration(isStoredInMemoryOnly: true)
        #expect(config.isStoredInMemoryOnly)
    }
    
    @Test("configuration returns correct persistent storage")
    func testConfigurationPersistent() {
        let config = ModelContainerFactory.configuration(isStoredInMemoryOnly: false)
        #expect(!config.isStoredInMemoryOnly)
    }
}
