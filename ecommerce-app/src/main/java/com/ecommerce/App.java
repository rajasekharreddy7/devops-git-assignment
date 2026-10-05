package com.ecommerce;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.logging.Logger;

public class App {

    private App() {
    }	

    private static final Logger LOGGER = Logger.getLogger(App.class.getName());

    static final String RESPONSE = """
            E-Commerce Application
            Version: 1.1
            Environment: DEV - Kubernetes
            """;

    static HttpServer createServer(int port) throws IOException {

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        server.createContext("/", exchange -> {
            byte[] response = RESPONSE.getBytes();

            exchange.sendResponseHeaders(200, response.length);

            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response);
            }
        });

        return server;
    }

    static HttpServer startServer(int port) throws IOException {
        HttpServer server = createServer(port);
        server.start();
        return server;
   }

   public static void main(String[] args) throws IOException {
       startServer(8081);
   }

   static HttpServer startApplication(int port) throws IOException {
       HttpServer server = startServer(port);

       LOGGER.info("E-Commerce Application Started");
       LOGGER.log(java.util.logging.Level.INFO, "Server listening on port {0}", port);

       return server;
  }

}
