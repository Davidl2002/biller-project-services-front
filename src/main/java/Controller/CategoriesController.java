package Controller;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.json.JSONArray;

public class CategoriesController {
    private final HttpClient httpClient;
    //private static String url = "http://localhost:8080/categories";
    private static String url = "https://biller-project-services.onrender.com/categories";

    public CategoriesController() {
        this.httpClient = HttpClient.newHttpClient();
    }
    
    public JSONArray getCategories(){
        
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();
            
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            return new JSONArray(response.body());
        } catch (IOException ex) {
            throw new RuntimeException("No se puede encontrar ninguna categoría");
        } catch (InterruptedException ex) {
            throw new RuntimeException("No se puede conectar con el servidor");
        }
    }

}
