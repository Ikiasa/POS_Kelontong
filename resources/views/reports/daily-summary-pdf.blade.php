<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: sans-serif; }
        .header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 10px; }
        .metric { margin: 20px 0; }
        .alert { color: red; font-weight: bold; }
        .summary-table { width: 100%; border-collapse: collapse; }
        .summary-table td, .summary-table th { border: 1px solid #ddd; padding: 8px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Daily Business Summary</h1>
        <h2>{{ $summary['store_name'] }}</h2>
        <p>Date: {{ $summary['date'] }}</p>
    </div>

    <div class="metric">
        <h3>📊 Financial Performance</h3>
        <table class="summary-table">
            <tr><th>Total Sales</th><td>Rp {{ number_format($summary['total_sales'], 0, ',', '.') }}</td></tr>
            <tr><th>Gross Profit</th><td>Rp {{ number_format($summary['gross_profit'], 0, ',', '.') }}</td></tr>
            <tr><th>Net Profit (Est)</th><td>Rp {{ number_format($summary['net_profit'], 0, ',', '.') }}</td></tr>
        </table>
    </div>

    <div class="metric">
        <h3>📦 Product Insights</h3>
        <p><strong>Best Seller:</strong> {{ $summary['best_seller'] }}</p>
        <p><strong>Dead Stock Items:</strong> {{ $summary['dead_stock_warning'] }}</p>
    </div>

    @if($summary['critical_alerts'] > 0)
    <div class="metric">
        <h3>🚨 Security & Risk</h3>
        <p class="alert">Warning: {{ $summary['critical_alerts'] }} critical alerts were recorded today.</p>
    </div>
    @endif
</body>
</html>
