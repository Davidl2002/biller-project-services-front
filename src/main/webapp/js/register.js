async function register() {
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;
    const firstName = document.getElementById("firstName").value;
    const lastName = document.getElementById("lastName").value;
    const email = document.getElementById("email").value;

    try {
        const response = await fetch("http://localhost:8085/auth/register", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ username, password, firstName, lastName, email })
        });

        if (!response.ok) {
            let errorMessage = 'Error en el registro.';
            if (response.status === 400) {
                errorMessage = 'Datos inválidos. Por favor, revisa la información proporcionada.';
            } else if (response.status === 403) {
                errorMessage = 'El nombre de usuario ya existe.';
            } else if (response.status === 409) {
                errorMessage = 'El nombre de usuario o correo electrónico ya existe.';
            } else if (response.status === 500) {
                errorMessage = 'Error interno del servidor. Por favor, inténtalo de nuevo más tarde.';
            }
            document.getElementById("response").innerText = errorMessage;
        } else {
            const result = await response.json();
            document.getElementById("response").innerText = "Registro exitoso. Inicie de sesión...";
            setTimeout(() => {
                window.location.href = "index.jsp";
            }, 1000); // Redirigir después de 2 segundos
        }
    } catch (error) {
        console.error('Error en la solicitud:', error);
        document.getElementById("response").innerText = 'Error de red. Por favor, inténtalo de nuevo más tarde.';
    }
}
