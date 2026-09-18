package com.ecommerce;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {

    public static void main(String[] args) throws IOException {

        HttpServer server = HttpServer.create(new InetSocketAddress(8081), 0);

        server.createContext("/", exchange -> {
            String response =
                    "E-Commerce Application\n" +
                    "Version: 1.1\n" +
                    "Environment: DEV - Kubernetes\n";

            exchange.sendResponseHeaders(200, response.getBytes().length);

            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        });

        server.start();

        System.out.println("E-Commerce Application Started");
        System.out.println("Server listening on port 8081");
    }
}
