<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Facturación</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
</head>
<body>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Facturación</h1>
        <div class="row">
            <div class="col-md-8">
                <form id="facturacionForm">
                    <div class="mb-3">
                        <label for="producto">Producto</label>
                        <select class="form-select" id="producto" name="producto">
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="cantidad">Cantidad</label>
                        <input type="number" class="form-control" id="cantidad" name="cantidad" min="1" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Agregar a factura</button>
                </form>
            </div>
            <div class="col-md-4">
                <h4>Productos en la factura</h4>
                <ul id="listaProductos" class="list-group">
                </ul>
                <button id="generarFacturaBtn" class="btn btn-success mt-3">Generar Factura</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="./js/facturacion.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/vfs_fonts.js"></script>
</body>
</html>
