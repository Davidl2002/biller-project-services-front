function logout() {
    const token = localStorage.getItem('token');

    if (!token) {
        console.error('El token JWT está vacío o no está definido.');
        return;
    }

    fetch("https://biller-project-services.onrender.com/auth/logout", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`
        }
    }).then(response => {
        if (response.ok) {
            localStorage.removeItem('token');
            window.location.href = 'index.jsp';
        } else {
            console.error('Error al cerrar sesión');
            alert('Error al cerrar sesión. Por favor, inténtalo de nuevo.');
        }
    }).catch(error => {
        console.error('Error en la solicitud de cierre de sesión:', error);
        alert('Error de red. Por favor, inténtalo de nuevo más tarde.');
    });
}
