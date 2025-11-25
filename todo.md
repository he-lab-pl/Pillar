Twoim celem jest przygotowałenie kodu ESPHOME do customowej płytki pcb któa bedzie sterowała lampą led. Ma sie to standardowo integrować z z esphome

Ogólnie:
lampa ma serwoeanie RGBTCT oraz posiada przyciski dotykowe jako moduły TTP223 oraz  buzzer jak fedbacck 
Button TTP223 działa tak, że gdy palec jest w pobliżu to jest on, gdy brak dotyku to off

Moduł to esp c3 super mini taka płytka gotowa malutka
taka: https://sklep.msalamon.pl/produkt/plytka-esp32-c3-super-mini-wifi-bluetooth/?srsltid=AfmBOoqRaaJ1pWDaDcIcS7obJux5yeLzjKZM_3u_SBtoLaLu2YfEZ6MH


Wykorzytane GPIO

Kanały pwm
CH1 - gpio3
CH2 - gpio4
CH3 - gpio5
CH4 - gpio6
CH5 - gpio10


Buzzer pasywny - GPIO7

touch buttons (2 buttony obok siebie)
GPIO0
GPIO2



Realizacja:

1. Moduł ma sterować paskami led rgbct więc ch1-5 wieć mamy odpowiednia liczbę kanaów
2. dotknięcie buttonów dotykowych ma powodować "pikniknięcie" jako feeback dzźwiękowy
3. Przytrzymanie przez 10s buttonów dotykowych ma powodować włączenie trybu AP, urchomienie jego powinno też być zaygnalizowane jakiś specyficznyczną meldoyją z buzzer. 
4. Restore state swietła ma być ostanio zapisany




Stwórz efekty świetlne dla świtła:
- zorza - kolory zorzy swobodnie przenikają sie powoli (możesz tutaj też wykorzystywać biały zimny z paska led)
- tęcza - kolory tęczy prznikają się powoli
- świeczka - efekt ma symulować palenie sie świeczki, pamietaj że masz duzo tutaj kanałów i kolorów i mozesz to wykorzytać kreatywnie
- maksymlana jasnosć - wszytskie kanały ma max



Obsługa przycisków

- gdy lampa jest wyłączona naciśniecie dowolnego przycisku dotykowego pwoduje włacznie dwóch białych kanłów
- gdy lama sie świeci to przycisk lewy GPIO0 (ściemnji), prawy GPIO2 (rozjaśnji) skok ok 15%
- przytrzymanie 3s GPIO0 pwoduję wyłączenie świecenia czyli wyłączeni lampy 



Pierwsze uruchomienie - lmapa nie ma wchodzic automatycznie w tryb ap -tylko gdy zostanie wykonana akcja


urzadzenie powinno być widoczne w home assitant z suffixem mac - LED Lmap xxxxx










