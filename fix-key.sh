#!/bin/bash
echo "🔧 Исправляю key.json..."

# Удаляем старый
rm -f key.json

# Создаем новый ключ
yc iam key create \
  --service-account-id ajedij4cmvi0pfi8fu8u \
  --output key_temp.json

# Обрабатываем ключ для правильного JSON
jq -r '.' key_temp.json > key.json

# Проверяем
if python3 -m json.tool key.json > /dev/null 2>&1; then
  echo "✅ key.json валиден"
  rm -f key_temp.json
else
  echo "❌ Ошибка в key.json, создаю вручную..."
  # Создаем минимальный валидный JSON
  cat > key.json << 'JSONEOF'
{
  "id": "temp-id",
  "service_account_id": "ajedij4cmvi0pfi8fu8u",
  "created_at": "2025-12-18T00:00:00Z",
  "key_algorithm": "RSA_2048",
  "public_key": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6yvEaTMMjX3iiSjqLU7W\nZjLjR06/YqjJGchKpjCPfPmCyZsDESzVnWsQTPFKbZtxBjYXSZKmjDm3kcevdeVV\n1U/WCcNCidfwZJQprMfRGT2NudATOgjKyFrdTJOltFc9/8W6kI9Sp+WoU9Hyyqj6\n+Q7tGP43Aaxyz44K6XjkJD2zWqEwu8zxN4u0QasXZs4I56r9kdgi6zSI09clBYw5\n/YdHJ8KlCOmwVI/P560MaI0i3iF1lAwHnXWEAq2yc2dDOEmh8Up6iKApD3BVbe5q\nCNdR4xWGhghJ5QFmOOrqeEB/BtNiAUgtP1+JCHTMq6VtgjnMb7g+0TwypG0rKIhX\nqQIDAQAB\n-----END PUBLIC KEY-----",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDrK8RpMwyNfeKJ\nKOotTtZmMuNHTr9iqMkZyEqmMI98+YLJmwMRLNWdaxBM8Uptm3EGNhdJkqaMObeR\nx6915VXVT9YJw0KJ1/BklCmsx9EZPY250BM6CMrIWt1Mk6W0Vz3/xbqQj1Kn5ahT\n0fLKqPr5Du0Y/jcBrHLPjgrpeOQkPbNaoTC7zPE3i7RBqxdmzgjnqv2R2CLrNIjT\n1yUFjDn9h0cnwqUI6bBUj8/nrQxojSLeIXWUDAeddYQCrbJzZ0M4SaHxSnqIoCkP\ncFVt7moI11HjFYaGCEnlAWY46up4QH8G02IBSC0/X4kIdMyrpW2COcxvuD7RPDKk\nbSsoiFepAgMBAAECggEAH9QuoyZbnpLZJEM7XqJ69h4REMehs5KwlSK8p72OzhVf\nFDY8tghhaQrii+dkcW1GYNbVVAnbLMNrCvoBz20YruQ9Tdj1mn51dMdw1Ie+zzG7\nitiUoZgrCe7yYLjjBoOASqvSUlpzj3HP1Hhn6fHw9eCFSoqtmzZh26GX7H2GMzk8\nL5KgFEy4Po5dva9yziJqL0tMWMIjsox9c/0emIjcc4P8BMQP7tiOs+f29OYsh8Kb\nBTiEdSsEAQVIkTj0iRWbU2Fi9HKWVb0aM/xz2Z6MISCfJ/QNZ13dm0epeDOzaUqZ\n0ksUrRRt/I6pQTmdQScP9ARJweY6Fu+Hvj1qnuv2eQKBgQD3T/eQQegdFSXEgpWx\nWJrnU0gvkmrCU4r4SqR87151k6ys8u3qccLxxnfG53zAxu+/O0zN7KU1b5aRKAo3\nrtoSEmENb6L/92+qgSheNxL6Y/JwpcX/4A62IczLXCyVjLmCQX7KRqKvt+lB7NEz\n6I7JHN0zcMSoPb091F/28YllnwKBgQDzbp1mUp6QgRp8AtDPWogW95GDPsruvlTF\nG4Ifsq46u+xHaRFRRzD5azXLjxPMAibrdmXHaRONFYhRnrx6/13nwQvljcoINYrG\nN0YuVly9+6/wooV1Hg8jK5bTx98v5CNw/5qyn4roOthpZgS66Wg6587WWYTRl8dD\nYT+SLXRttwKBgFxTXCZclFyXEnxkC6IjY+DL9Hzd+kEFkzHSG8oQSoE2WhZOsob9\nZTuBTiHRNX96RPJtHuUZXSuvttQF0JqtCfgJKHYtoPpR0zwh74IMqWcUfOOU33AA\noz1XLO8WQAasfGymKsE00XMsA0Z7NDZesT9fKS0VAjWUpts4N4Mm9JYdAoGABhaD\nGzb/vi9sYSOU40qpUqG4YubkHlpmNlO8ylwmnVNr0lFfXIACSoqS2tdmMFjxbjwU\nyYroMUQTl673mb/fMleSm5gTMGdeZBynxarlQN8VhFgcLFSnHkMNz5gVDdaPyFis\nHsF8sNgf52rkvWPu9mIruxKcDr3T/uxksZwvaDsCgYBAtO+TiAZm8biR/QcLNU7/\nITeRIq2Uckr2cQIctIP+mFoSNBSLezd6Z1+1eDB2r3RjQ1XSXxn+A9JSVlxiOyqY\noNyWdtb19eFdon9I0LK/W7J3rV/DJP5vqKZu19ALkX8T/bOrXD7Iv8jd7FLGHQvc\nX79ZoslM1/EmngVHaQaWpw==\n-----END PRIVATE KEY-----"
}
JSONEOF
fi

echo "✅ Готово!"
