//
//  ChartContainer.swift
//  StepTracker
//
//  Created by Chon Torres on 7/4/24.
//

struct ChartContainerConfiguration {
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealthMetricContext
    let isNav: Bool
}

import SwiftUI

struct ChartContainer<Content: View>: View {
    let config: ChartContainerConfiguration
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            if config.isNav {
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            content()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        }
    }

    var navigationLinkView: some View {
        NavigationLink(value: config.context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }

    var titleView: some View {
        VStack(alignment: .leading) {
            Label(config.title, systemImage: config.symbol)
                .font(.title3.bold())
                .foregroundStyle(config.context == .steps ? .pink : .indigo)

            Text(config.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ChartContainer(config: .init(title: "Text Title",
                                 symbol: "figure.walk",
                                 subtitle: "Text Subtitle",
                                 context: .steps,
                                 isNav: true)) {
        Text("Chart Goes Here")
            .frame(minHeight: 150)
    }
}
