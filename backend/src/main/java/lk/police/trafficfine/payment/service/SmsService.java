package lk.police.trafficfine.payment.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
@Slf4j
public class SmsService {

    private static final String NOTIFY_URL = "https://app.notify.lk/api/v1/send";

    @Value("${notify.lk.user-id}")
    private String userId;

    @Value("${notify.lk.api-key}")
    private String apiKey;

    @Value("${notify.lk.notify-id}")
    private String notifyId;

    private final RestTemplate restTemplate = new RestTemplate();

    @Async
    public void send(String phone, String message) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
            body.add("user_id", userId);
            body.add("api_key", apiKey);
            body.add("sender_id", notifyId);
            body.add("to", phone);
            body.add("message", message);

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(NOTIFY_URL, request, String.class);
            log.info("SMS sent to {}: status={}", phone, response.getStatusCode());
        } catch (Exception e) {
            log.error("Failed to send SMS to {}: {}", phone, e.getMessage());
        }
    }
}
