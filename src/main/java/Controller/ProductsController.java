package Controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;
import javax.servlet.http.Part;
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
    
    public HttpResponse<String> createProducts(String code, String name, String description, Part image, int stock, double price, int category) throws IOException {
        HttpResponse<String> response = null;
        String imagenString = convertPartToBase64(image);   
        try {
            JSONObject data = new JSONObject();
            data.put("code", code);
            data.put("name", name);
            data.put("description", description);
            data.put("image", imagenString);
            data.put("stock", stock);
            data.put("unitPrice", price);
            data.put("category", category);
            
            
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
    
    
    public HttpResponse<String> deleteUser(int id) throws Exception {
        URI uri = URI.create(url + "/id=" + id);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(uri)
                .DELETE()
                .build();

        return httpClient.send(request, HttpResponse.BodyHandlers.ofString());
    }
        
     public static String convertPartToBase64(Part part) throws IOException {
        InputStream inputStream = part.getInputStream();
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int bytesRead;
        
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }
        
        byte[] imageBytes = outputStream.toByteArray();
        return Base64.getEncoder().encodeToString(imageBytes);
    }
}
