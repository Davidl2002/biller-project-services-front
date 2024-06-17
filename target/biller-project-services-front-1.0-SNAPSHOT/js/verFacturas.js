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
                ${factura.customer ? `
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

    doc.text(`Factura #${facturaActual.billId}`, 10, 10);
    doc.text(`Fecha: ${facturaActual.dateBill}`, 10, 20);
    doc.text(`Subtotal: $${facturaActual.subtotal}`, 10, 30);
    doc.text(`Total: $${facturaActual.total}`, 10, 40);

    if (facturaActual.customer) {
        doc.text(`Cliente: ${facturaActual.customer.firstName} ${facturaActual.customer.lastName}`, 10, 50);
        doc.text(`DNI: ${facturaActual.customer.customerDni}`, 10, 60);
        doc.text(`Email: ${facturaActual.customer.email}`, 10, 70);
        doc.text(`Dirección: ${facturaActual.customer.address}`, 10, 80);
        doc.text(`Teléfono: ${facturaActual.customer.phoneNumber}`, 10, 90);
    } else {
        doc.text('Cliente: Consumidor Final', 10, 50);
    }

    doc.text('Detalles de los productos:', 10, 100);
    if (facturaActual.detalle && facturaActual.detalle.length > 0) {
        facturaActual.detalle.forEach((detalle, index) => {
            doc.text(`Producto: ${detalle.productName}, Precio: $${detalle.productUnitPrice}, Cantidad: ${detalle.quantity}`, 10, 110 + (index * 10));
        });
    } else {
        doc.text('No hay productos en esta factura.', 10, 110);
    }

    const pdfDataUri = doc.output('datauristring');
    const pdfContainer = document.getElementById('facturaPDF');
    pdfContainer.innerHTML = `<iframe src="${pdfDataUri}" width="100%" height="500px"></iframe>`;
}
