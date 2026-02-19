export const printReceipt = (transaction, storeCheck = false) => {
    // Basic Thermal Receipt Template
    // Optimized for 58mm/80mm widths

    const {
        store,
        user,
        items,
        subtotal,
        tax,
        discount,
        grand_total,
        cash_received,
        change_amount,
        invoice_number,
        created_at
    } = transaction;

    const receiptContent = `
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Receipt ${invoice_number}</title>
            <style>
                @page {
                    margin: 0;
                    padding: 0;
                }
                body {
                    font-family: 'Courier New', Courier, monospace;
                    font-size: 12px;
                    width: 58mm; /* Adjust for 80mm if needed */
                    margin: 0 auto;
                    padding: 10px;
                    color: #000;
                }
                .text-center { text-align: center; }
                .text-right { text-align: right; }
                .text-left { text-align: left; }
                .bold { font-weight: bold; }
                .divider { border-top: 1px dashed #000; margin: 5px 0; }
                .item-row { display: flex; justify-content: space-between; }
                .item-name { width: 100%; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; }
                .totals-row { display: flex; justify-content: space-between; margin-top: 2px; }
                .footer { margin-top: 10px; font-size: 10px; }
            </style>
        </head>
        <body>
            <div class="text-center bold">
                ${store?.name || 'POS KELONTONG'}<br>
                ${store?.address || 'Jl. Raya No. 1'}<br>
                ${store?.phone || ''}
            </div>
            
            <div class="divider"></div>
            
            <div>
                Date: ${new Date(created_at).toLocaleString('id-ID')}<br>
                Inv: ${invoice_number}<br>
                Cashier: ${user?.name || 'Admin'}
            </div>

            <div class="divider"></div>

            ${items.map(item => `
                <div style="margin-bottom: 4px;">
                    <div class="item-name">${item.product_name}</div>
                    <div class="item-row">
                        <span>${item.quantity} x ${parseInt(item.price).toLocaleString('id-ID')}</span>
                        <span>${(item.quantity * item.price).toLocaleString('id-ID')}</span>
                    </div>
                </div>
            `).join('')}

            <div class="divider"></div>

            <div class="totals-row">
                <span>Subtotal</span>
                <span>${parseInt(subtotal).toLocaleString('id-ID')}</span>
            </div>
            
            ${discount > 0 ? `
            <div class="totals-row">
                <span>Discount</span>
                <span>-${parseInt(discount).toLocaleString('id-ID')}</span>
            </div>
            ` : ''}
            
            <div class="totals-row bold" style="font-size: 14px; margin-top: 5px;">
                <span>TOTAL</span>
                <span>${parseInt(grand_total).toLocaleString('id-ID')}</span>
            </div>
            
            <div class="divider"></div>

            <div class="totals-row">
                <span>Cash</span>
                <span>${parseInt(cash_received).toLocaleString('id-ID')}</span>
            </div>
            <div class="totals-row">
                <span>Change</span>
                <span>${parseInt(change_amount).toLocaleString('id-ID')}</span>
            </div>

            <div class="divider"></div>

            <div class="text-center footer">
                Thank you for shopping!<br>
                Items purchased cannot be returned.
            </div>
        </body>
        </html>
    `;

    // Create a hidden iframe
    const iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    document.body.appendChild(iframe);

    // Write content to iframe
    const doc = iframe.contentWindow.document;
    doc.open();
    doc.write(receiptContent);
    doc.close();

    // Trigger print
    iframe.contentWindow.focus();
    iframe.contentWindow.print();

    // Cleanup
    // setTimeout(() => {
    //     document.body.removeChild(iframe);
    // }, 1000);
};
