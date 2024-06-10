document.addEventListener('DOMContentLoaded', function() {
    cargarProductos();
});

let productosFactura = []; // Lista de productos en la factura

function cargarProductos() {
    // Llamar a la API para obtener la lista de productos
    // Simulación de productos por defecto
    const productos = [
        { id: 1, nombre: 'Producto 1' },
        { id: 2, nombre: 'Producto 2' },
        { id: 3, nombre: 'Producto 3' }
    ];

    const selectProducto = document.getElementById('producto');
    productos.forEach(producto => {
        const option = document.createElement('option');
        option.value = producto.id;
        option.text = producto.nombre;
        selectProducto.appendChild(option);
    });
}

document.getElementById('facturacionForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const formData = new FormData(this);
    const productoId = formData.get('producto');
    const cantidad = parseInt(formData.get('cantidad')); // Convertir a entero

    // Verificar si el producto ya está en la lista de productos de la factura
    const productoExistente = productosFactura.find(producto => producto.id === productoId);
    if (productoExistente) {
        // Actualizar la cantidad
        productoExistente.cantidad += cantidad;
    } else {
        // Agregar el producto a la lista de productos de la factura
        productosFactura.push({ id: productoId, cantidad: cantidad });
    }

    // Actualizar la lista de productos en la factura
    actualizarListaProductos(productosFactura);
});

function actualizarListaProductos(productos) {
    const listaProductos = document.getElementById('listaProductos');
    listaProductos.innerHTML = '';
    productos.forEach(producto => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.textContent = `${producto.nombre} - Cantidad: ${producto.cantidad}`;
        
        // Agregar un botón para quitar cantidad
        const btnQuitarCantidad = document.createElement('button');
        btnQuitarCantidad.textContent = 'Quitar';
        btnQuitarCantidad.classList.add('btn', 'btn-sm', 'btn-danger', 'ms-2');
        btnQuitarCantidad.addEventListener('click', function() {
            quitarCantidad(producto.id);
        });
        
        li.appendChild(btnQuitarCantidad);
        listaProductos.appendChild(li);
    });
}

function quitarCantidad(productoId) {
    // Buscar el producto en la lista de productos de la factura
    const index = productosFactura.findIndex(producto => producto.id === productoId);
    if (index !== -1) {
        // Preguntar al usuario cuánta cantidad desea quitar
        const cantidadQuitar = parseInt(prompt('Ingrese la cantidad que desea quitar:', ''));
        if (!isNaN(cantidadQuitar)) {
            // Restar la cantidad
            productosFactura[index].cantidad -= cantidadQuitar;
            // Si la cantidad es menor o igual a cero, eliminar el producto de la lista
            if (productosFactura[index].cantidad <= 0) {
                productosFactura.splice(index, 1);
            }
            // Actualizar la lista de productos en la factura
            actualizarListaProductos(productosFactura);
        } else {
            alert('Ingrese una cantidad válida.');
        }
    } else {
        alert('El producto no está en la lista de productos de la factura.');
    }
}

document.getElementById('generarFacturaBtn').addEventListener('click', function() {
    // Llamar a la API para generar el PDF de la factura
    generarPDF();
});

function generarPDF() {
    // Obtener los datos de la factura desde la API (si es necesario)

    // Generar el contenido del PDF
    const docDefinition = {
        content: [
            'Factura',
            // Aquí puedes agregar más contenido de la factura según tus necesidades
        ]
    };

    // Generar el PDF
    pdfMake.createPdf(docDefinition).open();
}
