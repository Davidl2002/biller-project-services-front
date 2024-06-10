document.addEventListener('DOMContentLoaded', function() {
    cargarProductos();
});

let productosFactura = []; 
function cargarProductos() {
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
    const cantidad = parseInt(formData.get('cantidad')); 

    const productoExistente = productosFactura.find(producto => producto.id === productoId);
    if (productoExistente) {
        productoExistente.cantidad += cantidad;
    } else {
        productosFactura.push({ id: productoId, cantidad: cantidad });
    }

    actualizarListaProductos(productosFactura);
});

function actualizarListaProductos(productos) {
    const listaProductos = document.getElementById('listaProductos');
    listaProductos.innerHTML = '';
    productos.forEach(producto => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.textContent = `${producto.nombre} - Cantidad: ${producto.cantidad}`;
        
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
    const index = productosFactura.findIndex(producto => producto.id === productoId);
    if (index !== -1) {
        const cantidadQuitar = parseInt(prompt('Ingrese la cantidad que desea quitar:', ''));
        if (!isNaN(cantidadQuitar)) {
            productosFactura[index].cantidad -= cantidadQuitar;
            if (productosFactura[index].cantidad <= 0) {
                productosFactura.splice(index, 1);
            }
            actualizarListaProductos(productosFactura);
        } else {
            alert('Ingrese una cantidad válida.');
        }
    } else {
        alert('El producto no está en la lista de productos de la factura.');
    }
}

document.getElementById('generarFacturaBtn').addEventListener('click', function() {
    generarPDF();
});

function generarPDF() {

    const docDefinition = {
        content: [
            'Factura',
            
        ]
    };

    
    pdfMake.createPdf(docDefinition).open();
}
