/*
*****************************
Autor: Daan de Dios
Datum: 2018-09-02
Aufgabe: A5 - SELECT-DML 1
*****************************
######################################
!! Dies sind die Musterlösungen !!
!! Um diese Aufgabe zu lösen Benötigt ihr die "wetterdaten" Datenbbakt.
!! Installationsanleitung für die DB unter: https://github.com/daandedios/M105_A5-SELECT-DML-1/blob/master/DB_Installation%20-%20Wetterdaten/A5-DB_Installation-Wetterdaten.txt

!! Aufgaben ohne Lösungen sind unter folgendem Link zu finden:
!! Bei Fragen stehe ich euch gerne zu Verfügung: "SQL.dedios@gmail.com" oder per WhatsApp.
######################################
*/

-- 1. Erstellen Sie eine Liste mit den vollständigen Tupeln (Datensätzen) aller Wetterstationen.
SELECT *
  FROM wetterdaten.wetterstation;


-- 2. Erstellen Sie eine nach der Höhe sortierte Standort-Liste (Listenausgabe nur der Standorte).
SELECT Standort
  FROM wetterdaten.wetterstation
    ORDER BY wetterdaten.wetterstation.Hoehe DESC;


-- 3. Erstellen Sie eine nach den Standorten alphabetisch absteigende (beginnend bei Z) Liste mit den Attributen
--    Standort sowie den beiden geografischen Koordinaten.
SELECT Standort, Geo_Breite,Geo_Laenge
  FROM wetterstation
    ORDER BY wetterdaten.wetterstation.Standort DESC;


-- 4. Erstellen Sie eine Abfrage, welche gleichzeitig das Datum der ersten und der letzten Messung ausgibt.
SELECT MIN(Datum), MAX(Datum)
  FROM wettermessung;


-- 5. Erstellen Sie eine Abfrage, welche die Anzahl verschiedener Messtage ausgibt. Die Ausgabespalte soll dabei mit
--    „Anzahl Messtage“ beschriftet sein.
SELECT COUNT(DISTINCT Datum) AS 'Anzahl Messtage'
  FROM wettermessung;


-- 6. Wie lange war die durchschnittliche Sonnenscheindauer aller Stationen während der beiden Monate Juli und August 2014?
--    Achtung, das Datum kann abweichen, je nach dem welchen Stand Sie eingelesen haben.
SELECT AVG(Sonnenscheindauer) AS 'Sonnenscheindauer Durschnitt'
  FROM wettermessung
	  WHERE Datum BETWEEN '2018-07-01' and '2018-08-31';


-- 7. Über wie viele Wetterstationen verfügen die einzelnen Betreiber? Geben Sie in der Ausgabe den Betreiber und die jeweilige Anzahl aus.
SELECT Betreiber, COUNT(Betreiber)
  FROM wetterstation
  GROUP BY Betreiber;


-- 6/b ändere bei einigen den Betreibername um die nächste Aufgabe besser darzustellen.
UPDATE wetterstation
  SET Betreiber = 'DDD'
  WHERE S_ID BETWEEN 100 AND 500;


-- 8. Erstellen Sie eine Abfrage, welche alle Wettermessungen ohne Angaben über die maximale Windstärke ausgibt.
SELECT Stations_ID, Datum, Qualitaet, Min_5cm, Min_2m, Mittel_2m, Max_2m, Relative_Feuchte, Mittel_Windstaerke, Sonnenscheindauer, Mittel_Bedeckungsgrad, Niederschlagshoehe, Mittel_Luftdruck
  FROM wettermessung;


-- 9. Welche Wetterstation weist die grösste Differenz zwischen der geringsten Tiefsttemperatur und der maximalen
--    Höchsttemperatur 2m über dem Boden über alle Messdaten hinweg aus und wie gross ist diese Temperatur?
--    Geben Sie eine Liste aller Wetterstationen aus, geordnet nach der Temperaturdifferenz, beginnend mit der Grössten.$
--    Die Ausgabespalte der Temperaturdifferenz soll dabei mit „Max. Temperaturdifferenz“ beschriftet sein.
SELECT wetterdaten.wetterstation.Standort, wetterdaten.wetterstation.S_ID, MAX(wetterdaten.wettermessung.Max_2m)-MIN(wetterdaten.wettermessung.Max_2m) AS 'TemperaturDifferenz'
  FROM wettermessung
  LEFT JOIN wetterstation
    ON wettermessung.Stations_ID = wetterstation.S_ID
      GROUP BY wetterdaten.wetterstation.Standort
         ORDER BY TemperaturDifferenz DESC;

-- Variante 2
SELECT stations_ID, MAX(max_2m)-MIN(min_2m) AS MaxTemperatudifferenz FROM wettermessung
	GROUP BY stations_ID
	  ORDER BY MaxTemperatudifferenz DESC;



-- 10. Erstellen Sie eine Liste, welche die Stations_ID sowie die zugehörige, absteigend sortierte,
--     durchschnittliche Datenqualität über den gesamten Messzeitraum ausgibt. Als zweites Kriterium soll die
--     Liste auch noch aufsteigend nach der Stations_ID sortiert sein.
SELECT wetterdaten.wetterstation.S_ID, AVG(wetterdaten.wettermessung.Qualitaet) AS 'AVG_Q' FROM wetterstation
  LEFT JOIN wettermessung
    ON wetterstation.S_ID = wettermessung.Stations_ID
      GROUP BY wetterdaten.wetterstation.S_ID
        ORDER BY AVG_Q DESC, wetterdaten.wetterstation.S_ID ASC;

-- Variante 2
SELECT stations_ID, AVG(qualitaet) AS Durchschnitt
  FROM wettermessung
	  GROUP BY stations_ID
	    ORDER BY AVG(qualitaet) DESC, stations_ID ASC;


-- 11. Gesucht ist der gesamte Wetterstation-Tupel (Datensatz) der nördlichsten Wetterstation.
SELECT * FROM wetterstation
  WHERE Geo_Laenge = (SELECT MAX(Geo_Laenge)
                      FROM wetterstation);


-- 12. Gesucht sind die Stations_ID und die entsprechende Temperatur, für welche die höchste jemals gemessene Temperatur 2m über Boden gemessen wurde.
SELECT wetterdaten.wettermessung.Stations_ID, wetterdaten.wetterstation.Standort, wetterdaten.wettermessung.Max_2m
  FROM wettermessung
    LEFT JOIN wetterstation
      ON wettermessung.Stations_ID = wetterstation.S_ID
          WHERE Max_2m = (SELECT MAX(Max_2m)
                          FROM wettermessung);

-- Variante 2
SELECT wetterdaten.wettermessung.Stations_ID, wetterdaten.wettermessung.Max_2m
  FROM wettermessung
    WHERE Max_2m = (SELECT MAX(Max_2m)
                    FROM wettermessung);
