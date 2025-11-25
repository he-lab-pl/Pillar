# 💡 Lampa LED RGBCCT - Dokumentacja

Dokumentacja customowej lampy LED sterowanej przez ESP32-C3 Super Mini z integracją Home Assistant przez ESPHome.

---

## 📋 Spis treści

1. [Opis projektu](#opis-projektu)
2. [Specyfikacja techniczna](#specyfikacja-techniczna)
3. [Schemat połączeń](#schemat-połączeń)
4. [Instalacja i konfiguracja](#instalacja-i-konfiguracja)
5. [Obsługa urządzenia](#obsługa-urządzenia)
6. [Efekty świetlne](#efekty-świetlne)
7. [Integracja z Home Assistant](#integracja-z-home-assistant)
8. [Rozwiązywanie problemów](#rozwiązywanie-problemów)

---

## 🔍 Opis projektu

Lampa LED to inteligentne urządzenie do sterowania paskami LED RGBCCT (Red, Green, Blue, Cold White, Warm White). Oferuje:

- ✅ **5 kanałów PWM** - pełna kontrola kolorów RGB + 2 odcienie bieli
- ✅ **Przyciski dotykowe** - wygodna obsługa bez fizycznych przycisków
- ✅ **Feedback dźwiękowy** - potwierdzenie akcji przez buzzer
- ✅ **Efekty świetlne** - zorza, tęcza, świeczka, maksymalna jasność
- ✅ **Integracja z Home Assistant** - pełna kontrola przez smart home
- ✅ **Łatwa konfiguracja WiFi** - Captive Portal dla użytkownika końcowego
- ✅ **Zapamiętywanie stanu** - lampa wraca do ostatniego ustawienia po restarcie

---

## ⚙️ Specyfikacja techniczna

### Płytka główna
- **Model**: ESP32-C3 Super Mini
- **Procesor**: ESP32-C3 (RISC-V, 160 MHz)
- **Pamięć**: 4MB Flash
- **WiFi**: 802.11 b/g/n (2.4 GHz)
- **Bluetooth**: BLE 5.0
- **Zasilanie**: 5V DC (USB-C lub piny VCC/GND)

### Wykorzystane GPIO

| GPIO | Funkcja | Opis |
|------|---------|------|
| GPIO3 | PWM CH1 | Kanał RED |
| GPIO4 | PWM CH2 | Kanał GREEN |
| GPIO5 | PWM CH3 | Kanał BLUE |
| GPIO6 | PWM CH4 | Kanał COLD WHITE |
| GPIO10 | PWM CH5 | Kanał WARM WHITE |
| GPIO7 | PWM Buzzer | Buzzer pasywny (feedback dźwiękowy) |
| GPIO0 | Input | Przycisk dotykowy TTP223 LEWY |
| GPIO2 | Input | Przycisk dotykowy TTP223 PRAWY |

### Komponenty zewnętrzne
- **Paski LED**: RGBCCT (5 kanałów, 12V lub 24V)
- **Moduły dotykowe**: 2x TTP223 (capacitive touch)
- **Buzzer**: Pasywny (2-5V, 2-4kHz)
- **Sterowniki LED**: MOSFET lub dedykowane układy PWM (zależnie od mocy pasków)
- **Sterowanie PWM**: częstotliwość 20 kHz (brak migotania) przy rozdzielczości 10-bit

---

## 🔌 Schemat połączeń

### Kanały PWM LED (5x)
```
ESP32-C3          Sterownik LED          Pasek LED RGBCCT
┌─────────┐      ┌──────────────┐       ┌──────────┐
│ GPIO3   ├─────→│ MOSFET CH1   ├──────→│ RED      │
│ GPIO4   ├─────→│ MOSFET CH2   ├──────→│ GREEN    │
│ GPIO5   ├─────→│ MOSFET CH3   ├──────→│ BLUE     │
│ GPIO6   ├─────→│ MOSFET CH4   ├──────→│ COLD WHT │
│ GPIO10  ├─────→│ MOSFET CH5   ├──────→│ WARM WHT │
└─────────┘      └──────────────┘       └──────────┘
```

### Przyciski dotykowe TTP223 (2x)
```
ESP32-C3          TTP223 Lewy           TTP223 Prawy
┌─────────┐      ┌──────────┐          ┌──────────┐
│ GPIO0   │←─────┤ I/O      │          │ I/O      ├─────→ GPIO2
│ GND     ├──────┤ GND      │          │ GND      ├────┐
│ 3.3V    ├──────┤ VCC      │          │ VCC      ├────┤
└─────────┘      └──────────┘          └──────────┘    │
                                                     Common 3.3V
```

### Buzzer pasywny
```
ESP32-C3          Buzzer
┌─────────┐      ┌──────┐
│ GPIO7   ├─────→│ +    │
│ GND     ├──────┤ -    │
└─────────┘      └──────┘
```

**Uwaga**: Dla pasków LED o większej mocy niezbędne są zewnętrzne zasilacze i sterowniki MOSFET!

---

## 🚀 Instalacja i konfiguracja

### Dla programisty (przygotowanie firmware)

#### 1. Instalacja ESPHome

**Metoda 1: Przez Home Assistant (zalecana)**
- Zainstaluj dodatek "ESPHome" w Home Assistant
- Otwórz panel ESPHome
- Kliknij "+ New Device"

**Metoda 2: Standalone (lokalnie)**
```bash
# Instalacja przez pip
pip install esphome

# Lub przez Docker
docker pull esphome/esphome
```

#### 2. Przygotowanie plików

```bash
# Struktura projektu
kod/
├── led-lamp.yaml       # Główna konfiguracja
├── secrets.yaml        # Dane wrażliwe (WiFi, hasła)
└── README.md          # Ta dokumentacja
```

#### 3. Ustawienia WiFi i AP

W pliku `led-lamp.yaml` na górze (sekcja `substitutions`) znajdziesz domyślne wartości:

```yaml
substitutions:
  ...
  wifi_ssid: "MojaSiecWiFi"
  wifi_password: "MojeHaslo123"
  ap_ssid: "LED Lamp Setup"
  ap_password: "12345678"
```

Zmień je na swoje dane. Plik `secrets.yaml` służy już tylko do wprowadzenia haseł OTA/web (jeżeli potrzebujesz).

#### 4. Kompilacja i flashowanie

**Pierwsze flashowanie (przez USB):**

```bash
# Podłącz ESP32-C3 przez USB-C
# Sprawdź port (Windows: COMx, Linux/Mac: /dev/ttyUSBx)

# Kompilacja i flashowanie
esphome run led-lamp.yaml

# Lub przez Home Assistant ESPHome:
# 1. Upload do dashboard
# 2. Kliknij "Install"
# 3. Wybierz "Plug into this computer"
```

**Kolejne aktualizacje (przez WiFi - OTA):**

```bash
# Jeśli urządzenie jest w sieci
esphome run led-lamp.yaml --device 192.168.1.xxx

# Lub przez Home Assistant ESPHome:
# Kliknij "Update" - aktualizacja bezprzewodowa
```

---

### Dla klienta końcowego (pierwsza konfiguracja)

#### Krok 1: Pierwsze uruchomienie

1. Podłącz lampę do zasilania
2. **Lampa NIE włączy się automatycznie w tryb AP** (zgodnie ze specyfikacją)
3. Możesz od razu korzystać z przycisków dotykowych

#### Krok 2: Połączenie z WiFi (opcjonalne)

**Metoda A: Przez przyciski dotykowe**

1. **Przytrzymaj OBA przyciski dotykowe przez 10 sekund**
2. Usłyszysz melodię sukcesu z buzzera
3. Lampa włączy tryb Access Point (AP)
4. Połącz się z siecią WiFi: **"LED Lamp Setup"**
5. Hasło: `12345678`
6. Przeglądarka automatycznie otworzy stronę konfiguracji (Captive Portal)
7. Wprowadź dane swojej sieci WiFi
8. Lampa połączy się z siecią i restart

#### Krok 3: Dodanie do Home Assistant

1. Otwórz Home Assistant
2. Przejdź do: **Ustawienia → Urządzenia i usługi**
3. Powinieneś zobaczyć powiadomienie o nowym urządzeniu ESPHome
4. Kliknij **"Skonfiguruj"**
5. Nie trzeba podawać klucza API – urządzenie połączy się automatycznie
6. Gotowe! Lampa pojawi się jako: **"LED Lamp [MAC_ADDRESS]"**

---

## 🎮 Obsługa urządzenia

### Sterowanie przyciskami dotykowymi

#### Lampa wyłączona:

| Akcja | Efekt |
|-------|-------|
| **Dotknięcie lewego przycisku** | Włączenie - wszystkie białe kanały na MAX |
| **Dotknięcie prawego przycisku** | Włączenie - wszystkie białe kanały na MAX |

#### Lampa włączona:

| Akcja | Efekt |
|-------|-------|
| **Krótkie dotknięcie lewego** | Ściemnienie o 15% |
| **Krótkie dotknięcie prawego** | Rozjaśnienie o 15% |
| **Przytrzymanie lewego (3s)** | Wyłączenie lampy |
| **Przytrzymanie obu (10s)** | Włączenie trybu AP (konfiguracja WiFi) |

### Feedback dźwiękowy

- **Krótki "pip"** - potwierdzenie dotknięcia przycisku
- **Melodia sukcesu** - włączenie trybu AP

---

## ✨ Efekty świetlne

Lampa oferuje 4 spektakularne efekty świetlne dostępne z Home Assistant:

### 1. **Zorza (Aurora)**
- **Opis**: Symulacja zorzy polarnej
- **Kolory**: Fiolet → Niebieski → Zielony → Biały zimny
- **Tempo**: Bardzo wolne przejścia (10-15s na cykl)
- **Zastosowanie**: Relaks, wieczór, ambient

### 2. **Tęcza (Rainbow)**
- **Opis**: Klasyczny efekt tęczy
- **Kolory**: Pełne spektrum RGB (czerwony → żółty → zielony → cyjan → niebieski → magenta)
- **Tempo**: Wolne płynne przejścia
- **Zastosowanie**: Dekoracja, impreza, dziecięcy pokój

### 3. **Świeczka (Candle)**
- **Opis**: Realistyczna symulacja płomienia świecy
- **Kolory**: Ciepły biały + żółty + pomarańczowy + czerwony
- **Efekt**: Naturalne migotanie, zmienne natężenie (60-100%)
- **Zastosowanie**: Romantyczna atmosfera, wieczór
- **Implementacja**: Zaawansowany algorytm z losowym szumem dla realizmu

### 4. **Maksymalna Jasność (Full Brightness)**
- **Opis**: Wszystkie kanały na 100%
- **Kolory**: Pełne RGB + obie biele
- **Temperatura**: ~4500K (mieszanka zimnego i ciepłego)
- **Zastosowanie**: Oświetlenie robocze, czytanie

---

## 🏠 Integracja z Home Assistant

### Automatyczne wykrywanie

Po dodaniu urządzenia do Home Assistant, lampa pojawi się jako:

**Nazwa**: `LED Lamp [MAC_ADDRESS]` (np. `LED Lamp A1B2C3`)

### Dostępne encje

#### 1. Główne światło
- **Encja**: `light.led_lamp_xxxxx`
- **Możliwości**:
  - Włączanie/wyłączanie
  - Regulacja jasności (0-100%)
  - Zmiana koloru RGB
  - Zmiana temperatury bieli (2700K - 6500K)
  - Wybór efektu świetlnego

#### 2. Przyciski (opcjonalnie widoczne)
- `binary_sensor.led_lamp_xxxxx_button_left` - stan lewego przycisku
- `binary_sensor.led_lamp_xxxxx_button_right` - stan prawego przycisku

#### 3. Diagnostyka
- `sensor.led_lamp_xxxxx_wifi_signal` - siła sygnału WiFi
- `sensor.led_lamp_xxxxx_uptime` - czas pracy od restartu

#### 4. Akcje
- `button.led_lamp_xxxxx_enable_ap_mode` - włączenie trybu AP
- `button.led_lamp_xxxxx_restart` - restart urządzenia

### Przykładowe automatyzacje

#### Automatyzacja 1: Wieczorny nastrój
```yaml
alias: "Lampa - Wieczorny nastrój"
trigger:
  - platform: sun
    event: sunset
    offset: "+00:30:00"
action:
  - service: light.turn_on
    target:
      entity_id: light.led_lamp_xxxxx
    data:
      effect: "Świeczka"
      brightness: 60
```

#### Automatyzacja 2: Wybudzanie tęczą
```yaml
alias: "Lampa - Budzenie"
trigger:
  - platform: time
    at: "07:00:00"
action:
  - service: light.turn_on
    target:
      entity_id: light.led_lamp_xxxxx
    data:
      effect: "Tęcza"
      brightness: 30
  - delay: "00:15:00"
  - service: light.turn_on
    target:
      entity_id: light.led_lamp_xxxxx
    data:
      brightness: 80
      color_temp: 200  # Ciepły biały
```

#### Automatyzacja 3: Powiadomienie przez światło
```yaml
alias: "Lampa - Alert"
trigger:
  - platform: state
    entity_id: binary_sensor.drzwi_wejsciowe
    to: "on"
action:
  - service: light.turn_on
    target:
      entity_id: light.led_lamp_xxxxx
    data:
      rgb_color: [255, 0, 0]  # Czerwony
      brightness: 100
  - delay: "00:00:03"
  - service: light.turn_on
    target:
      entity_id: light.led_lamp_xxxxx
    data:
      brightness: 80
      color_temp: 300
```

---

## 🔧 Rozwiązywanie problemów

### Lampa nie łączy się z WiFi

**Przyczyna**: Błędne dane WiFi lub słaby sygnał

**Rozwiązanie**:
1. Włącz tryb AP (przytrzymaj oba przyciski 10s)
2. Połącz się z "LED Lamp Setup" (hasło: `12345678`)
3. Wprowadź poprawne dane WiFi
4. Sprawdź czy router obsługuje 2.4 GHz (ESP32-C3 nie ma 5 GHz)

---

### Przyciski dotykowe nie reagują

**Przyczyna**: Problem z modułami TTP223 lub złe połączenie

**Rozwiązanie**:
1. Sprawdź zasilanie TTP223 (3.3V na VCC)
2. Sprawdź połączenia GPIO0 i GPIO2
3. Sprawdź czy TTP223 ma tryb "Toggle" wyłączony (powinien być tryb "Direct")

---

### Paski LED nie świecą / słabo świecą

**Przyczyna**: Brak sterowników MOSFET lub za słabe zasilanie

**Rozwiązanie**:
1. ESP32-C3 daje tylko 3.3V i ~20mA na GPIO - to za mało dla pasków LED!
2. **Musisz użyć zewnętrznych MOSFET** (np. IRLZ44N) lub dedykowanych sterowników
3. Paski LED wymagają osobnego zasilania (12V lub 24V)
4. GPIO z ESP32 steruje tylko bramką MOSFET (sygnał PWM)

---

### Efekty świetlne nie działają

**Przyczyna**: Błąd w konfiguracji lub nie są widoczne w HA

**Rozwiązanie**:
1. W Home Assistant kliknij na lampę
2. Sprawdź czy w sekcji "Efekty" są dostępne opcje
3. Jeśli nie - sprawdź logi ESPHome: `esphome logs led-lamp.yaml`
4. Możliwe że trzeba zrestartować lampę lub przeładować integrację w HA

---

### Buzzer nie działa / piszczy ciągle

**Przyczyna**: Błędne połączenie lub zwarcie

**Rozwiązanie**:
1. Sprawdź polaryzację buzzera (+ do GPIO7, - do GND)
2. Sprawdź czy to buzzer **pasywny** (nie aktywny!)
3. Jeśli piszczy ciągle - odłącz i sprawdź czy GPIO7 nie ma zwartki

---

### Lampa resetuje się losowo

**Przyczyna**: Za słabe zasilanie lub problem z WiFi

**Rozwiązanie**:
1. Użyj zasilacza min. 1A dla ESP32-C3
2. Sprawdź jakość kabla USB-C
3. Wyłącz logger w trybie produkcyjnym (zmniejszy zużycie CPU)
4. Zwiększ moc sygnału WiFi lub przenieś router bliżej

---

### Nie mogę zaktualizować firmware przez OTA

**Przyczyna**: Błędne hasło OTA lub brak połączenia

**Rozwiązanie**:
1. Sprawdź czy hasło OTA w `secrets.yaml` jest poprawne
2. Sprawdź czy urządzenie jest w sieci (ping IP)
3. Spróbuj przez kabel USB jeśli OTA nie działa
4. Sprawdź logi: `esphome logs led-lamp.yaml --device IP_URZADZENIA`

---

## 📚 Dodatkowe informacje

### Zużycie energii
- **ESP32-C3**: ~80mA (WiFi aktywne), ~20mA (deep sleep)
- **Paski LED**: zależnie od długości i jasności (sprawdź specyfikację)
- **Całość**: Zasilacz powinien być dopasowany do mocy pasków LED (zwykle 12V 2-5A)

### Bezpieczeństwo
- Używaj izolowanych obudów dla elektroniki
- Nie wystawiaj ESP32-C3 na wilgoć
- Zabezpiecz połączenia MOSFET (radiatory jeśli potrzebne)
- Paski LED powinny mieć osobne zasilanie z ochroną przed zwarciem

### Aktualizacje
- Regularnie aktualizuj ESPHome do najnowszej wersji
- Backupuj konfigurację `led-lamp.yaml` i `secrets.yaml`
- Przed aktualizacją sprawdź changelog ESPHome

### Wsparcie
- **Dokumentacja ESPHome**: https://esphome.io
- **Home Assistant Community**: https://community.home-assistant.io
- **ESP32 Documentation**: https://docs.espressif.com

---

## 📄 Licencja i autor

**Projekt**: Lampa LED RGBCCT z ESP32-C3  
**Platforma**: ESPHome + Home Assistant  
**Data utworzenia**: 2024

---

**Miłego świecenia! 💡✨**

