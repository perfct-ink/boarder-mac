import SwiftUI
import AppKit

struct HistoryListView: View {
    @ObservedObject var store: ClipboardHistoryStore
    let onSelect: () -> Void
    @State private var launchAtLogin = LaunchAtLogin.isEnabled

    var body: some View {
        VStack(spacing: 0) {
            Text("Boarder")
                .font(.headline)
                .padding(.top, 10)
                .padding(.bottom, 6)

            if store.items.isEmpty {
                Spacer()
                Text("Copy something to get started")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(store.items) { item in
                            HistoryRowView(
                                item: item,
                                isSelected: item.id == store.selectedItemID,
                                onCopyPlainText: plainTextCopyAction(for: item),
                                onDelete: { store.delete(item.id) }
                            )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.selectAndCopyToClipboard(item.id)
                                    onSelect()
                                }
                                .contextMenu {
                                    if let copyPlainText = plainTextCopyAction(for: item) {
                                        Button("Copy as Plain Text", action: copyPlainText)
                                    }
                                    Button("Delete", role: .destructive) {
                                        store.delete(item.id)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }

            Divider()

            VStack(spacing: 6) {
                HStack {
                    Toggle("Launch at Login", isOn: launchAtLoginBinding)
                        .toggleStyle(.checkbox)
                        .font(.caption)
                    Spacer()
                }
                HStack {
                    Text("Click an item to copy it")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button("Clear") { store.clearAll() }
                        .disabled(store.items.isEmpty)
                    Button("Quit") { NSApp.terminate(nil) }
                }
            }
            .padding(10)
        }
        .frame(width: 380, height: 420)
        .onAppear { launchAtLogin = LaunchAtLogin.isEnabled }
    }

    private var launchAtLoginBinding: Binding<Bool> {
        Binding(
            get: { launchAtLogin },
            set: { newValue in
                try? LaunchAtLogin.setEnabled(newValue)
                launchAtLogin = LaunchAtLogin.isEnabled // reflect the real state if registration failed
            }
        )
    }

    /// A closure that copies `item` to the clipboard as plain text, or `nil` when the item has no
    /// plain-text form (an image). The row shows a trailing button and a context-menu entry when
    /// this is non-nil.
    private func plainTextCopyAction(for item: ClipboardItem) -> (() -> Void)? {
        guard case .text = item.content else { return nil }
        return { store.selectAndCopyToClipboard(item.id) }
    }
}
