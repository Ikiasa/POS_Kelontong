<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { 
    CheckCircle, 
    ArrowRight, 
    PlayCircle, 
    LayoutGrid, 
    ShoppingCart, 
    Search, 
    User, 
    CreditCard, 
    Sparkles, 
    TrendingUp, 
    AlertTriangle,
    Zap,
    Box,
    Clock,
    BarChart3,
    Database,
    Users,
    RefreshCcw,
    ClipboardCheck,
    Truck,
    Calendar,
    PieChart,
    Globe,
    Bot,
    Wallet
} from 'lucide-vue-next';

defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
});

const demoProducts = [
    { name: 'Minyak Goreng Sania 2L', qty: 2, price: '38.500', total: '77.000' },
    { name: 'Beras Pandan Wangi 5kg', qty: 1, price: '68.000', total: '68.000' },
    { name: 'Telur Ayam Negeri', qty: '1.5 kg', price: '28.000', total: '42.000' },
    { name: 'Indomie Goreng Spesial', qty: 10, price: '3.100', total: '31.000' },
    { name: 'Aqua Galon Refill', qty: 3, price: '19.000', total: '57.000' },
    { name: 'Gula Pasir Gulaku 1kg', qty: 2, price: '16.500', total: '33.000' },
];
</script>

<template>
    <Head title="KelontongPOS - Software Kasir Warung Modern" />

    <div class="bg-gray-50 dark:bg-zinc-950 text-zinc-900 dark:text-white min-h-screen font-sans selection:bg-red-500 selection:text-white overflow-x-hidden">
        
        <!-- Navbar -->
        <nav class="container mx-auto px-6 py-4 flex items-center justify-between relative z-50 bg-white/80 dark:bg-zinc-950/80 backdrop-blur-md sticky top-0 border-b border-gray-100 dark:border-zinc-800">
            <div class="flex items-center gap-2">
                <div class="w-9 h-9 bg-gradient-to-br from-red-600 to-red-700 rounded-lg flex items-center justify-center text-white font-bold text-lg shadow-md shadow-red-600/20">
                    K
                </div>
                <span class="font-bold text-lg tracking-tight text-zinc-800 dark:text-gray-100">KelontongPOS</span>
            </div>
            
            <div class="hidden md:flex items-center gap-8 text-sm font-medium text-zinc-600 dark:text-zinc-400">
                <a href="#features" class="hover:text-red-600 transition-colors">Fitur</a>
                <a href="#pricing" class="hover:text-red-600 transition-colors">Harga</a>
                <a href="#testimoni" class="hover:text-red-600 transition-colors">Testimoni</a>
            </div>

            <div class="flex items-center gap-3">
                <Link :href="route('login')" class="text-sm font-semibold hover:text-red-600 transition-colors px-3 py-2">
                    Masuk
                </Link>
                <Link :href="route('register')" v-if="canRegister" class="hidden sm:inline-flex px-5 py-2 rounded-lg bg-red-600 text-white text-sm font-bold hover:bg-red-700 transition-colors shadow-lg shadow-red-600/20">
                    Daftar Toko
                </Link>
            </div>
        </nav>

        <!-- Hero Section -->
        <header class="relative pt-16 pb-24 lg:pt-24 lg:pb-32 overflow-hidden">
            <!-- Background Elements -->
             <div class="absolute inset-0 z-0">
                <!-- Abstract blurred shelves/store background -->
                <div class="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1578916171728-46686eac8d58?q=80&w=2000&auto=format&fit=crop')] bg-cover bg-center opacity-[0.03] dark:opacity-[0.05] grayscale mix-blend-multiply"></div>
                <div class="absolute inset-0 bg-gradient-to-b from-transparent via-gray-50/50 to-gray-50 dark:via-zinc-950/50 dark:to-zinc-950"></div>
            </div>

            <div class="container mx-auto px-6 grid lg:grid-cols-2 gap-12 lg:gap-16 items-center relative z-10">
                
                <!-- Left Content -->
                <div class="text-center lg:text-left space-y-6 lg:max-w-xl">
                    
                    <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-400 text-[11px] font-bold uppercase tracking-wider border border-red-100 dark:border-red-900/30">
                        <span class="w-1.5 h-1.5 rounded-full bg-red-600 animate-pulse"></span>
                        Trusted by 1,500+ UMKM
                    </div>

                    <h1 class="text-4xl lg:text-6xl font-extrabold tracking-tight text-zinc-900 dark:text-white leading-[1.15]">
                        Software POS <br/>
                        Minimarket yang <br/>
                        <span class="text-red-600 decoration-4 decoration-red-200 underline-offset-4">Siap Pakai</span>
                    </h1>
                    
                    <p class="text-lg text-zinc-600 dark:text-zinc-400 leading-relaxed font-medium">
                        Transaksi Cepat. Stok Otomatis. Laporan Real-Time. <br class="hidden lg:block"/>
                        Bukan sekadar kasir, tapi asisten pintar untuk minimarket Anda.
                    </p>
                    
                    <div class="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 pt-2">
                        <Link :href="route('register')" v-if="canRegister" class="w-full sm:w-auto px-8 py-3.5 rounded-xl bg-red-600 hover:bg-red-700 text-white font-bold text-base shadow-xl shadow-red-600/20 hover:shadow-red-600/30 hover:-translate-y-0.5 transition-all flex items-center justify-center gap-2">
                            Coba Gratis 14 Hari
                            <ArrowRight class="w-4 h-4" />
                        </Link>
                        <a href="#demo" class="w-full sm:w-auto px-8 py-3.5 rounded-xl border border-gray-300 dark:border-zinc-700 hover:border-red-600 dark:hover:border-red-500 hover:text-red-600 dark:hover:text-red-400 text-zinc-700 dark:text-zinc-300 font-bold text-base bg-white dark:bg-zinc-900 hover:bg-red-50 dark:hover:bg-red-900/10 transition-all flex items-center justify-center gap-2 group">
                            <PlayCircle class="w-4 h-4 group-hover:text-red-600 transition-colors" />
                            Lihat Demo POS
                        </a>
                    </div>

                    <div class="pt-8 flex flex-wrap justify-center lg:justify-start gap-x-6 gap-y-2 text-sm text-zinc-600 dark:text-zinc-500 font-medium opacity-90">
                        <div class="flex items-center gap-2">
                            <CheckCircle class="w-4 h-4 text-green-600" />
                            <span>Tanpa Hardware Khusus</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <CheckCircle class="w-4 h-4 text-green-600" />
                            <span>Support Printer Thermal</span>
                        </div>
                         <div class="flex items-center gap-2">
                            <CheckCircle class="w-4 h-4 text-green-600" />
                            <span>Scan via HP / Alat</span>
                        </div>
                    </div>
                </div>

                <!-- Right Visual Hero (Monitor Mockup) -->
                <div class="relative z-10 lg:perspective-[2000px] group select-none">
                    
                    <!-- Floating Cards Refined -->
                    <div class="absolute -right-8 top-16 w-72 p-4 bg-white dark:bg-zinc-800 rounded-xl shadow-2xl shadow-zinc-200/50 dark:shadow-zinc-900/50 border border-gray-100 dark:border-zinc-700 md:animate-float-slow z-30 hidden lg:block transform rotate-1">
                        <div class="flex items-start gap-3">
                            <div class="p-2 bg-orange-50 dark:bg-orange-900/30 rounded-lg text-orange-600 dark:text-orange-400 shrink-0">
                                <AlertTriangle :size="18" />
                            </div>
                            <div>
                                <h4 class="font-bold text-sm text-zinc-800 dark:text-white">Stok Menipis</h4>
                                <p class="text-xs text-zinc-500 mt-0.5 leading-snug">
                                    <span class="font-bold text-zinc-700 dark:text-zinc-300">Minyak Goreng 2L</span> tersisa <span class="text-red-600 font-bold">3 pcs</span>. Segera reorder!
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="absolute -left-10 bottom-24 w-64 p-4 bg-white dark:bg-zinc-800 rounded-xl shadow-2xl shadow-zinc-200/50 dark:shadow-zinc-900/50 border border-gray-100 dark:border-zinc-700 md:animate-float-delayed z-30 hidden lg:block transform -rotate-1">
                        <div class="flex items-start gap-3">
                            <div class="p-2 bg-red-50 dark:bg-red-900/30 rounded-lg text-red-600 dark:text-red-400 shrink-0">
                                <BarChart3 :size="18" />
                            </div>
                            <div>
                                <h4 class="font-bold text-sm text-zinc-800 dark:text-white">Business Health</h4>
                                <div class="flex items-center gap-2 mt-1.5">
                                    <div class="flex-1 h-1.5 bg-gray-100 dark:bg-zinc-700 rounded-full overflow-hidden w-24">
                                        <div class="h-full w-[82%] bg-green-500 rounded-full"></div>
                                    </div>
                                    <span class="text-xs font-bold text-green-600">82/100</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Monitor Stand Base (Behind) -->
                    <div class="absolute bottom-[-20px] left-1/2 -translate-x-1/2 w-40 h-8 bg-zinc-800 rounded-lg shadow-xl -z-10"></div>
                    <div class="absolute bottom-[-10px] left-1/2 -translate-x-1/2 w-8 h-12 bg-zinc-700 -z-10"></div>

                    <!-- Monitor Frame -->
                    <div class="relative bg-zinc-900 rounded-xl p-3 shadow-2xl shadow-zinc-400/20 dark:shadow-black/50 lg:rotate-y-[-2deg] lg:rotate-x-[2deg] transition-transform duration-700 border border-zinc-700">
                        <!-- Screen Bezel -->
                        <div class="bg-white dark:bg-zinc-950 rounded-lg overflow-hidden aspect-[16/10] relative flex flex-col">
                            
                            <!-- Application Header -->
                            <div class="h-9 bg-white dark:bg-zinc-900 border-b border-gray-200 dark:border-zinc-800 flex items-center justify-between px-3 shrink-0">
                                <div class="flex items-center gap-2">
                                    <div class="w-5 h-5 bg-red-600 rounded flex items-center justify-center text-white text-[10px] font-bold">KP</div>
                                    <span class="text-[10px] font-bold text-zinc-600 dark:text-zinc-300">POS - Kasir 1</span>
                                </div>
                                <div class="flex items-center gap-2 text-[10px] font-medium text-zinc-400">
                                    <span>Session #8392</span>
                                    <span class="w-1.5 h-1.5 rounded-full bg-green-500"></span>
                                </div>
                            </div>

                            <div class="flex-1 flex overflow-hidden bg-gray-50 dark:bg-zinc-950">
                                <!-- Sidebar (Functional) -->
                                <div class="w-12 border-r border-gray-200 dark:border-zinc-800 bg-white dark:bg-zinc-900 flex flex-col items-center py-3 gap-3 shrink-0">
                                    <div class="p-1.5 bg-red-50 dark:bg-red-900/20 text-red-600 rounded-md"><LayoutGrid :size="14" /></div>
                                    <div class="p-1.5 text-zinc-400 hover:bg-gray-50 rounded-md"><ShoppingCart :size="14" /></div>
                                    <div class="p-1.5 text-zinc-400 hover:bg-gray-50 rounded-md"><Box :size="14" /></div>
                                    <div class="mt-auto p-1.5 text-zinc-400"><User :size="14" /></div>
                                </div>

                                <!-- Main POS Area -->
                                <div class="flex-1 flex flex-col min-w-0">
                                    <!-- Search Bar -->
                                    <div class="h-10 border-b border-gray-200 dark:border-zinc-800 flex items-center px-3 bg-white dark:bg-zinc-900">
                                        <div class="relative w-full max-w-md">
                                            <Search :size="12" class="absolute left-2 top-1/2 -translate-y-1/2 text-zinc-400" />
                                            <input type="text" disabled placeholder="Cari produk atau scan barcode..." class="w-full bg-gray-100 dark:bg-zinc-800 border-none rounded text-[10px] py-1 pl-7 pr-2 text-zinc-500 placeholder:text-zinc-400 cursor-default" />
                                        </div>
                                    </div>

                                    <!-- Product Grid -->
                                    <div class="flex-1 p-3 overflow-hidden">
                                        <div class="grid grid-cols-4 gap-2">
                                            <div v-for="i in 8" :key="i" class="bg-white dark:bg-zinc-800 rounded-lg p-2 shadow-sm border border-gray-200 dark:border-zinc-700 flex flex-col aspect-[4/3] relative overflow-hidden group/product">
                                                <div class="absolute inset-0 bg-gradient-to-t from-black/5 to-transparent opacity-0 group-hover/product:opacity-100 transition-opacity"></div>
                                                <div class="w-full h-8 bg-gray-100 dark:bg-zinc-700 rounded mb-auto"></div>
                                                <div class="h-1.5 w-3/4 bg-gray-200 dark:bg-zinc-600 rounded mb-1"></div>
                                                <div class="h-1.5 w-1/2 bg-gray-200 dark:bg-zinc-600 rounded"></div>
                                                <div class="mt-2 text-[8px] font-bold text-red-600">Rp 15.500</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Panel (Cart - Detailed) -->
                                <div class="w-64 bg-white dark:bg-zinc-900 border-l border-gray-200 dark:border-zinc-800 flex flex-col shrink-0 text-[10px]">
                                    <div class="p-3 border-b border-gray-100 dark:border-zinc-800 flex justify-between items-center bg-gray-50/50 dark:bg-zinc-800/50">
                                        <div class="flex items-center gap-2">
                                            <ShoppingCart :size="12" class="text-zinc-500" />
                                            <span class="font-bold text-zinc-700 dark:text-zinc-200">Keranjang Belanja</span>
                                        </div>
                                        <span class="bg-zinc-200 dark:bg-zinc-700 text-zinc-600 dark:text-zinc-300 px-1.5 py-0.5 rounded font-bold">6 item</span>
                                    </div>
                                    
                                    <!-- Cart Items Table -->
                                    <div class="flex-1 overflow-hidden relative">
                                        <table class="w-full text-left border-collapse">
                                            <thead class="bg-gray-50 dark:bg-zinc-950 text-zinc-400 font-medium border-b border-gray-100 dark:border-zinc-800">
                                                <tr>
                                                    <th class="py-1.5 px-2 font-medium w-[45%]">Produk</th>
                                                    <th class="py-1.5 px-1 font-medium text-center">Qty</th>
                                                    <th class="py-1.5 px-2 font-medium text-right">Total</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="(item, idx) in demoProducts" :key="idx" class="border-b border-gray-50 dark:border-zinc-800/50 text-zinc-700 dark:text-zinc-300">
                                                    <td class="py-1.5 px-2">
                                                        <div class="line-clamp-1 font-medium">{{ item.name }}</div>
                                                        <div class="text-[8px] text-zinc-400">@{{ item.price }}</div>
                                                    </td>
                                                    <td class="py-1.5 px-1 text-center font-bold">{{ item.qty }}</td>
                                                    <td class="py-1.5 px-2 text-right font-medium">{{ item.total }}</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        
                                        <!-- Fog at bottom of list -->
                                        <div class="absolute bottom-0 left-0 right-0 h-8 bg-gradient-to-t from-white dark:from-zinc-900 to-transparent pointer-events-none"></div>
                                    </div>

                                    <!-- Totals Section -->
                                    <div class="p-3 bg-gray-50 dark:bg-zinc-950/50 border-t border-gray-100 dark:border-zinc-800 space-y-1.5">
                                        <div class="flex justify-between text-zinc-500">
                                            <span>Subtotal</span> <span class="font-medium">Rp 308.200</span>
                                        </div>
                                        <div class="flex justify-between text-zinc-500">
                                            <span>Pajak (0%)</span> <span class="font-medium">-</span>
                                        </div>
                                        <div class="flex justify-between items-end pt-1 pb-2 border-b border-gray-200 dark:border-zinc-700 mb-1">
                                            <span class="text-xs font-bold text-zinc-800 dark:text-white">Total</span>
                                            <span class="text-lg font-black text-zinc-900 dark:text-white tracking-tight">Rp 308.200</span>
                                        </div>
                                        <div class="grid grid-cols-4 gap-1.5">
                                            <div class="col-span-1 bg-white dark:bg-zinc-800 border border-gray-200 dark:border-zinc-700 rounded flex items-center justify-center text-zinc-400 font-bold text-[9px]">ESC</div>
                                            <div class="col-span-3 bg-red-600 rounded flex items-center justify-center text-white text-[10px] font-bold gap-1 shadow-md shadow-red-600/20 py-2">
                                                <CreditCard :size="10" /> BAYAR (F8)
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Product Features Showcase (Refined Grid with Images) -->
        <section id="features" class="py-24 bg-gray-50 dark:bg-zinc-950">
            <div class="container mx-auto px-6">
                <div class="text-center max-w-2xl mx-auto mb-20">
                    <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-400 text-[11px] font-bold uppercase tracking-wider border border-red-100 dark:border-red-900/30 mb-6">
                        Fitur Unggulan
                    </div>
                    <h2 class="text-4xl font-black mb-6 tracking-tight text-zinc-900 dark:text-white leading-tight">
                        Fitur Pintar untuk <span class="text-red-600">Warung Cerdas</span>
                    </h2>
                    <p class="text-zinc-500 dark:text-zinc-400 text-lg">
                        Kelola stok anti bocor, laporan keuangan otomatis, dan pantau expired date tanpa pusing.
                    </p>
                </div>

                <div class="grid md:grid-cols-3 gap-8">
                    <!-- Feature 1: Kasir -->
                    <div class="group relative flex flex-col bg-white dark:bg-zinc-900 rounded-[32px] overflow-hidden border border-gray-100 dark:border-zinc-800 transition-all duration-500 hover:-translate-y-2 hover:shadow-2xl hover:shadow-red-600/10 hover:border-red-600/30">
                        <div class="h-48 overflow-hidden bg-gray-100 dark:bg-zinc-800">
                            <img src="https://images.unsplash.com/photo-1556742044-3c52d6e88c62?q=80&w=600&auto=format&fit=crop" alt="Smart POS" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110 opacity-90 group-hover:opacity-100" />
                        </div>
                        <div class="p-8 space-y-4">
                            <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 text-red-600 rounded-2xl flex items-center justify-center transition-colors duration-500 group-hover:bg-red-600 group-hover:text-white">
                                <Zap :size="24" />
                            </div>
                            <h3 class="text-xl font-black text-zinc-900 dark:text-white tracking-tight">Kasir Super Cepat</h3>
                            <p class="text-zinc-500 dark:text-zinc-400 text-sm leading-relaxed">
                                Cukup scan barcode atau ketik nama barang. Sistem otomatis hitung kembalian dan cetak struk dalam hitungan detik.
                            </p>
                        </div>
                        <!-- Hover Color Accent -->
                        <div class="absolute bottom-0 left-0 h-1 w-0 bg-red-600 transition-all duration-500 group-hover:w-full"></div>
                    </div>

                    <!-- Feature 2: AI Stock -->
                    <div class="group relative flex flex-col bg-white dark:bg-zinc-900 rounded-[32px] overflow-hidden border border-gray-100 dark:border-zinc-800 transition-all duration-500 hover:-translate-y-2 hover:shadow-2xl hover:shadow-orange-600/10 hover:border-orange-600/30">
                        <div class="h-48 overflow-hidden bg-gray-100 dark:bg-zinc-800 text-white">
                            <img src="https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=600&auto=format&fit=crop" alt="Inventory" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110 opacity-90 group-hover:opacity-100" />
                        </div>
                        <div class="p-8 space-y-4">
                            <div class="w-12 h-12 bg-orange-50 dark:bg-orange-900/20 text-orange-600 rounded-2xl flex items-center justify-center transition-colors duration-500 group-hover:bg-orange-600 group-hover:text-white">
                                <Sparkles :size="24" />
                            </div>
                            <h3 class="text-xl font-black text-zinc-900 dark:text-white tracking-tight">Asisten Anti "Stok Mati"</h3>
                            <p class="text-zinc-500 dark:text-zinc-400 text-sm leading-relaxed">
                                AI kami memberitahu barang mana yang laris manis dan barang mana yang sudah 45 hari tidak laku. Optimalkan perputaran modal!
                            </p>
                        </div>
                        <div class="absolute bottom-0 left-0 h-1 w-0 bg-orange-600 transition-all duration-500 group-hover:w-full"></div>
                    </div>

                    <!-- Feature 3: Finance -->
                    <div class="group relative flex flex-col bg-white dark:bg-zinc-900 rounded-[32px] overflow-hidden border border-gray-100 dark:border-zinc-800 transition-all duration-500 hover:-translate-y-2 hover:shadow-2xl hover:shadow-green-600/10 hover:border-green-600/30">
                        <div class="h-48 overflow-hidden bg-gray-100 dark:bg-zinc-800">
                            <img src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=600&auto=format&fit=crop" alt="Reports" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110 opacity-90 group-hover:opacity-100" />
                        </div>
                        <div class="p-8 space-y-4">
                            <div class="w-12 h-12 bg-green-50 dark:bg-green-900/20 text-green-600 rounded-2xl flex items-center justify-center transition-colors duration-500 group-hover:bg-green-600 group-hover:text-white">
                                <TrendingUp :size="24" />
                            </div>
                            <h3 class="text-xl font-black text-zinc-900 dark:text-white tracking-tight">Laporan Untung Rugi</h3>
                            <p class="text-zinc-500 dark:text-zinc-400 text-sm leading-relaxed">
                                Lihat omzet harian, mingguan, dan bulanan secara visual. Tahu persis berapa keuntungan bersih yang bisa langsung masuk kantong.
                            </p>
                        </div>
                        <div class="absolute bottom-0 left-0 h-1 w-0 bg-green-600 transition-all duration-500 group-hover:w-full"></div>
                    </div>
                </div>

                <!-- Comprehensive All Features Grid -->
                <div class="mt-40">
                    <div class="text-center max-w-2xl mx-auto mb-16">
                        <h2 class="text-3xl font-black mb-4 tracking-tight text-zinc-900 dark:text-white">Ekosistem POS Terlengkap</h2>
                        <p class="text-zinc-500 dark:text-zinc-400">Segala instrumen yang Anda butuhkan untuk menguasai pasar retail.</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <!-- Operational -->
                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 text-blue-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Wallet :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">QRIS Dinamis</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Terima pembayaran e-wallet (GoPay, OVO, Dana) dengan QR code otomatis per transaksi.</p>
                        </div>

                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-purple-50 dark:bg-purple-900/20 text-purple-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Users :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Manajemen Pelanggan</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Simpan data pelanggan, riwayat belanja, dan berikan promo loyalitas khusus.</p>
                        </div>

                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <RefreshCcw :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Sistem Retur Mudah</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Kelola pengembalian barang rusak atau salah beli dengan pencatatan stok yang akurat.</p>
                        </div>

                        <!-- Inventory -->
                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-orange-50 dark:bg-orange-900/20 text-orange-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <ClipboardCheck :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Audit Stok (Opname)</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Lakukan pencocokan stok fisik vs sistem dengan cepat tanpa menghentikan penjualan.</p>
                        </div>

                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-amber-50 dark:bg-amber-900/20 text-amber-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Truck :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Manajemen Supplier</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Kelola database supplier, harga beli termurah, dan buat Purchase Order otomatis.</p>
                        </div>

                        <!-- Financial -->
                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <PieChart :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Expense Tracking</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Catat semua pengeluaran operasional (listrik, gaji, sewa) untuk tahu profit bersih.</p>
                        </div>

                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-gray-50 dark:bg-zinc-800 dark:text-gray-300 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Database :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Cloud Backup</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Data transaksi Anda aman tersimpan di cloud dengan cadangan harian otomatis.</p>
                        </div>

                        <!-- Intelligence -->
                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-900/20 text-indigo-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Bot :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">AI Voice Assistant</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Tanyakan stok atau laporan lewat suara. Asisten AI siap membantu navigasi Anda.</p>
                        </div>

                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-cyan-50 dark:bg-cyan-900/20 text-cyan-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Calendar :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Forecast Penjualan</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Sistem memprediksi tren penjualan bulan depan berdasarkan data historis toko.</p>
                        </div>

                        <div class="p-6 rounded-3xl bg-gray-50/50 dark:bg-zinc-900/50 border border-gray-100 dark:border-zinc-800 hover:bg-white dark:hover:bg-zinc-900 hover:shadow-xl transition-all group">
                            <div class="w-10 h-10 rounded-xl bg-teal-50 dark:bg-teal-900/20 text-teal-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <Globe :size="20" />
                            </div>
                            <h4 class="font-bold text-zinc-900 dark:text-white mb-2">Remote Monitoring</h4>
                            <p class="text-sm text-zinc-500 leading-relaxed">Pantau perkembangan toko dari mana saja, kapan saja, langsung melalui smartphone Anda.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <footer class="bg-white dark:bg-zinc-950 py-12 border-t border-gray-100 dark:border-zinc-900">
            <div class="container mx-auto px-6 flex flex-col md:flex-row justify-between items-center gap-6">
                 <div class="flex items-center gap-2">
                    <div class="w-6 h-6 bg-red-600 rounded flex items-center justify-center text-white text-[10px] font-bold">K</div>
                    <span class="font-bold text-sm tracking-tight text-zinc-800 dark:text-gray-100">KelontongPOS</span>
                </div>
                <div class="text-zinc-400 text-xs">
                    &copy; 2024 KelontongPOS. Dibuat dengan ❤️ untuk UMKM Indonesia.
                </div>
            </div>
        </footer>
    </div>
</template>

<style scoped>
@keyframes float-slow {
    0%, 100% { transform: translateY(0) rotate(1deg); }
    50% { transform: translateY(-8px) rotate(1deg); }
}
@keyframes float-delayed {
    0%, 100% { transform: translateY(0) rotate(-1deg); }
    50% { transform: translateY(-6px) rotate(-1deg); }
}
.animate-float-slow {
    animation: float-slow 5s ease-in-out infinite;
}
.animate-float-delayed {
    animation: float-delayed 6s ease-in-out infinite;
    animation-delay: 2s;
}
/* Custom grid background effect */
.bg-grid-white {
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32' fill='none' stroke='rgb(255 255 255 / 0.04)'%3e%3cpath d='M0 .5H31.5V32'/%3e%3c/svg%3e");
}
</style>
