<%@page import="Controller.IdTypesController"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="Controller.CategoriesController"%>
<%@page import="Controller.ProductsController"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="navBarAd.jsp" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Facturación</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="css/facturacion.css" rel="stylesheet">
    
    <style>
        #listaProductos {
            list-style-type: none;
            padding: 0;
        }

        .producto {
            display: flex; 
            align-items: center; 
            margin-bottom: 10px; 
            padding: 10px; 
            border: 1px solid #ccc; 
        }

        .producto strong {
            flex: 1; 
        }

        .cantidad {
            margin-left: 10px;
        }

        .btn-quitar {
            margin-left: auto; 
        }
    </style>
</head>
<body>
    <%
        ProductsController productsController = new ProductsController();
        CategoriesController categoriesController = new CategoriesController();
        IdTypesController idController = new IdTypesController();

        JSONArray categories = categoriesController.getCategories();
        JSONArray products = productsController.getProducts();
        JSONArray ids = idController.getIdTypes();
    %>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Facturación</h1>
        <div class="mb-3">
            <br>
            <input type="text" class="form-control" id="buscarProducto" placeholder="Ingrese nombre o código del producto">
        </div>
        <div class="row">
            <div class="col-md-8">
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
                                        <form class="facturacionForm" data-product-id="<%=product.getInt("productId")%>">
                                            <div class="mb-3">
                                                <input type="hidden" id="producto" name="producto" value="<%=product.getInt("productId")%>">
                                                <input type="hidden" id="name" name="name" value="<%=product.getString("name")%> (<%=product.getString("code")%>)">
                                                <input type="hidden" id="unitPrice" name="unitPrice" value="<%=product.getDouble("unitPrice")%>">
                                                <input type="hidden" class="stock" value="<%=product.getInt("stock")%>">
                                            </div>
                                            <div class="mb-3">
                                                <label for="cantidad">Cantidad</label>
                                                <input type="number" class="form-control" id="cantidad" name="cantidad" min="1" required>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Agregar a factura</button>
                                        </form>  
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
            <div class="col-md-4">
                <div id="facturaFija" class="position-fixed">
                    <h4>Productos en la factura</h4>
                    <ul id="listaProductos" class="list-group">
                        <!-- Aquí se mostrarán los productos agregados a la factura -->
                    </ul>
                    
                    <div id="subtotalPro">
                    
                    </div>
                   <div id="subtotalSuma">
                       
                   </div>
                    <button id="generarFacturaBtn" class="btn btn-success mt-3" disabled>Facturar Pedido</button>
                </div>
            </div>
        </div>
    <div class="modal fade" id="datosClienteModal" tabindex="-1" aria-labelledby="datosClienteModal" aria-hidden="true">
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="datosClienteModalLabel">Datos del Cliente</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form method="POST" id="datosClienteForm">
                <div class="mb-3">
                    <label for="tipoId" class="form-label">Tipo de ID</label>
                    <select class="form-select" id="tipoId" name="tipoId" required>
                        <option value="">Seleccionar tipo de ID...</option>
                        <% for (int i = 0; i < ids.length(); i++) {%>
                        <option value="<%= ids.getJSONObject(i).getInt("typeId")%>"><%= ids.getJSONObject(i).getString("type")%></option>
                        <% } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="dni" class="form-label">Identificación del Cliente</label>
                    <input type="text" class="form-control" id="dni" name="dni" placeholder="Cédula de identidad o RUC" required>
                </div>
                <div class="mb-3">
                    <label for="nombreCliente" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="nombreCliente" name="nombreCliente" placeholder="Ej: Juan" required>
                </div>
                <div class="mb-3">
                    <label for="apellidoCliente" class="form-label">Apellido</label>
                    <input type="text" class="form-control" id="apellidoCliente" name="apellidoCliente" placeholder="Ej: López" required>
                </div>
                <div class="mb-3">
                    <label for="emailCliente" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="emailCliente" name="emailCliente" placeholder="Ej: cliente@example.com" required>
                </div>
                <div class="mb-3">
                    <label for="direccionCliente" class="form-label">Dirección</label>
                    <input type="text" class="form-control" id="direccionCliente" name="direccionCliente" placeholder="Ingrese la dirección del cliente" required>
                </div>
                <div class="mb-3">
                    <label for="celularCliente" class="form-label">Celular</label>
                    <input type="text" class="form-control" id="celularCliente" name="celularCliente" placeholder="Ej: 0997836278" required>
                </div>
                <button type="submit" class="btn btn-primary">Generar Factura</button>
            </form>
        </div>
    </div>
</div>
</div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="./js/facturacion.js"></script>

    <script>
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

</body>
</html>
