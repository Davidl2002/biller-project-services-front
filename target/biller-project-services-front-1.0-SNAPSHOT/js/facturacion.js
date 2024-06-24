let productosFactura = [];
let subtotal = 0;
let totalIva = 0;

const subtotalProElement = document.getElementById('subtotalPro');
const subtotalSumaElement = document.getElementById('subtotalSuma');
const generarFacturaBtn = document.getElementById('generarFacturaBtn');

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

            // Obtener el stock disponible del producto
            const stockDisponible = parseInt(form.querySelector('.stock').value);

            // Verificar la cantidad total ya agregada a la factura para este producto
            const productoExistente = productosFactura.find(producto => producto.id === productoId);
            const cantidadExistente = productoExistente ? productoExistente.cantidad : 0;
            const cantidadTotal = cantidadExistente + cantidad;

            // Validar que la cantidad total no supere el stock
            if (cantidadTotal > stockDisponible) {
                Swal.fire({
                    icon: 'error',
                    title: 'Cantidad excedida',
                    text: `La cantidad total (${cantidadTotal}) supera el stock disponible (${stockDisponible}).`
                });
                return;
            }

            // Si la cantidad es válida, agregar o actualizar el producto en la factura
            if (productoExistente) {
                productoExistente.cantidad = cantidadTotal; // Actualizar la cantidad existente
            } else {
                productosFactura.push({ id: productoId, nombre: productoNombre, cantidad: cantidad, precio: precio });
            }

            actualizarListaProductos(productosFactura);
            actualizarBotonFacturar();
        });
    });

    // Manejador para bloquear/desbloquear campos según el tipo de ID seleccionado
    document.getElementById('tipoId').addEventListener('change', function(event) {
        const tipoId = event.target.value;
        const esConsumidorFinal = tipoId === '3'; // Asume que '3' es el valor para "Consumidor Final"
        const camposCliente = ['dni', 'nombreCliente', 'apellidoCliente', 'emailCliente', 'direccionCliente', 'celularCliente'];

        camposCliente.forEach(campoId => {
            const campo = document.getElementById(campoId);
            campo.disabled = esConsumidorFinal;
            campo.required = !esConsumidorFinal;
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

    totalIva = subtotal * 1.15; // Subtotal + 15% IVA
    let ivaValor = subtotal * 0.15;

    subtotalProElement.innerHTML = ''; // Limpiar contenido anterior
    subtotalSumaElement.innerHTML = ''; // Limpiar contenido anterior

    const subtotalGeneral = document.createElement('h4');
    subtotalGeneral.textContent = `Subtotal: $${subtotal.toFixed(2)}`;
    subtotalProElement.appendChild(subtotalGeneral);

    const iva = document.createElement('h4');
    iva.textContent = `IVA (15%): $${ivaValor.toFixed(2)}`;
    subtotalProElement.appendChild(iva);

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
            actualizarBotonFacturar();
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Cantidad inválida',
                text: 'Ingrese una cantidad válida mayor a 0.'
            });
        }
    } else {
        Swal.fire({
            icon: 'error',
            title: 'Producto no encontrado',
            text: 'El producto no está en la lista de productos de la factura.'
        });
    }
}

function actualizarBotonFacturar() {
    if (productosFactura.length > 0) {
        generarFacturaBtn.disabled = false;
    } else {
        generarFacturaBtn.disabled = true;
    }
}

document.getElementById('generarFacturaBtn').addEventListener('click', function(event) {
    event.preventDefault(); // Evita que el formulario se envíe automáticamente
    const modal = new bootstrap.Modal(document.getElementById('datosClienteModal'));
    modal.show();
});

document.getElementById('datosClienteForm').addEventListener('submit', function(event) {
    event.preventDefault();
    generarFactura();
});

function validarCedula(cedula) {
   
    if (cedula.length !== 10) {
        return false;
    }
    
    if (!(/^\d+$/.test(cedula))) {
        return false;
    }

    let digitos = cedula.split('').map(digito => parseInt(digito));

    let verificador = digitos.pop();
    let suma = 0;

    for (let i = 0; i < digitos.length; i++) {
        let digito = digitos[i];
        if (i % 2 === 0) {
            digito *= 2;
            if (digito > 9) {
                digito -= 9;
            }
        }
        suma += digito;
    }

    let residuo = suma % 10;
    let resultado = residuo === 0 ? 0 : 10 - residuo;

    return resultado === verificador;
}

function generarFactura() {
    const tipoId = parseInt(document.getElementById('tipoId').value);
    const dni = document.getElementById('dni').value.trim();

    let esValidoCliente = false;

    if (tipoId === 1) { 
        esValidoCliente = validarCedula(dni);
    } else if (tipoId === 2) { 
        if (dni.length !== 13 || !(/^\d+$/.test(dni))) {
            Swal.fire({
                icon: 'error',
                title: 'RUC inválido',
                text: 'El RUC debe tener exactamente 13 dígitos numéricos.'
            });
            return;
        }
        esValidoCliente = true;
    } else {
        esValidoCliente = true;
    }

    if (!esValidoCliente) {
        Swal.fire({
            icon: 'error',
            title: 'Documento inválido',
            text: 'Ingrese un número de cédula o RUC válido.'
        });
        return;
    }

    if (productosFactura.length === 0) {
        Swal.fire({
            icon: 'error',
            title: 'Factura vacía',
            text: 'Agregue al menos un producto a la factura.'
        });
        return;
    }

    const detalles = productosFactura.map(producto => ({
        product: parseInt(producto.id),
        quantity: producto.cantidad
    }));

    let customerData = {};
    if (tipoId === 3) { 
        customerData = {
            customerId: 0
        };
    } else {
        customerData = {
            idTypeId: tipoId,
            customerDni: dni,
            firstName: document.getElementById('nombreCliente').value,
            lastName: document.getElementById('apellidoCliente').value,
            email: document.getElementById('emailCliente').value,
            address: document.getElementById('direccionCliente').value,
            phoneNumber: document.getElementById('celularCliente').value
        };
    }

    const factura = {
        total: totalIva,
        subtotal: subtotal,
        customer: customerData,
        detalles: detalles
    };

    enviarFacturaAPI(factura);
}



function enviarFacturaAPI(factura) {
    const url = 'http://localhost:8080/api/bills';
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
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
            Swal.fire({
                icon: 'success',
                title: 'Factura creada',
                text: 'Factura creada exitosamente'
            }).then(() => {
                window.location.reload();
            });
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Hubo un error al crear la factura'
            });
        });
}