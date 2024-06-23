async function login() {
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    try {
        const response = await fetch("http://localhost:8080/auth/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ username, password })
        });

        if (response.ok) {
            const result = await response.json();

            // Verificar si se recibió el token
            if (result.token) {
                
                const token = result.token;
                localStorage.setItem('token', token);

                // Decodificar el token JWT
                const decodedToken = parseJwt(token);
                
                if (decodedToken) {
                    // Obtener la información del usuario del token decodificado
                    const user_Id = decodedToken.user_Id;
                    const role = decodedToken.role_Id.role;

                    document.getElementById("errorDiv").style.display = "none"; // Ocultar el mensaje de error si estaba visible
                    document.getElementById("response").style.display = "block"; // Mostrar el mensaje de éxito
                    document.getElementById("response").innerText = "Inicio de sesión exitoso. Redireccionando...";

                    // Redirigir según el rol del usuario
                    switch (role) {
                        case "Vendedor":
                            window.location.href = "facturacion.jsp"; // Redirigir a la página del vendedor
                            break;
                        case "Administrador":
                            window.location.href = "productos.jsp"; // Redirigir a la página del administrador
                            break;
                        default:
                            window.location.href = "index.jsp"; // Redirigir a una página por defecto si el rol no está definido
                            break;
                    }
                } else {
                    throw new Error("No se pudo decodificar el token JWT");
                }
            } else {
                throw new Error("No se recibió el token en la respuesta");
            }
        } else {
            const errorMessage = await response.text();
            throw new Error(errorMessage);
        }
    } catch (error) {
        console.error("Error al procesar la solicitud:", error);
        document.getElementById("errorDiv").innerText = "Error al iniciar sesión: " + error.message;
        document.getElementById("errorDiv").style.display = "block"; // Mostrar el mensaje de error
        document.getElementById("response").style.display = "none"; // Ocultar el mensaje de éxito
    }
}

// Función para decodificar un token JWT (solo para fines educativos, usa una librería de JWT en producción)
function parseJwt(token) {
    try {
        const base64Url = token.split('.')[1];
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));

        return JSON.parse(jsonPayload);
    } catch (error) {
        console.error("Error al decodificar el token JWT:", error);
        return null;
    }
}
