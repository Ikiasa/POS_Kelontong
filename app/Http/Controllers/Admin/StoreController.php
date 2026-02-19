<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Store;
use App\Services\OfflineValidationService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class StoreController extends Controller
{
    public function __construct(
        protected OfflineValidationService $validationService
    ) {}

    public function index()
    {
        return Inertia::render('Admin/Stores/Index', [
            'stores' => Store::all()->map(function($store) {
                return [
                    'id' => $store->id,
                    'name' => $store->name,
                    'address' => $store->address,
                    'offline_code' => $this->validationService->generateCode($store->id)
                ];
            })
        ]);
    }

    public function generateCode(Request $request, $id)
    {
        $code = $this->validationService->generateCode($id);
        return response()->json(['code' => $code]);
    }
}
