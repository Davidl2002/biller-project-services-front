<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Facturas</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link href="css/verFacturas.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <h2>Ventas Facturadas</h2>
            <form id="buscarFacturaForm">
                <div class="form-group">
                    <label for="inputFacturaId">Ingrese el número de la factura:</label>
                    <input type="number" class="form-control" id="inputFacturaId" required min="1">
                </div>
                <button type="submit" class="btn btn-primary">Buscar Factura</button>
            </form>

            <div id="facturaDetails" class="mt-4">
            </div>

            <button id="btnMostrarFactura" class="btn btn-info mt-4" style="display: none;">Mostrar Factura</button>

            <!-- Agrega un botón para ver todas las facturas -->
            <button id="btnVerTodo" class="btn btn-primary mt-4">Ver Todo</button>

            <!-- Modal para mostrar todas las facturas -->
            <div class="modal fade" id="modalTodasFacturas" tabindex="-1" aria-labelledby="modalTodasFacturasLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-scrollable modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTodasFacturasLabel">Todas las Facturas</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Contenido de las facturas -->
                            <div id="todasFacturasContainer"></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>


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
