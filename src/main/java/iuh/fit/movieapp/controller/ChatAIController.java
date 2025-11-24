package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.service.ChatAIService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
@RequestMapping("/api/chat/ai")
public class ChatAIController {
    private final ChatAIService chatAIService;

    @PostMapping
    public String chat(@RequestBody String message) {
        return chatAIService.send(message);
    }
}
