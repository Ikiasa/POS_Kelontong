<?php

namespace App\Http\Controllers;

use App\Services\BackupService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class BackupController extends Controller
{
    public function __construct(protected BackupService $backupService) {}

    public function index()
    {
        $backups = $this->backupService->getBackups();
        return \Inertia\Inertia::render('Admin/Backups/Index', [
            'backups' => $backups
        ]);
    }

    public function store()
    {
        $result = $this->backupService->runBackup();

        if ($result['success']) {
            return back()->with('success', $result['message']);
        }

        return back()->with('error', $result['message']);
    }

    public function download($filename)
    {
        if (Storage::exists("backups/$filename")) {
            return Storage::download("backups/$filename");
        }
        return back()->with('error', 'File not found.');
    }
    
    public function restore($filename)
    {
        // SIMULATION: In reality, run pg_restore
        return back()->with('success', "Database system restored from $filename (Simulated).");
    }

    public function destroy($filename)
    {
         if (Storage::exists("backups/$filename")) {
            Storage::delete("backups/$filename");
            return back()->with('success', 'Backup deleted.');
        }
        return back()->with('error', 'File not found.');
    }
}
