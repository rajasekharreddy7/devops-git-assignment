package com.ecommerce;

import com.sun.net.httpserver.HttpServer;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AppTest {

    @Test
    void shouldReturnApplicationResponse() throws Exception {

        HttpServer server = App.startApplication(0);

        try {
            int port = server.getAddress().getPort();

            HttpClient client = HttpClient.newHttpClient();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:" + port + "/"))
                    .build();

            HttpResponse<String> response = client.send(
                    request,
                    HttpResponse.BodyHandlers.ofString()
            );

            assertEquals(200, response.statusCode());
            assertTrue(response.body().contains("E-Commerce Application"));
            assertTrue(response.body().contains("Version: 1.1"));
            assertTrue(response.body().contains("Environment: DEV - Kubernetes"));

        } finally {
            server.stop(0);
        }
    }
}
