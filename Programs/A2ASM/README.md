Anw01 (ldr R0, =VariableA): Die Speicheradresse von VariableA wird in das Register R0 geladen (Register R0 dient als Zeiger).
Anw02 (ldrb R2, [R0]): Das erste Byte aus dem Speicher an der Adresse in R0 wird in das Register R2 geladen.
Anw03 (ldrb R3, [R0, #1]): Das darauf folgende Byte an der Adresse R0 + 1 wird in das Register R3 geladen.
Anw04 (lsl R2, #8): Der Wert in Register R2 wird um 8 Bits nach links verschoben (Logical Shift Left). Dadurch wird das Byte an die höherwertige Stelle (MSB) gerückt und rechts mit 8 Nullen aufgefüllt.
Anw05 (orr R2, R3): Die Register R2 und R3 werden bitweise ODER-verknüpft. Dadurch werden die beiden einzelnen Bytes zu einem gemeinsamen 16-Bit-Wert kombiniert.
Anw06 (strh R2, [R0]): Der kombinierte 16-Bit-Wert (Halfword) aus Register R2 wird an die Speicheradresse geschrieben, auf die R0 zeigt.