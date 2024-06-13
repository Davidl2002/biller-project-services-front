package Controller;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.json.JSONArray;
import org.json.JSONObject;

public class ProductsController {
    private final HttpClient httpClient;
    private static String url = "http://localhost:8080/products";
    //private static String url = "https://biller-project-services.onrender.com/products";

    public ProductsController() {
        this.httpClient = HttpClient.newHttpClient();
    }
    
    public JSONArray getProducts(){
        
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();
            
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            return new JSONArray(response.body());
        } catch (IOException ex) {
            throw new RuntimeException("No se puede encontrar ningun producto");
        } catch (InterruptedException ex) {
            throw new RuntimeException("No se puede conectar con el servidor");
        }
    }
    
    public HttpResponse<String> createProducts(String code, String name, String description, String image, int stock, double price) {
        HttpResponse<String> response = null;
        
        try {
            JSONObject data = new JSONObject();
            data.put("code", code);
            data.put("name", name);
            data.put("description", description);
            data.put("image", image);
            data.put("stock", stock);
            data.put("unitPrice", price);
            
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(data.toString()))
                    .build();
            
            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            return response;
        } catch (Exception ex) {
            return response;
        }
    }
    
    
    public HttpResponse<String> deleteUser(String id) throws Exception {
        // Construye la URI de la API con el identificador
        URI uri = URI.create(url + "?cedula=" + id);

        // Crea una solicitud DELETE
        HttpRequest request = HttpRequest.newBuilder()
                .uri(uri)
                .DELETE()
                .build();

        // Envía la solicitud y devuelve la respuesta
        return httpClient.send(request, HttpResponse.BodyHandlers.ofString());
    }
        
    public JSONObject getUserById(String cedula) throws Exception {
        // Realiza una solicitud GET para obtener todos los usuarios
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        // Obtiene la respuesta del servidor
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        // Convierte la respuesta en un JSONArray
        JSONArray jsonArray = new JSONArray(response.body());

        // Itera a través del JSONArray y encuentra el usuario con la cedula especificada
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = jsonArray.getJSONObject(i);
            if (jsonObject.getString("cedula").equals(cedula)) {
                // Retorna el objeto JSON del usuario encontrado
                return jsonObject;
            }
        }

        // Si no se encuentra el usuario, retorna null
        return null;
    }
    
     public HttpResponse<String> updateUser(String cedula, String nombre, String apellido, String direccion, String telefono) throws Exception {
        // Crea el objeto JSON con los datos a actualizar
        JSONObject data = new JSONObject();
        data.put("cedula", cedula);
        data.put("nombre", nombre);
        data.put("apellido", apellido);
        data.put("direccion", direccion);
        data.put("telefono", telefono);

        // Construye la URI
        URI uri = URI.create(url);

        // Crea una solicitud PUT para actualizar el usuario
        HttpRequest request = HttpRequest.newBuilder()
                .uri(uri)
                .header("Content-Type", "application/json")
                .PUT(HttpRequest.BodyPublishers.ofString(data.toString()))
                .build();

        // Envía la solicitud y devuelve la respuesta
        return httpClient.send(request, HttpResponse.BodyHandlers.ofString());
    }
    
     public int getResponseStatusCode(HttpResponse<String> response) {
        return response.statusCode();
    }
     
     public JSONArray getStudentsCedula(String cedula) throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url+"?cedula="+cedula))
                .GET()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        return new JSONArray(response.body());
    }
}
