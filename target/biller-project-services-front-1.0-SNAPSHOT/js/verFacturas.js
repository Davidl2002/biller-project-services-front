document.addEventListener('DOMContentLoaded', function () {
    const buscarFacturaForm = document.getElementById('buscarFacturaForm');
    const btnMostrarFactura = document.getElementById('btnMostrarFactura');

    buscarFacturaForm.addEventListener('submit', function (event) {
        event.preventDefault(); // Prevenir el envío normal del formulario

        const facturaId = document.getElementById('inputFacturaId').value;
        buscarFacturaPorId(facturaId);
    });

    btnMostrarFactura.addEventListener('click', function () {
        mostrarModalFactura();
    });

    // Agregar evento click al botón Generar PDF
    const btnGenerarPDF = document.getElementById('btnGenerarPDF');
    btnGenerarPDF.addEventListener('click', function () {
        generarPDF();
    });
});

let facturaActual = null;

function buscarFacturaPorId(facturaId) {
    fetch(`http://localhost:8080/api/bills/${facturaId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Factura no encontrada');
            }
            return response.json();
        })
        .then(data => {
            mostrarDetallesFactura(data);
            facturaActual = data;
            document.getElementById('btnMostrarFactura').style.display = 'block';
        })
        .catch(error => {
            console.error('Error al buscar la factura:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error al buscar la factura',
                text: 'No se encontró la factura especificada. Verifica el ID e intenta de nuevo.'
            });
        });
}

function mostrarDetallesFactura(factura) {
    const facturaDetails = document.getElementById('facturaDetails');

    const detallesHTML = factura.detalle && factura.detalle.length > 0 
        ? factura.detalle.map(detalle => `<li>Producto: ${detalle.productName}, Precio: $${detalle.productUnitPrice}, Cantidad: ${detalle.quantity}</li>`).join('')
        : '<li>No hay productos en esta factura.</li>';

    const facturaHTML = `
        <div class="card">
            <div class="card-header">
                Detalles de la Factura #${factura.billId}
            </div>
            <div class="card-body">
                <h5 class="card-title">Fecha: ${factura.dateBill}</h5>
                <p class="card-text">Subtotal: ${factura.subtotal}</p>
                <p class="card-text">Total: ${factura.total}</p>
                ${factura.customer && factura.customer.customerId !== 0 ? `
                    <p class="card-text">Cliente: ${factura.customer.firstName} ${factura.customer.lastName}</p>
                    <p class="card-text">DNI: ${factura.customer.customerDni}</p>
                    <p class="card-text">Email: ${factura.customer.email}</p>
                    <p class="card-text">Dirección: ${factura.customer.address}</p>
                    <p class="card-text">Teléfono: ${factura.customer.phoneNumber}</p>
                ` : '<p class="card-text">Cliente: Consumidor Final</p>'}
                <h5>Detalles de los productos:</h5>
                <ul>
                    ${detallesHTML}
                </ul>
            </div>
        </div>
    `;

    facturaDetails.innerHTML = facturaHTML;
}

function mostrarModalFactura() {
    generarPDF();
    const facturaModal = new bootstrap.Modal(document.getElementById('facturaModal'));
    facturaModal.show();
}

function generarPDF() {
    if (!facturaActual) {
        Swal.fire({
            icon: 'error',
            title: 'No se puede generar el PDF',
            text: 'Primero busque una factura para generar el PDF.'
        });
        return;
    }

    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();

    // Configuración de estilos
    doc.setFontSize(12);
    const marginLeft = 10;
    const lineSpacing = 7;
    let y = 10;

    // Encabezado de la factura
    doc.setFont('helvetica', 'bold');
    doc.text('TIENDA', marginLeft, y);
    y += lineSpacing;
    y += lineSpacing;
    doc.text('Factura de Venta', marginLeft, y);
    y += lineSpacing;
    doc.setFont('helvetica', 'normal');
    doc.text(`Factura #: ${facturaActual.billId}`, marginLeft, y);
    y += lineSpacing;
    doc.text(`Fecha: ${facturaActual.dateBill}`, marginLeft, y);
    y += lineSpacing;
    y += lineSpacing;

    // Información del cliente
    doc.setFont('helvetica', 'bold');
    doc.text('Datos del Cliente:', marginLeft, y);
    y += lineSpacing;
    doc.setFont('helvetica', 'normal');
    if (facturaActual.customer && facturaActual.customer.customerId !== 0) {
        doc.text(`Nombre: ${facturaActual.customer.firstName} ${facturaActual.customer.lastName}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`DNI: ${facturaActual.customer.customerDni}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`Email: ${facturaActual.customer.email}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`Dirección: ${facturaActual.customer.address}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`Teléfono: ${facturaActual.customer.phoneNumber}`, marginLeft, y);
        y += lineSpacing;
    } else {
        doc.text('Cliente: Consumidor Final', marginLeft, y);
        y += lineSpacing;
    }

    // Detalles de los productos
    y += 10;
    doc.setFont('helvetica', 'bold');
    doc.text('Detalles de los Productos:', marginLeft, y);
    y += lineSpacing;

    // Cabecera de la tabla
    doc.setFont('helvetica', 'bold');
    doc.text('Producto', marginLeft, y);
    doc.text('Precio', marginLeft + 70, y);
    doc.text('Cantidad', marginLeft + 110, y);
    doc.text('Total', marginLeft + 150, y);
    y += lineSpacing;

    doc.setFont('helvetica', 'normal');
    if (facturaActual.detalle && facturaActual.detalle.length > 0) {
        facturaActual.detalle.forEach((detalle) => {
            doc.text(detalle.productName, marginLeft, y);
            doc.text(`$${detalle.productUnitPrice.toFixed(2)}`, marginLeft + 70, y);
            doc.text(`${detalle.quantity}`, marginLeft + 110, y);
            doc.text(`$${(detalle.productUnitPrice * detalle.quantity).toFixed(2)}`, marginLeft + 150, y);
            y += lineSpacing;
        });
    } else {
        doc.text('No hay productos en esta factura.', marginLeft, y);
        y += lineSpacing;
    }

    // Subtotal y Total
    y += 10;
    doc.setFont('helvetica', 'bold');
    doc.text(`Subtotal: $${facturaActual.subtotal.toFixed(2)}`, marginLeft, y);
    y += lineSpacing;
    doc.text(`Total: $${facturaActual.total.toFixed(2)}`, marginLeft, y);

    // Generar PDF en base64
    const pdfDataUri = doc.output('datauristring');
    const pdfContainer = document.getElementById('facturaPDF');
    pdfContainer.innerHTML = `<iframe src="${pdfDataUri}" width="100%" height="500px"></iframe>`;
}
