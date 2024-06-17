<%@page import="java.io.File"%>
<%@page import="java.awt.Image"%>
<%@page import="java.net.http.HttpResponse"%>
<%@page import="org.json.JSONObject"%>
<%@page import="Controller.CategoriesController"%>
<%@page import="org.json.JSONArray"%>
<%@page import="Controller.ProductsController"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link href="css/producto.css" rel="stylesheet">
        <title>Productos</title>
    </head>
    <body>
        <%
            ProductsController productsController = new ProductsController();
            CategoriesController categoriesController = new CategoriesController();

            JSONArray categories = categoriesController.getCategories();
            JSONArray products = productsController.getProducts();
        %>
        <div class="container mt-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="mb-0 text-white">Productos</h1>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#agregarProductoModal">Agregar Producto</button>
            </div>

            <div class="mb-3">
                <br>
                <input type="text" class="form-control" id="buscarProducto" placeholder="Ingrese nombre o código del producto">
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
                            <form method="POST" id="agregarProductoForm" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <label for="codigoProducto" class="form-label">Código del Producto</label>
                                    <input type="text" class="form-control" id="codigoProducto" name="codigoProducto" placeholder="Ingrese el código del producto" required maxlength="6" pattern="[A-Za-z0-9]{6}" oninput="this.value = this.value.toUpperCase()">
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
                                    <input type="number" class="form-control" id="precioProducto" name="precioProducto" placeholder="Ingrese el precio del producto" required min="0.01" step="0.01">
                                </div>
                                <div class="mb-3">
                                    <label for="stockProducto" class="form-label">Cantidad del Producto</label>
                                    <input type="number" class="form-control" id="stockProducto" name="stockProducto" placeholder="Ingrese la cantidad del producto" required min="1" max="200">
                                </div>
                                <div class="mb-3">
                                    <label for="imagenProducto" class="form-label">Imagen del Producto</label>
                                    <input type="file" class="form-control" id="imagenProducto" name="imagenProducto" required>
                                </div>
                                <div class="mb-3">
                                    <label for="categoriaProducto" class="form-label">Categoría del Producto</label>
                                    <select class="form-select" id="categoriaProducto" name="categoriaProducto" required>
                                        <option value="">Seleccionar categoría...</option>
                                        <% for (int i = 0; i < categories.length(); i++) {%>
                                        <option value="<%= categories.getJSONObject(i).getInt("categoryId")%>"><%= categories.getJSONObject(i).getString("name")%></option>
                                        <% } %>
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
                                    <input type="text" class="form-control" id="editCodigoProducto" name="codigoProducto" readonly>
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
                                    <input type="number" class="form-control" id="editPrecioProducto" name="precioProducto" required min="0.01" step="0.01">
                                </div>
                                <div class="mb-3">
                                    <label for="editStockProducto" class="form-label">Cantidad del Producto</label>
                                    <input type="number" class="form-control" id="editStockProducto" name="stockProducto" required min="1" max="200">
                                </div>
                                <div class="mb-3">
                                    <label for="editImagenProducto" class="form-label">Imagen del Producto</label>
                                    <input type="file" class="form-control" id="editImagenProducto" name="imagenProducto">
                                </div>
                                <div class="mb-3">
                                    <label for="editCategoriaProducto" class="form-label">Categoría del Producto</label>
                                    <select class="form-select" id="editCategoriaProducto" name="categoriaProducto" required>
                                        <option value="">Seleccionar categoría...</option>
                                        <% for (int i = 0; i < categories.length(); i++) {%>
                                        <option value="<%= categories.getJSONObject(i).getInt("categoryId")%>"><%= categories.getJSONObject(i).getString("name")%></option>
                                        <% } %>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <div id="categoriasContainer" class="btn-group" role="group" aria-label="Categorías">
                    <%
                        for (int i = 0; i < categories.length(); i++) {
                            JSONObject category = categories.getJSONObject(i);
                    %>
                    <!--<button type="button" class="btn btn-secondary" data-category-id="<%=category.getInt("categoryId")%>"><%=category.getString("name")%></button>-->
                    <%
                        }
                    %>
                </div>
            </div>

            <div id="productosContainer">
                <%
                    for (int i = 0; i < categories.length(); i++) {
                        JSONObject category = categories.getJSONObject(i);
                %>
                <div class="category-section" data-category-id="<%=category.getInt("categoryId")%>">
                    <h3><%=category.getString("name")%></h3>
                    <div class="row">
                        <%
                            for (int j = 0; j < products.length(); j++) {
                                JSONObject product = products.getJSONObject(j);
                                if (product.getJSONObject("category").getInt("categoryId") == category.getInt("categoryId")) {
                                    String dataImage = "data:image/jpeg;base64," + product.getString("image");
                        %>
                        <div class="col-md-4 mb-4 producto" data-product-name="<%=product.getString("name").toLowerCase()%>" data-product-code="<%=product.getString("code").toLowerCase()%>">
                            <div class="card shadow-sm">
                                <img src="<%=dataImage%>" class="card-img-top" alt="<%=product.getString("name")%>">
                                <div class="card-body">
                                    <h5 class="card-title"><%=product.getString("name")%> (<%=product.getString("code")%>)</h5>
                                    <p class="card-text"><%=product.getString("description")%></p>
                                    <p class="card-text"><small class="text-muted">Precio: $<%=product.getDouble("unitPrice")%></small></p>
                                    <p class="card-text"><small class="text-muted">Unidades Disponibles: <%=product.getInt("stock")%></small></p>
                                    <button class="btn btn-warning" onclick="editarProducto(<%=product.getInt("productId")%>)">Editar</button>
                                    <button class="btn btn-danger" onclick="eliminarProducto(<%=product.getInt("productId")%>)">Eliminar</button>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script>
                                        function enviarFormulario() {
                                            // Obtener referencia al formulario y sus elementos
                                            const form = document.getElementById('agregarProductoForm');
                                            const formData = new FormData(form);
                                            // Obtener el archivo seleccionado (imagen) y convertirlo a base64
                                            const imagenProducto = formData.get('imagenProducto');
                                            const reader = new FileReader();
                                            // Cuando se carga el archivo, convertirlo a base64
                                            reader.onload = function (event) {
                                                const base64Image = event.target.result.split(',')[1];
                                                // Construir objeto con los datos del formulario y la imagen en base64
                                                const data = {
                                                    code: formData.get('codigoProducto'),
                                                    name: formData.get('nombreProducto'),
                                                    description: formData.get('descripcionProducto'),
                                                    unitPrice: formData.get('precioProducto'),
                                                    stock: formData.get('stockProducto'),
                                                    image: base64Image,
                                                    categoryId: formData.get('categoriaProducto')
                                                };
                                                // Enviar los datos al backend
                                                if (data.code === formData.get('codigoProducto')) {
                                                                Swal.fire({
                                                                    icon: 'error',
                                                                    title: 'Error',
                                                                    text: 'El código del producto ya existe. Por favor, elija otro código.',
                                                                    confirmButtonText: 'Aceptar'
                                                                });
                                                            }
                                                fetch('http://localhost:8080/products', {
                                                    method: 'POST',
                                                    headers: {
                                                        'Content-Type': 'application/json'
                                                    },
                                                    body: JSON.stringify(data)
                                                })
                                                
                                                        .then(response => {
                                                            if (!response.ok) {
                                                                throw new Error('Error al añadir el producto');
                                                            }
                                                            return response.text();
                                                        })
                                                        
                                                        .then(data => {
                                                            console.log('Respuesta del servidor:', data);
                                                            Swal.fire({
                                                                icon: 'success',
                                                                title: 'Producto agregado exitosamente',
                                                                showConfirmButton: false,
                                                                timer: 1500
                                                            });
                                                            //notyf.success('Producto agregado exitosamente');
                                                            // Recargar la página después de enviar el formulario
                                                            window.location.reload();
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
                                                            //toastr.error('Hubo un error al añadir el producto');
                                                            // Manejar errores de la solicitud
                                                        });

                                            };
                                            // Leer el archivo como base64
                                            reader.readAsDataURL(imagenProducto);
                                        }

                                        // Agregar evento de escucha para enviar el formulario
                                        document.getElementById('agregarProductoForm').addEventListener('submit', function (event) {
                                            event.preventDefault(); // Prevenir el envío normal del formulario
                                            enviarFormulario(); // Llamar a la función para enviar el formulario
                                        });
                                        function editarProducto(id) {
                                            // Obtener los datos del producto desde el servidor
                                            console.log('id: ' + id)
                                            fetch('http://localhost:8080/products/' + id)

                                                    .then(response => response.json())
                                                    .then(data => {

                                                        document.getElementById('editProductoId').value = data.productId;
                                                        document.getElementById('editCodigoProducto').value = data.code;
                                                        document.getElementById('editNombreProducto').value = data.name;
                                                        document.getElementById('editDescripcionProducto').value = data.description;
                                                        document.getElementById('editPrecioProducto').value = data.unitPrice;
                                                        document.getElementById('editStockProducto').value = data.stock;
                                                        document.getElementById('editCategoriaProducto').value = data.category.categoryId;
                                                        // Abrir el modal de edición
                                                        var editarModal = new bootstrap.Modal(document.getElementById('editarProductoModal'));
                                                        editarModal.show();
                                                    })
                                                    .catch(error => console.error('Error al obtener los datos del producto:', error));
                                        }

                                        function enviarProductoEditado() {
                                            // Obtener referencia al formulario y sus elementos
                                            const form = document.getElementById('editarProductoForm');
                                            const formData = new FormData(form);
                                            var id = formData.get('id');
                                            console.log('Formulario de edición:', formData);
                                            console.log(id);
                                            // Obtener el archivo seleccionado (imagen)
                                            const imagenProducto = formData.get('imagenProducto');
                                            if (imagenProducto && imagenProducto.size > 0) {
                                                const reader = new FileReader();
                                                // Cuando se carga el archivo, convertirlo a base64
                                                reader.onload = function (event) {
                                                    const base64Image = event.target.result.split(',')[1];
                                                    // Construir objeto con los datos del formulario y la imagen en base64
                                                    const data = {
                                                        code: formData.get('codigoProducto'),
                                                        name: formData.get('nombreProducto'),
                                                        description: formData.get('descripcionProducto'),
                                                        unitPrice: formData.get('precioProducto'),
                                                        stock: formData.get('stockProducto'),
                                                        image: base64Image,
                                                        categoryId: formData.get('categoriaProducto')
                                                    };
                                                    enviarDatosAlBackend(id, data);
                                                };
                                                // Leer el archivo como base64
                                                reader.readAsDataURL(imagenProducto);
                                            } else {
                                                // Construir objeto con los datos del formulario sin la imagen
                                                const data = {
                                                    code: formData.get('codigoProducto'),
                                                    name: formData.get('nombreProducto'),
                                                    description: formData.get('descripcionProducto'),
                                                    unitPrice: formData.get('precioProducto'),
                                                    stock: formData.get('stockProducto'),
                                                    image: null, // Imagen es null
                                                    categoryId: formData.get('categoriaProducto')
                                                };
                                                enviarDatosAlBackend(id, data);
                                            }
                                        }

                                        function enviarDatosAlBackend(id, data) {
                                            console.log('Datos enviados al backend:', data);
                                            // Enviar los datos al backend
                                            fetch('http://localhost:8080/products/' + id, {
                                                method: 'PATCH',
                                                headers: {
                                                    'Content-Type': 'application/json'
                                                },
                                                body: JSON.stringify(data)
                                            })
                                                    .then(response => {
                                                        console.log('Respuesta del servidor:', response);
                                                        if (!response.ok) {
                                                            throw new Error('Error al modificar el producto');
                                                        }
                                                        return response.text();
                                                    })
                                                    .then(data => {
                                                        console.log('Respuesta del servidor:', data);
                                                        Swal.fire({
                                                            icon: 'success',
                                                            title: 'Producto editado exitosamente',
                                                            showConfirmButton: false,
                                                            timer: 1500
                                                        });
                                                        //toastr.success('Producto editado exitosamente');
                                                        // Recargar la página después de enviar el formulario
                                                        window.location.reload();
                                                    })
                                                    .catch(error => {
                                                        console.error('Error:', error);
                                                        Swal.fire({
                                                            icon: 'error',
                                                            title: 'Error al editar el producto',
                                                            text: 'Hubo un error al editar el producto, por favor intenta de nuevo.'
                                                        });
                                                        //toastr.error('Hubo un error al modificar el producto');
                                                        // Manejar errores de la solicitud
                                                    });
                                        }

                                        // Agregar evento de escucha para enviar el formulario
                                        document.getElementById('editarProductoForm').addEventListener('submit', function (event) {
                                            event.preventDefault(); // Prevenir el envío normal del formulario
                                            enviarProductoEditado(); // Llamar a la función para enviar el formulario
                                        });
                                        // Función para eliminar producto
                                        function eliminarProducto(id) {
                                            Swal.fire({
                                                title: '¿Está seguro de que desea eliminar este producto?',
                                                text: "¡No podrás revertir esto!",
                                                icon: 'warning',
                                                showCancelButton: true,
                                                confirmButtonColor: '#3085d6',
                                                cancelButtonColor: '#d33',
                                                confirmButtonText: 'Sí, eliminarlo',
                                                cancelButtonText: 'Cancelar'
                                            }).then((result) => {
                                                if (result.isConfirmed) {
                                                    fetch('http://localhost:8080/products/' + id, {
                                                        method: 'DELETE'
                                                    })
                                                            .then(response => response.text())
                                                            .then(data => {
                                                                if (data === 'El producto fue eliminado exitosamente') {
                                                                    Swal.fire({
                                                                        icon: 'success',
                                                                        title: 'Producto eliminado exitosamente',
                                                                        showConfirmButton: false,
                                                                        timer: 1500
                                                                    });
                                                                    //toastr.success('Producto eliminado exitosamente');
                                                                    location.reload();
                                                                } else {
                                                                    //toastr.error('No se pudo eliminar el producto');
                                                                    Swal.fire({
                                                                        icon: 'error',
                                                                        title: 'Error al eliminar el producto',
                                                                        text: 'No se pudo eliminar el producto, por favor intenta de nuevo.'
                                                                    });
                                                                }
                                                            })
                                                            .catch(error => {
                                                                console.error('Error al eliminar el producto:', error);
                                                                Swal.fire({
                                                                    icon: 'error',
                                                                    title: 'Error al eliminar el producto',
                                                                    text: 'Hubo un error al eliminar el producto, por favor intenta de nuevo.'
                                                                });
                                                                //toastr.error('Hubo un error al eliminar el producto');
                                                            });
                                                }
                                            });
                                        }

                                        document.addEventListener('DOMContentLoaded', function () {
                                            const buscarInput = document.getElementById('buscarProducto');

                                            buscarInput.addEventListener('input', function () {
                                                const valor = buscarInput.value.trim().toLowerCase();

                                                const productos = document.querySelectorAll('.producto');

                                                productos.forEach(producto => {
                                                    const nombre = producto.getAttribute('data-product-name').toLowerCase();
                                                    const codigo = producto.getAttribute('data-product-code').toLowerCase();

                                                    if (nombre.includes(valor) || codigo.includes(valor)) {
                                                        producto.style.display = 'block';
                                                    } else {
                                                        producto.style.display = 'none';
                                                    }
                                                });
                                            });
                                        });


        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </body>
</html>

