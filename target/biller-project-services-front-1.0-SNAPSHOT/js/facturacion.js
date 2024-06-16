let productosFactura = [];
let subtotal = 0;
let totalIva = 0;

const subtotalProElement = document.getElementById('subtotalPro');
const subtotalSumaElement = document.getElementById('subtotalSuma');

document.addEventListener('DOMContentLoaded', function() {
    const formsFacturacion = document.querySelectorAll('.facturacionForm');
    formsFacturacion.forEach(form => {
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            const formData = new FormData(form);
            const productoId = formData.get('producto');
            const productoNombre = formData.get('name');
            const cantidad = parseInt(formData.get('cantidad'));
            const precio = parseFloat(formData.get('unitPrice'));

            let productoExistente = productosFactura.find(producto => producto.id === productoId);
            if (productoExistente) {
                productoExistente.cantidad += cantidad;
            } else {
                productosFactura.push({ id: productoId, nombre: productoNombre, cantidad: cantidad, precio: precio });
            }
            
            actualizarListaProductos(productosFactura);
        });
    });
});

function actualizarListaProductos(productos) {
    const listaProductos = document.getElementById('listaProductos');
    listaProductos.innerHTML = '';
    subtotal = 0;

    productos.forEach(producto => {
        const productoDiv = document.createElement('div');
        productoDiv.classList.add('producto', 'list-group-item');

        const nombreProducto = document.createElement('strong');
        nombreProducto.textContent = producto.nombre;

        const cantidadProducto = document.createElement('span');
        cantidadProducto.classList.add('cantidad');
        cantidadProducto.textContent = `Cantidad: ${producto.cantidad}`;

        const subtotalProducto = document.createElement('span');
        subtotalProducto.classList.add('subtotal');
        const subtotalProductoValor = producto.precio * producto.cantidad;
        subtotal += subtotalProductoValor;
        subtotalProducto.textContent = `Subtotal: $${subtotalProductoValor.toFixed(2)}`;

        const btnQuitarCantidad = document.createElement('button');
        btnQuitarCantidad.textContent = 'Quitar';
        btnQuitarCantidad.classList.add('btn', 'btn-sm', 'btn-danger', 'btn-quitar');
        btnQuitarCantidad.addEventListener('click', function() {
            quitarCantidad(producto.id);
        });

        productoDiv.appendChild(nombreProducto);
        productoDiv.appendChild(cantidadProducto);
        productoDiv.appendChild(btnQuitarCantidad);
        productoDiv.appendChild(subtotalProducto);
        listaProductos.appendChild(productoDiv);
    });

    totalIva = subtotal + (subtotal * 0.15);

    subtotalProElement.innerHTML = ''; // Limpiar contenido anterior
    subtotalSumaElement.innerHTML = ''; // Limpiar contenido anterior

    const subtotalGeneral = document.createElement('h4');
    subtotalGeneral.textContent = `Subtotal: $${subtotal.toFixed(2)}`;
    subtotalProElement.appendChild(subtotalGeneral);

    const totalGeneral = document.createElement('h4');
    totalGeneral.textContent = `Total: $${totalIva.toFixed(2)}`;
    subtotalSumaElement.appendChild(totalGeneral);
}

function quitarCantidad(productoId) {
    const index = productosFactura.findIndex(producto => producto.id === productoId);
    if (index !== -1) {
        const cantidadQuitar = parseInt(prompt('Ingrese la cantidad que desea quitar:', ''));
        if (!isNaN(cantidadQuitar) && cantidadQuitar > 0) {
            productosFactura[index].cantidad -= cantidadQuitar;
            if (productosFactura[index].cantidad <= 0) {
                productosFactura.splice(index, 1);
            }
            actualizarListaProductos(productosFactura);
        } else {
            alert('Ingrese una cantidad válida mayor a 0.');
        }
    } else {
        alert('El producto no está en la lista de productos de la factura.');
    }
}


document.getElementById('generarFacturaBtn').addEventListener('click', function() {
    generarFactura();
});

function generarFactura() {
    const detalles = productosFactura.map(producto => ({
        product: parseInt(producto.id),
        quantity: producto.cantidad
    }));

    const factura = {
        total: totalIva,
        subtotal: subtotal,
        detalles: detalles
    };

    enviarFacturaAPI(factura);
}

function enviarFacturaAPI(factura) {
    const url = 'http://localhost:8080/api/bills'; // URL de tu API para crear la factura
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
            // Puedes agregar más headers si tu API los requiere
        },
        body: JSON.stringify(factura)
    };

    fetch(url, options)
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al enviar la factura');
            }
            return response.json();
        })
        .then(data => {
            alert('Factura creada exitosamente');
            // Aquí puedes manejar la respuesta de la API si necesitas hacer algo más
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Hubo un error al crear la factura');
        });
}


//function generarPDF() {
//
//    const docDefinition = {
//        content: [
//            'Factura',
//            
//        ]
//    };
//
//    
//    pdfMake.createPdf(docDefinition).open();
//}
