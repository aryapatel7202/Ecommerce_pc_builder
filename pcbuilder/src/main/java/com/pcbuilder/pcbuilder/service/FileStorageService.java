// src/main/java/com/pcbuilder/pcbuilder/service/FileStorageService.java

package com.pcbuilder.pcbuilder.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileStorageService {

    // Define the root location for storing files.
    // This will create an 'uploads' folder in your project's root directory.
    private final Path root = Paths.get("uploads");

    public FileStorageService() {
        try {
            // Create the directory if it doesn't exist
            Files.createDirectories(root);
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize folder for upload!", e);
        }
    }

    /**
     * Saves the uploaded file to the server.
     * @param file The uploaded file from the request.
     * @return The unique filename generated for the stored file.
     */
    public String save(MultipartFile file) {
        try {
            // Generate a unique filename to avoid conflicts
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String uniqueFileName = UUID.randomUUID().toString() + extension;

            // Save the file to the 'uploads' directory with the new unique name
            Files.copy(file.getInputStream(), this.root.resolve(uniqueFileName));

            // Return the unique filename, which will be stored in the database
            return uniqueFileName;
        } catch (Exception e) {
            throw new RuntimeException("Could not store the file. Error: " + e.getMessage());
        }
    }
    public void delete(String filePath) {
        try {
            // Strip prefix "/uploads/" so we can locate the file
            String fileName = filePath.replace("/uploads/", "");
            Path file = root.resolve(fileName);
            if (Files.exists(file)) {
                Files.delete(file);
            }
        } catch (IOException e) {
            throw new RuntimeException("Could not delete the file. Error: " + e.getMessage());
        }
    }
}