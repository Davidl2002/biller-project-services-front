<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Registro</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="css/style.css">
  
</head>
<body>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card mt-5">
          <div class="card-body">
            <h2 class="card-title text-center">Registro</h2>
            <form onsubmit="event.preventDefault(); register();">
              <div class="form-group">
                <label for="username">Nombre de usuario</label>
                <input type="text" class="form-control" id="username" placeholder="Ingrese su nombre de usuario" required>
              </div>
              <div class="form-group">
                <label for="password">Contrase�a</label>
                <input type="password" class="form-control" id="password" placeholder="Ingrese su contrase�a" required>
              </div>
              <div class="form-group">
                <label for="firstName">Nombre</label>
                <input type="text" class="form-control" id="firstName" placeholder="Ingrese su nombre" required>
              </div>
              <div class="form-group">
                <label for="lastName">Apellido</label>
                <input type="text" class="form-control" id="lastName" placeholder="Ingrese su apellido" required>
              </div>
              <div class="form-group">
                <label for="email">Correo electr�nico</label>
                <input type="email" class="form-control" id="email" placeholder="Ingrese su correo electr�nico" required>
              </div>
              <button type="submit" class="btn btn-primary btn-block">Registrarse</button>
            </form>
            <div id="response" class="mt-3"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  <script src="js/register.js"></script>
</body>
</html>
