<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">MINIMARKET FOUR</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="productos.jsp">Productos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="facturacion.jsp">Facturar</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="verFacturas.jsp">Ver Facturas</a>
                </li>
                <li class="nav-item d-flex align-items-center">
                    <button type="button" class="btn btn-danger btn-sm" onclick="cerrarSesion()">Cerrar sesión</button>
                </li>
            </ul>
        </div>
    </div>
</nav>

<script>
    function cerrarSesion() {
        window.location.href = "index.jsp";
    }
</script>
