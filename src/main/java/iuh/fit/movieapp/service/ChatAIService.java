package iuh.fit.movieapp.service;

import jakarta.annotation.PostConstruct;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.prompt.SystemPromptTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import iuh.fit.movieapp.model.Movie;
import java.util.List;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.messages.AssistantMessage;
import java.util.Objects;
import java.util.stream.Collectors; // Added this import

@Service
public class ChatAIService {
    private final ChatClient chatClient;
    private final MovieService movieService;

    // --- Chat History additions ---
    private static record ChatMessage(String role, String content) {}
    private final List<ChatMessage> chatHistory = new ArrayList<>();
    private static final int MAX_HISTORY_SIZE = 20; // Stores up to 20 messages (user + AI)
    // --- End Chat History additions ---

    @Value("classpath:API_DOCUMENTATION.md")
    private Resource apiDocResource;

    private String apiDocumentation;

    ChatAIService(ChatClient.Builder chatBuilder, MovieService movieService) {
        this.chatClient = chatBuilder.build();
        this.movieService = movieService;
    }

    @PostConstruct
    public void init() throws IOException {
        apiDocumentation = asString(apiDocResource);
    }

    public String send(String message) {
        // Add user message to history
        chatHistory.add(new ChatMessage("user", message));
        // Truncate history
        while (chatHistory.size() > MAX_HISTORY_SIZE) {
            chatHistory.remove(0); // Remove oldest message
        }
        // Simple intent recognition for movie queries
        if (message.toLowerCase().contains("phim nào") ||
            message.toLowerCase().contains("có phim") ||
            message.toLowerCase().contains("danh sách phim") ||
            message.toLowerCase().contains("show movies")) {

            List<Movie> currentlyShowingMovies = movieService.findCurrentlyShowingMovies();
            if (currentlyShowingMovies.isEmpty()) {
                return "Hiện tại không có phim nào đang chiếu.";
            } else {
                StringBuilder movieTitles = new StringBuilder("Hiện tại đang chiếu các phim sau:\n");
                for (Movie movie : currentlyShowingMovies) {
                    movieTitles.append("- ").append(movie.getTitle()).append("\n");
                }
                return movieTitles.toString();
            }
        }

        List<org.springframework.ai.chat.messages.Message> aiMessages = chatHistory.stream()
                .map(chatMessage -> {
                    if ("user".equals(chatMessage.role())) {
                        return new org.springframework.ai.chat.messages.UserMessage(chatMessage.content());
                    } else if ("assistant".equals(chatMessage.role())) {
                        return new org.springframework.ai.chat.messages.AssistantMessage(chatMessage.content());
                    }
                    return null;
                })
                .filter(java.util.Objects::nonNull)
                .collect(java.util.stream.Collectors.toList());

        SystemPromptTemplate systemPromptTemplate = new SystemPromptTemplate(
                """
                You are a helpful assistant for a movie ticket booking application.
                Your name is MovieBot.
                You can only answer questions related to the movie ticket booking system based on the provided API documentation.
                If you don't know the answer, just say "I don't know".
                Here is the API documentation:
                {api_documentation}
                """
        );
        String aiResponse = chatClient.prompt()
                .messages(aiMessages) // Pass the history messages
                .system(systemSpec -> systemSpec.text(systemPromptTemplate.getTemplate())
                        .param("api_documentation", apiDocumentation))
                .user(message)
                .call()
                .content();

        // Add AI response to history
        chatHistory.add(new ChatMessage("assistant", aiResponse));
        // Truncate history
        while (chatHistory.size() > MAX_HISTORY_SIZE) {
            chatHistory.remove(0); // Remove oldest message
        }

        return aiResponse;
    }

    private static String asString(Resource resource) throws IOException {
        try (Reader reader = new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8)) {
            return FileCopyUtils.copyToString(reader);
        }
    }
}
