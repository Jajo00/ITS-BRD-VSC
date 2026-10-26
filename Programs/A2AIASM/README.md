# Praktikumsaufgabe Woche 2: Konstanten, Variablen und Datenoperationen

Der Memory Browser zeigt bei „Bytes Per Group“ = 1 die Bytes in aufsteigender
Adressreihenfolge. Der STM32F429 verwendet Little Endian: Das niederwertige Byte
eines Halbworts liegt an der kleineren Adresse. Deshalb können die Bytes im
Memory Browser anders aussehen als der Zahlenwert, den ein `LDRH` in ein
Register lädt.

## Anw01 bis Anw06

`VariableA` ist anfangs mit dem Halbwort `0xBEEF` initialisiert. Auf dem
Little-Endian-System liegen an `&VariableA` zunächst die Bytes `EF BE`.
`R0` enthält nach Anw01 die Adresse von `VariableA`; alle Werte sind hexadezimal.
„Unverändert“ bedeutet, dass der jeweilige Befehl das Register nicht verändert.

| Zeile | Effekt auf R0 | Effekt auf R2 | Effekt auf R3 | Memory ab `&VariableA` |
| --- | --- | --- | --- | --- |
| Anw01 `LDR R0,=VariableA` | Wird auf `&VariableA` gesetzt. | Unverändert. | Unverändert. | Unverändert: `EF BE 34 12 00 00` |
| Anw02 `LDRB R2,[R0]` | Unverändert. | Lädt das Byte an `&VariableA`, null-erweitert: `0x000000EF`. | Unverändert. | Unverändert: `EF BE 34 12 00 00` |
| Anw03 `LDRB R3,[R0,#1]` | Unverändert. | Unverändert: `0x000000EF`. | Lädt das Byte an `&VariableA+1`, null-erweitert: `0x000000BE`. | Unverändert: `EF BE 34 12 00 00` |
| Anw04 `LSL R2,#8` | Unverändert. | Verschiebt R2 um 8 Bit nach links: `0x0000EF00`. | Unverändert: `0x000000BE`. | Unverändert: `EF BE 34 12 00 00` |
| Anw05 `ORR R2,R3` | Unverändert. | Verknüpft bitweise mit R3: `0x0000EFBE`. | Unverändert: `0x000000BE`. | Unverändert: `EF BE 34 12 00 00` |
| Anw06 `STRH R2,[R0]` | Unverändert. | Unverändert: `0x0000EFBE`. | Unverändert: `0x000000BE`. | Schreibt das Halbwort `0xEFBE` little-endian: `BE EF 34 12 00 00`. |

Memory Browser mit Bytes Per Group = 1 zeigt `BE EF` an `VariableA` – dadurch
ist dort die Folge „BEEF“ zu erkennen. Der echte Halbwortwert, den ein `LDRH`
von dieser Adresse lesen würde, ist `0xEFBE`. Vor dem Überschreiben war der
Halbwortwert `0xBEEF`, während die einzelnen Speicherbytes `EF BE` waren.
`VariableB` folgt an den nächsten zwei Adressen und enthält zunächst `34 12`.
`VariableC` ist mit `00 00` initialisiert.

## VariableC: „AFFE“ im Memory Browser

`MOV R5,#ConstByteA` lädt `0xAFFE` in R5. Damit die Speicherbytes in
Adressreihenfolge `AF FE` lauten, werden die unteren 16 Bit vor dem Speichern
in `0xFEAF` umgeordnet: `LSR` holt das obere Byte `AF`, `LSL` verschiebt das
ursprüngliche untere Byte `FE` nach oben und `ORR` setzt beide Bytes zusammen.
Die höheren Bits von R5 sind für `STRH` unerheblich, da der Befehl nur die
unteren 16 Bit schreibt. So speichert er `AF FE` nach `VariableC`. Der Memory
Browser zeigt damit „AFFE“; der echte Little-Endian-Halbwortwert dort ist
`0xFEAF`.

## VariableB: „1234“ im Memory Browser

`VariableB` beginnt als Halbwort `0x1234` mit den Speicherbytes `34 12`.
Anw09 bis Anw0E lesen die beiden Bytes einzeln, setzen daraus mit `LSL` und
`ORR` den Registerwert `0x3412` zusammen und schreiben ihn mit `STRH` zurück.
Danach liegen die Bytes `12 34` im Speicher, sodass der Memory Browser „1234“
zeigt. Ein `LDRH` von dieser Adresse würde den echten Wert `0x3412` laden.