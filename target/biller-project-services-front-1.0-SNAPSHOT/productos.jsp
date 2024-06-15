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
                    <button type="button" class="btn btn-secondary" data-category-id="<%=category.getInt("categoryId")%>"><%=category.getString("name")%></button>
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
                                    String dataImage = "data:image/jpeg;base64," +product.getString("image");
                        %>
                        <div class="col-md-4 mb-4">
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
        reader.onload = function(event) {
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
                // Recargar la página después de enviar el formulario
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                // Manejar errores de la solicitud
            });
        };

        // Leer el archivo como base64
        reader.readAsDataURL(imagenProducto);
    }

    // Agregar evento de escucha para enviar el formulario
    document.getElementById('agregarProductoForm').addEventListener('submit', function(event) {
        event.preventDefault(); // Prevenir el envío normal del formulario
        enviarFormulario(); // Llamar a la función para enviar el formulario
    });

    function editarProducto(id) {
            // Obtener los datos del producto desde el servidor
        console.log('id: ' +id)
        fetch('http://localhost:8080/products/'+id)
            
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
            console.log(id);

            // Obtener el archivo seleccionado (imagen)
            const imagenProducto = formData.get('imagenProducto');

            if (imagenProducto && imagenProducto.size > 0) {
                const reader = new FileReader();

                // Cuando se carga el archivo, convertirlo a base64
                reader.onload = function(event) {
                    const base64Image = event.target.result.split(',')[1];
                    // Construir objeto con los datos del formulario y la imagen en base64
                    const data = {
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
            // Enviar los datos al backend
            fetch('http://localhost:8080/products/' +id, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error al modificar el producto');
                }
                return response.text();
            })
            .then(data => {
                console.log('Respuesta del servidor:', data);
                // Recargar la página después de enviar el formulario
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                // Manejar errores de la solicitud
            });
        }

        // Agregar evento de escucha para enviar el formulario
        document.getElementById('editarProductoForm').addEventListener('submit', function(event) {
            event.preventDefault(); // Prevenir el envío normal del formulario
            enviarProductoEditado(); // Llamar a la función para enviar el formulario
        });

        // Función para eliminar producto
        function eliminarProducto(id) {
            if (confirm('¿Está seguro de que desea eliminar este producto?')) {
                // Implementa la lógica para eliminar el producto mediante una solicitud fetch
                fetch('http://localhost:8080/products/'+id, {
                    method: 'DELETE'
                })
                .then(response => response.text())
                .then(data => {
                    if (data==='El producto fue eliminado exitosamente') {
                        location.reload(); // Recargar la página después de eliminar el producto
                    } else {
                        alert('No se pudo eliminar el producto');
                    }
                })
                .catch(error => console.error('Error al eliminar el producto:', error));
            }
        }
        </script>
    </body>
</html>

