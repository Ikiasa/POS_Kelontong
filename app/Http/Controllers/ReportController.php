<?php

namespace App\Http\Controllers;

use App\Models\JournalEntry;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ReportController extends Controller
{
    /**
     * Export Accounting Journal to CSV.
     */
    public function exportJournal()
    {
        $entries = JournalEntry::with('items')->latest()->get();
        
        $response = new StreamedResponse(function () use ($entries) {
            $handle = fopen('php://output', 'w');
            
            // Header
            fputcsv($handle, ['Date', 'Reference', 'Description', 'Account Code', 'Account Name', 'Debit', 'Credit']);
            
            foreach ($entries as $entry) {
                foreach ($entry->items as $item) {
                    fputcsv($handle, [
                        $entry->transaction_date,
                        $entry->reference_number,
                        $entry->description,
                        $item->account_code,
                        $item->account_name,
                        $item->debit,
                        $item->credit
                    ]);
                }
            }
            
            fclose($handle);
        });
        
        $response->headers->set('Content-Type', 'text/csv');
        $response->headers->set('Content-Disposition', 'attachment; filename="accounting_journal_' . date('Y-m-d') . '.csv"');
        
        return $response;
    }

    /**
     * Display Tax Summary Report.
     */
    public function taxSummary()
    {
        $storeId = auth()->user()->store_id ?? 1;
        
        $taxData = Transaction::where('store_id', $storeId)
            ->where('status', 'completed')
            ->selectRaw('SUM(tax) as total_ppn, SUM(service_charge) as total_service, SUM(grand_total) as total_gross')
            ->first();

        return view('reports.tax-summary', compact('taxData'));
    }
}
