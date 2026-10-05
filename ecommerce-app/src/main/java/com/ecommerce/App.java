package com.ecommerce;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.logging.Logger;


public class App {

    private static final Logger LOGGER = Logger.getLogger(App.class.getName());

    public static void main(String[] args) throws IOException {

        HttpServer server = HttpServer.create(new InetSocketAddress(8081), 0);

        server.createContext("/", exchange -> {
            String response = """
                    E-Commerce Application
                    Version: 1.1
                    Environment: DEV - Kubernetes
                    """;

            exchange.sendResponseHeaders(200, response.getBytes().length);

            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        });

        server.start();

	LOGGER.info("E-Commerce Application Started");
	LOGGER.info("Server listening on port 8081");

    }
}
