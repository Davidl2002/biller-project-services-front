<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="Controller.ProductsController"%>
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
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="mb-0 text-white">Productos</h1>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#agregarProductoModal">Agregar Producto</button>
        </div>

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
                                <label for="nombreProducto" class="form-label">Nombre del Producto</label>
                                <input type="text" class="form-control" id="nombreProducto" name="nombreProducto" placeholder="Ingrese el nombre del producto" required>
                            </div>
                            <div class="mb-3">
                                <label for="descProducto" class="form-label">Descripción del Producto</label>
                                <input type="text" class="form-control" id="descProducto" name="descProducto" placeholder="Ingrese descripción del producto" required>
                            </div>
                            <div class="mb-3">
                                <label for="stockProducto" class="form-label">Cantidad del Producto</label>
                                <input type="number" class="form-control" id="stockProducto" name="stockProducto" placeholder="Ingrese la cantidad del producto" required>
                            </div>
                            <div class="mb-3">
                                <label for="imagenProducto" class="form-label">Imagen del Producto</label>
                                <input type="file" class="form-control" id="imagenProducto" name="imagenProducto" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Agregar</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

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
                                <label for="editNombreProducto" class="form-label">Nombre del Producto</label>
                                <input type="text" class="form-control" id="editNombreProducto" name="nombreProducto" required>
                            </div>
                            <div class="mb-3">
                                <label for="editDescProducto" class="form-label">Descripción del Producto</label>
                                <input type="text" class="form-control" id="editDescProducto" name="descProducto" required>
                            </div>
                            <div class="mb-3">
                                <label for="editStockProducto" class="form-label">Cantidad del Producto</label>
                                <input type="number" class="form-control" id="editStockProducto" name="stockProducto" required>
                            </div>
                            <div class="mb-3">
                                <label for="editImagenProducto" class="form-label">Imagen del Producto</label>
                                <input type="file" class="form-control" id="editImagenProducto" name="imagenProducto">
                            </div>
                            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row" id="productosContainer">
            <%
            ProductsController controller = new ProductsController();
            JSONArray products = controller.getProducts();
            
            for (int i = 0; i < products.length(); i++) {
                JSONObject product = products.getJSONObject(i);
            %>
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm">
                    <img src="https://drive.google.com/uc?export=view&id=1OUYas7HDUo2nB_vvDgq2jHZHBUaRjcCL" class="card-img-top" alt="Producto">
                    <div class="card-body">
                        <h5 class="card-title"><%=product.getString("name")%> (<%=product.getString("code")%>)</h5>
                        <p class="card-text"><%=product.getString("description")%></p>
                        <p class="card-text"><small class="text-muted">Precio Unitario: $<%=product.getDouble("unitPrice")%></small></p>
                        <p class="card-text"><small class="text-muted">Cantidad: <%=product.getInt("stock")%></small></p>
                        <button class="btn btn-warning" onclick="editarProducto(0)">Editar</button>
                        <button class="btn btn-danger" onclick="eliminarProducto(0)">Eliminar</button>
                    </div>
                </div>
            </div>
            <%
            }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <script>

        document.getElementById('agregarProductoForm').addEventListener('submit', function(event) {
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

        function editarProducto(id) {
            const producto = {
                id: 0,
                nombre: "Producto por Defecto",
                descripcion: "Descripción del Producto por Defecto",
                cantidad: 10
            };

            document.getElementById('editProductoId').value = producto.id;
            document.getElementById('editNombreProducto').value = producto.nombre;
            document.getElementById('editDescProducto').value = producto.descripcion;
            document.getElementById('editStockProducto').value = producto.cantidad;
            
            const editarProductoModal = new bootstrap.Modal(document.getElementById('editarProductoModal'));
            editarProductoModal.show();
        }

        document.getElementById('editarProductoForm').addEventListener('submit', function(event) {
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
</body>
</html>
