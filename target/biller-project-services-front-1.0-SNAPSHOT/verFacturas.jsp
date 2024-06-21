<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="navBar.jsp" %>
<html>
<head>
    <title>Buscar Factura por ID</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="css/verFacturas.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Buscar Factura por ID</h2>
        <form id="buscarFacturaForm">
            <div class="form-group">
                <label for="inputFacturaId">ID de la Factura:</label>
                <input type="number" class="form-control" id="inputFacturaId" required min="1">
            </div>
            <button type="submit" class="btn btn-primary">Buscar Factura</button>
        </form>

        <div id="facturaDetails" class="mt-4">
        </div>

        <button id="btnMostrarFactura" class="btn btn-info mt-4" style="display: none;">Mostrar Factura</button>

        <!-- Modal para mostrar la factura -->
        <div class="modal fade" id="facturaModal" tabindex="-1" aria-labelledby="facturaModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="facturaModalLabel">Factura Detalles</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="facturaPDF"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button id="btnGenerarPDF" class="btn btn-success">Generar PDF</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.2/js/bootstrap.bundle.min.js"></script>
    <script src="js/verFacturas.js"></script>
</body>
</html>