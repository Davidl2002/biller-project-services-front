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
    
        btnVerTodo.addEventListener('click', function () {
        mostrarTodasFacturas();
    });

    // Agregar evento click al botón Generar PDF
    const btnGenerarPDF = document.getElementById('btnGenerarPDF');
    btnGenerarPDF.addEventListener('click', function () {
        generarPDF();
    });
});

function mostrarTodasFacturas() {
    fetch('https://biller-project-services.onrender.com/api/bills')
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al obtener las facturas');
            }
            return response.json();
        })
        .then(data => {
            mostrarModalTodasFacturas(data); // Mostrar todas las facturas en el modal
        })
        .catch(error => {
            console.error('Error al obtener las facturas:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error al obtener las facturas',
                text: 'No se pudieron obtener las facturas. Inténtalo de nuevo más tarde.'
            });
        });
}

function mostrarModalTodasFacturas(facturas) {
    const modalTodasFacturas = new bootstrap.Modal(document.getElementById('modalTodasFacturas'));
    const todasFacturasContainer = document.getElementById('todasFacturasContainer');

    let html = '<ul class="list-group">';
    facturas.forEach(factura => {
        const cliente = factura.customer
            ? `${factura.billId} <span style="margin-left: 10px;">${factura.customer.firstName || 'Consumidor'} ${factura.customer.lastName || 'Final'}</span>`
            : `${factura.billId} Consumidor Final`;
        
        html += `<li class="list-group-item d-flex justify-content-between align-items-center">
                    ${cliente}
                    <button class="btn btn-primary" onclick="verPDF(${factura.billId})">Ver PDF</button>
                </li>`;
    });
    html += '</ul>';

    todasFacturasContainer.innerHTML = html;
    modalTodasFacturas.show();
}



function verPDF(facturaId) {
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
            mostrarModalFactura(); // Mostrar el modal con la factura seleccionada
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
        ? factura.detalle.map(detalle => `<li>${detalle.productName}, Unidades: ${detalle.quantity}</li>`).join('')
        : '<li>No hay productos en esta factura.</li>';

    const facturaHTML = `
        <div class="card">
    <div class="card-header">
        Detalles de la Factura #${factura.number}
    </div>
    <div class="card-body">
        <h5 class="card-title">Fecha: ${formatoFecha(factura.dateBill)}</h5>
        <h5>Cliente Facturado:</h5>
        ${factura.customer && factura.customer.customerId !== 0 ? `
                ${factura.customer.idType.typeId === 1 ? `
                    <p class="card-text">C. I: ${factura.customer.customerDni}</p>
                ` : `
                    <p class="card-text">RUC: ${factura.customer.customerDni}</p>
                `}
                <p class="card-text">Cliente: ${factura.customer.firstName} ${factura.customer.lastName}</p>
        ` : '<p class="card-text">Consumidor Final</p>'}
        <h5>Productos:</h5>
        <ul>
            ${detallesHTML}
        </ul>
        <p class="card-text">Total: $${factura.total.toFixed(2)}</p>
    </div>
</div>

    `;

    facturaDetails.innerHTML = facturaHTML;
}

    function formatoFecha(fecha) {
        // Obtener objetos de fecha
        const dateObj = new Date(fecha);
        
        // Obtener componentes de fecha y hora
        const day = dateObj.getDate().toString().padStart(2, '0');
        const month = (dateObj.getMonth() + 1).toString().padStart(2, '0'); // Los meses van de 0 a 11 en JavaScript
        const year = dateObj.getFullYear();
        const hours = dateObj.getHours().toString().padStart(2, '0');
        const minutes = dateObj.getMinutes().toString().padStart(2, '0');
        
        // Formatear la fecha como dd/mm/yyyy hh:mm
        const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;
        
        return formattedDate;
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
    let textWidth = doc.getTextDimensions('MINIMARKET FOUR').w;
    let centerX = (doc.internal.pageSize.getWidth() - textWidth) / 2;
    doc.text('MINIMARKET FOUR', centerX, y);
    y += lineSpacing;
    doc.setFont('helvetica', 'normal');
    textWidth = doc.getTextDimensions('Dirección: Av. los chásquis, Télefono: 0987730252').w;
    centerX = (doc.internal.pageSize.getWidth() - textWidth) / 2;
    doc.text('Dirección: Av. los chásquis, Télefono: 0987730252', centerX, y);
    y += lineSpacing;
    y += lineSpacing;
    doc.setFont('helvetica', 'normal');
    doc.text(`NÚMERO DE FACTURA: ${facturaActual.number}`, marginLeft, y);
    y += lineSpacing;
    doc.text(`FECHA: ${formatDate(facturaActual.dateBill)}`, marginLeft, y);
    y += lineSpacing;
    y += lineSpacing;

    // Información del cliente
    doc.setFont('helvetica', 'normal');
    doc.text('FACTURADO A', marginLeft, y);
    y += lineSpacing;
    doc.setFont('helvetica', 'normal');
    if (facturaActual.customer && facturaActual.customer.customerId !== 0) {
        doc.text(`Nombre del Cliente: ${facturaActual.customer.firstName} ${facturaActual.customer.lastName}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`C. I/RUC: ${facturaActual.customer.customerDni}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`Email: ${facturaActual.customer.email}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`Dirección: ${facturaActual.customer.address}`, marginLeft, y);
        y += lineSpacing;
        doc.text(`Teléfono: ${facturaActual.customer.phoneNumber}`, marginLeft, y);
        y += lineSpacing;
    } else {
        doc.text('Consumidor Final', marginLeft, y);
        y += lineSpacing;
    }

    // Detalles de los productos
    y += 10;
    doc.setFont('helvetica', 'normal');
    doc.text('DETALLES', marginLeft, y);
    y += lineSpacing;

    // Cabecera de la tabla
    doc.setFont('helvetica', 'bold');
    doc.text('Producto', marginLeft, y);
    doc.text('P. Unitario', marginLeft + 70, y);
    doc.text('Cantidad', marginLeft + 110, y);
    doc.text('Subtotal', marginLeft + 150, y);
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
    doc.setFont('helvetica', 'normal');
    doc.text(`Subtotal: $${facturaActual.subtotal.toFixed(2)}`, marginLeft + 150, y);
    y += lineSpacing;
    doc.text(`IVA: $${(facturaActual.subtotal * 0.15).toFixed(2)}`, marginLeft + 150, y);
    y += lineSpacing;
    doc.text(`Total: $${facturaActual.total.toFixed(2)}`, marginLeft + 150, y);

    // Generar PDF en base64
    const pdfDataUri = doc.output('datauristring');
    const pdfContainer = document.getElementById('facturaPDF');
    pdfContainer.innerHTML = `<iframe src="${pdfDataUri}" width="100%" height="500px"></iframe>`;
}

function formatDate(fecha) {
    const date = new Date(fecha);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
}
