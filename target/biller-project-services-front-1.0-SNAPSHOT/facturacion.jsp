<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="Controller.CategoriesController"%>
<%@page import="Controller.ProductsController"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Facturación</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <style>
            /* Estilos para la lista de productos */
            #listaProductos {
                list-style-type: none;
                padding: 0;
            }

            /* Estilos para cada elemento de producto */
            .producto {
                display: flex; /* Utilizamos flexbox para alinear los elementos */
                align-items: center; /* Centrar verticalmente los elementos */
                margin-bottom: 10px; /* Espacio entre cada elemento */
                padding: 10px; /* Espaciado interno */
                border: 1px solid #ccc; /* Borde para separar visualmente los elementos */
            }

            .producto strong {
                flex: 1; /* El nombre del producto ocupa el espacio restante */
            }

            .cantidad {
                margin-left: 10px; /* Margen a la izquierda para separar el nombre de la cantidad */
            }

            .btn-quitar {
                margin-left: auto; /* Mueve el botón "Quitar" al extremo derecho */
            }
        </style>
    </head>
    <body>
        <%
            ProductsController productsController = new ProductsController();
            CategoriesController categoriesController = new CategoriesController();

            JSONArray categories = categoriesController.getCategories();
            JSONArray products = productsController.getProducts();
        %>
        <div class="container mt-4">
            <h1 class="text-center mb-4">Facturación</h1>
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
                                <div class="col-md-4 mb-4">
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
                        <button id="generarFacturaBtn" class="btn btn-success mt-3">Generar Factura</button>
                    </div>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="./js/facturacion.js"></script>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/pdfmake.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/vfs_fonts.js"></script>
    </body>
</html>
