package lk.police.trafficfine.fine.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import lk.police.trafficfine.common.BadRequestException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.UUID;

@Service
public class FineQrService {

    private final String paymentWebBaseUrl;

    public FineQrService(@Value("${app.payment-web-base-url:http://localhost:3000}") String paymentWebBaseUrl) {
        this.paymentWebBaseUrl = paymentWebBaseUrl;
    }

    public String buildPaymentUrl(String referenceNo, UUID categoryId) {
        return UriComponentsBuilder
                .fromHttpUrl(paymentWebBaseUrl)
                .pathSegment("fine", referenceNo)
                .queryParam("categoryId", categoryId)
                .build()
                .toUriString();
    }

    public String generateQrCodeDataUrl(String paymentUrl) {
        try {
            QRCodeWriter writer = new QRCodeWriter();
            BitMatrix matrix = writer.encode(paymentUrl, BarcodeFormat.QR_CODE, 320, 320);
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(matrix, "PNG", outputStream);
            return "data:image/png;base64," + Base64.getEncoder().encodeToString(outputStream.toByteArray());
        } catch (WriterException | IOException e) {
            throw new BadRequestException("Unable to generate QR code");
        }
    }
}
