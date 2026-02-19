<div class="bg-slate-800 rounded-xl shadow-lg border border-slate-700 overflow-hidden">
    <!-- Header -->
    <div class="p-6 border-b border-slate-700 flex flex-col md:flex-row justify-between items-center gap-4">
        <div>
            <h2 class="text-xl font-bold text-white">Supplier Management</h2>
            <p class="text-sm text-slate-400">Manage vendors and suppliers</p>
        </div>
        <button wire:click="create" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg flex items-center gap-2 transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            Add Supplier
        </button>
    </div>

    <!-- Search -->
    <div class="px-6 py-4 bg-slate-700/30">
        <input wire:model.live.debounce.300ms="search" type="text" placeholder="Search by name or contact person..." 
            class="w-full md:w-1/3 bg-slate-900 border border-slate-600 rounded-lg py-2 px-4 text-white focus:outline-none focus:border-indigo-500">
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm text-slate-300">
            <thead class="bg-slate-700/50 text-xs uppercase font-semibold text-slate-400">
                <tr>
                    <th class="px-6 py-4">Name</th>
                    <th class="px-6 py-4">Contact</th>
                    <th class="px-6 py-4">Phone/Email</th>
                    <th class="px-6 py-4">Lead Time</th>
                    <th class="px-6 py-4 text-center">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-700">
                @forelse($suppliers as $supplier)
                    <tr class="hover:bg-slate-700/30 transition-colors">
                        <td class="px-6 py-4 font-medium text-white">{{ $supplier->name }}</td>
                        <td class="px-6 py-4">{{ $supplier->contact_person ?? '-' }}</td>
                        <td class="px-6 py-4">
                            <div class="flex flex-col">
                                <span>{{ $supplier->phone ?? '-' }}</span>
                                <span class="text-xs text-slate-500">{{ $supplier->email }}</span>
                            </div>
                        </td>
                        <td class="px-6 py-4">{{ $supplier->default_lead_time_days }} days</td>
                        <td class="px-6 py-4 text-center">
                            <button wire:click="edit({{ $supplier->id }})" class="text-blue-400 hover:text-blue-300 mx-2">Edit</button>
                            <button wire:click="delete({{ $supplier->id }})" wire:confirm="Delete this supplier?" class="text-red-400 hover:text-red-300 mx-2">Delete</button>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="5" class="px-6 py-8 text-center">No suppliers found.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="px-6 py-4 border-t border-slate-700">
        {{ $suppliers->links() }}
    </div>

    <!-- Modal -->
    @if($showModal)
    <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm" wire:click="$set('showModal', false)">
        <div class="bg-slate-800 rounded-xl shadow-2xl w-full max-w-lg border border-slate-700 p-6" wire:click.stop>
            <h3 class="text-xl font-bold text-white mb-4">{{ $isEditing ? 'Edit Supplier' : 'Add New Supplier' }}</h3>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="col-span-2">
                    <label class="block text-sm text-slate-400 mb-1">Company Name</label>
                    <input wire:model="name" type="text" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    @error('name') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>
                
                <div>
                    <label class="block text-sm text-slate-400 mb-1">Contact Person</label>
                    <input wire:model="contact_person" type="text" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    @error('contact_person') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>

                <div>
                    <label class="block text-sm text-slate-400 mb-1">Phone</label>
                    <input wire:model="phone" type="text" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    @error('phone') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>

                <div class="col-span-2">
                    <label class="block text-sm text-slate-400 mb-1">Email</label>
                    <input wire:model="email" type="email" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    @error('email') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>

                <div class="col-span-2">
                    <label class="block text-sm text-slate-400 mb-1">Address</label>
                    <textarea wire:model="address" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500" rows="2"></textarea>
                    @error('address') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>

                <div>
                    <label class="block text-sm text-slate-400 mb-1">Default Lead Time (Days)</label>
                    <input wire:model="default_lead_time_days" type="number" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    @error('default_lead_time_days') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>

                 <div>
                    <label class="block text-sm text-slate-400 mb-1">Min Order Value</label>
                    <input wire:model="minimum_order_value" type="number" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    @error('minimum_order_value') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                </div>
            </div>

            <div class="mt-6 flex justify-end gap-3">
                <button wire:click="$set('showModal', false)" class="px-4 py-2 bg-slate-700 text-white rounded-lg hover:bg-slate-600">Cancel</button>
                <button wire:click="save" class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">Save</button>
            </div>
        </div>
    </div>
    @endif
</div>
