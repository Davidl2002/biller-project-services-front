<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link href="css/producto.css" rel="stylesheet">
        <title>Productos</title>
    </head>
    <body>
        <div class="container mt-4">
            <div class="row">
                <div class="col-12 d-flex justify-content-end">
                    <button class="btn btn-danger mt-3 mr-3" onclick="logout()">Cerrar sesión</button>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="mb-0 text-white">Productos</h1>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#agregarProductoModal">Agregar Producto</button>
            </div>

            <!-- Modal Agregar Producto -->
            <div class="modal fade" id="agregarProductoModal" tabindex="-1" aria-labelledby="agregarProductoModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="agregarProductoModalLabel">Agregar Producto</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="agregarProductoForm">
                                <div class="mb-3">
                                    <label for="codigoProducto" class="form-label">Código del Producto</label>
                                    <input type="text" class="form-control" id="codigoProducto" name="codigoProducto" placeholder="Ingrese el código del producto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="nombreProducto" class="form-label">Nombre del Producto</label>
                                    <input type="text" class="form-control" id="nombreProducto" name="nombreProducto" placeholder="Ingrese el nombre del producto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="descripcionProducto" class="form-label">Descripción del Producto</label>
                                    <input type="text" class="form-control" id="descripcionProducto" name="descripcionProducto" placeholder="Ingrese la descripción del producto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="precioProducto" class="form-label">Precio del Producto</label>
                                    <input type="number" class="form-control" id="precioProducto" name="precioProducto" placeholder="Ingrese el precio del producto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="stockProducto" class="form-label">Cantidad del Producto</label>
                                    <input type="number" class="form-control" id="stockProducto" name="stockProducto" placeholder="Ingrese la cantidad del producto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="imagenProducto" class="form-label">Imagen del Producto</label>
                                    <input type="file" class="form-control" id="imagenProducto" name="imagenProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="categoriaProducto" class="form-label">Categoría del Producto</label>
                                    <select class="form-select" id="categoriaProducto" name="categoriaProducto" required>
                                        <option value="">Seleccionar categoría...</option>
                                        <option value="1">Categoría A</option>
                                        <option value="2">Categoría B</option>
                                        <option value="3">Categoría C</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Agregar</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Editar Producto -->
            <div class="modal fade" id="editarProductoModal" tabindex="-1" aria-labelledby="editarProductoModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editarProductoModalLabel">Editar Producto</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="editarProductoForm">
                                <input type="hidden" id="editProductoId" name="id">
                                <div class="mb-3">
                                    <label for="editCodigoProducto" class="form-label">Código del Producto</label>
                                    <input type="text" class="form-control" id="editCodigoProducto" name="codigoProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editNombreProducto" class="form-label">Nombre del Producto</label>
                                    <input type="text" class="form-control" id="editNombreProducto" name="nombreProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editDescripcionProducto" class="form-label">Descripción del Producto</label>
                                    <input type="text" class="form-control" id="editDescripcionProducto" name="descripcionProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editPrecioProducto" class="form-label">Precio del Producto</label>
                                    <input type="number" class="form-control" id="editPrecioProducto" name="precioProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editStockProducto" class="form-label">Cantidad del Producto</label>
                                    <input type="number" class="form-control" id="editStockProducto" name="stockProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editImagenProducto" class="form-label">Imagen del Producto</label>
                                    <input type="file" class="form-control" id="editImagenProducto" name="imagenProducto">
                                </div>
                                <div class="mb-3">
                                    <label for="editCategoriaProducto" class="form-label">Categoría del Producto</label>
                                    <select class="form-select" id="editCategoriaProducto" name="categoriaProducto" required>
                                        <option value="">Seleccionar categoría...</option>
                                        <option value="1">Categoría A</option>
                                        <option value="2">Categoría B</option>
                                        <option value="3">Categoría C</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Botones de Categorías -->
            <div class="mb-3">
                <h3>Categorías</h3>
                <div id="categoriasContainer" class="btn-group" role="group" aria-label="Categorías">
                    <button type="button" class="btn btn-secondary" onclick="cargarProductosPorCategoria(1)">Categoría A</button>
                    <button type="button" class="btn btn-secondary" onclick="cargarProductosPorCategoria(2)">Categoría B</button>
                    <button type="button" class="btn btn-secondary" onclick="cargarProductosPorCategoria(3)">Categoría C</button>
                </div>
            </div>

            <!-- Contenedor de Productos -->
            <div class="row" id="productosContainer">
                <!-- Productos se cargarán dinámicamente -->
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            // Cargar categorías y botones de categorías
                            fetch('/api/categorias')
                                    .then(response => response.json())
                                    .then(data => {
                                        const categoriasContainer = document.getElementById('categoriasContainer');
                                        data.forEach(categoria => {
                                            const botonCategoria = `
                                <button type="button" class="btn btn-secondary" onclick="cargarProductosPorCategoria(${categoria.categoryId})">${categoria.name}</button>
                            `;
                                            categoriasContainer.insertAdjacentHTML('beforeend', botonCategoria);
                                        });
                                    })
                                    .catch(error => console.error('Error al cargar las categorías:', error));

                            // Cargar productos por defecto de la primera categoría al cargar la página
                            cargarProductosPorCategoria(1);
                        });

                        // Función para cargar productos por categoría
                        function cargarProductosPorCategoria(categoryId) {
                            cargarProductosPorCategoria(1);
                            fetch(`/api/productos/categoria/${categoryId}`)
                                    .then(response => response.json())
                                    .then(data => {
                                        const productosContainer = document.getElementById('productosContainer');
                                        productosContainer.innerHTML = '';
                                        data.forEach(producto => {
                                            const productoCard = `
                                <div                                 class="col-md-4 mb-4">
                                    <div class="card shadow-sm">
                                        <img src="${producto.imagen}" class="card-img-top" alt="${producto.nombre}">
                                        <div class="card-body">
                                            <h5 class="card-title">${producto.nombre}</h5>
                                            <p class="card-text">${producto.descripcion}</p>
                                            <p class="card-text"><small class="text-muted">Precio: ${producto.precio}</small></p>
                                            <p class="card-text"><small class="text-muted">Cantidad: ${producto.cantidad}</small></p>
                                            <button class="btn btn-warning" onclick="editarProducto(${producto.id})">Editar</button>
                                            <button class="btn btn-danger" onclick="eliminarProducto(${producto.id})">Eliminar</button>
                                        </div>
                                    </div>
                                </div>
                            `;
                                            productosContainer.insertAdjacentHTML('beforeend', productoCard);
                                        });
                                    })
                                    .catch(error => console.error('Error al cargar los productos por categoría:', error));
                        }

                        // Función para agregar un nuevo producto
                        document.getElementById('agregarProductoForm').addEventListener('submit', function (event) {
                            event.preventDefault();
                            const formData = new FormData(this);

                            fetch('/api/productos', {
                                method: 'POST',
                                body: formData
                            })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            location.reload();
                                        } else {
                                            alert('Error al agregar el producto');
                                        }
                                    })
                                    .catch(error => console.error('Error al agregar el producto:', error));
                        });

                        // Función para editar un producto
                        function editarProducto(id) {
                            fetch(`/api/productos/${id}`)
                                    .then(response => response.json())
                                    .then(producto => {
                                        document.getElementById('editProductoId').value = producto.id;
                                        document.getElementById('editCodigoProducto').value = producto.codigo;
                                        document.getElementById('editNombreProducto').value = producto.nombre;
                                        document.getElementById('editDescripcionProducto').value = producto.descripcion;
                                        document.getElementById('editPrecioProducto').value = producto.precio;
                                        document.getElementById('editStockProducto').value = producto.cantidad;
                                        document.getElementById('editCategoriaProducto').value = producto.categoriaId;

                                        const editarProductoModal = new bootstrap.Modal(document.getElementById('editarProductoModal'));
                                        editarProductoModal.show();
                                    })
                                    .catch(error => console.error('Error al cargar el producto para editar:', error));
                        }

                        // Función para enviar la edición de un producto
                        document.getElementById('editarProductoForm').addEventListener('submit', function (event) {
                            event.preventDefault();
                            const formData = new FormData(this);
                            const id = document.getElementById('editProductoId').value;

                            fetch(`/api/productos/${id}`, {
                                method: 'PUT',
                                body: formData
                            })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            location.reload();
                                        } else {
                                            alert('Error al actualizar el producto');
                                        }
                                    })
                                    .catch(error => console.error('Error al actualizar el producto:', error));
                        });

                        // Función para eliminar un producto
                        function eliminarProducto(id) {
                            if (confirm('¿Está seguro de que desea eliminar este producto?')) {
                                fetch(`/api/productos/${id}`, {
                                    method: 'DELETE'
                                })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                location.reload();
                                            } else {
                                                alert('Error al eliminar el producto');
                                            }
                                        })
                                        .catch(error => console.error('Error al eliminar el producto:', error));
                            }
                        }
        </script>
        <script src="./js/logout.js"></script>
    </body>
</html>

