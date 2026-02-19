<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Account;

class ChartOfAccountsSeeder extends Seeder
{
    public function run(): void
    {
        $accounts = [
            // Assets (1-xxxx)
            ['code' => '1-1001', 'name' => 'Kas Tunai', 'type' => 'asset', 'description' => 'Uang tunai di tangan'],
            ['code' => '1-1002', 'name' => 'Bank BCA', 'type' => 'asset', 'description' => 'Rekening Bank operasional'],
            ['code' => '1-1003', 'name' => 'Piutang Usaha', 'type' => 'asset', 'description' => 'Tagihan ke pelanggan'],
            ['code' => '1-1004', 'name' => 'Persediaan Barang', 'type' => 'asset', 'description' => 'Nilai stok barang dagang'],
            ['code' => '1-1005', 'name' => 'Perlengkapan Toko', 'type' => 'asset', 'description' => 'Barang habis pakai toko'],

            // Liabilities (2-xxxx)
            ['code' => '2-2001', 'name' => 'Hutang Usaha', 'type' => 'liability', 'description' => 'Tagihan dari supplier'],
            ['code' => '2-2002', 'name' => 'Hutang Pajak', 'type' => 'liability', 'description' => 'Pajak yang belum disetor'],

            // Equity (3-xxxx)
            ['code' => '3-3001', 'name' => 'Modal Pemilik', 'type' => 'equity', 'description' => 'Investasi awal pemilik'],
            ['code' => '3-3002', 'name' => 'Laba Ditahan', 'type' => 'equity', 'description' => 'Akumulasi laba rugi tahun lalu'],

            // Revenue (4-xxxx)
            ['code' => '4-4001', 'name' => 'Penjualan Barang', 'type' => 'revenue', 'description' => 'Pendapatan dari penjualan produk'],
            ['code' => '4-4002', 'name' => 'Pendapatan Jasa', 'type' => 'revenue', 'description' => 'Pendapatan dari layanan/service'],
            ['code' => '4-4003', 'name' => 'Pendapatan Lain-lain', 'type' => 'revenue', 'description' => 'Pendapatan non-operasional'],

            // Expenses (5-xxxx)
            ['code' => '5-5001', 'name' => 'Harga Pokok Penjualan', 'type' => 'expense', 'description' => 'Biaya modal barang yang terjual'],
            ['code' => '5-5002', 'name' => 'Beban Gaji', 'type' => 'expense', 'description' => 'Gaji karyawan'],
            ['code' => '5-5003', 'name' => 'Beban Sewa', 'type' => 'expense', 'description' => 'Sewa tempat usaha'],
            ['code' => '5-5004', 'name' => 'Beban Listrik & Air', 'type' => 'expense', 'description' => 'Tagihan utilitas bulanan'],
            ['code' => '5-5005', 'name' => 'Beban Operasional Lain', 'type' => 'expense', 'description' => 'Pengeluaran kecil harian'],
        ];

        foreach ($accounts as $acc) {
            Account::updateOrCreate(['code' => $acc['code']], $acc);
        }
    }
}
