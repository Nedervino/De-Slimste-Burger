# De Slimste Burger


http://www.rekenkamer.nl/Nieuws_overzicht/Nieuwsberichten/2016/09/Spel_%E2%80%98Wie_is_de_slimste_burger%E2%80%99_winnaar_eerste_Nederlandse_Accountability_Hack


De Slimste Burger is een spel ontwikkeld voor de AccountabilityHack, georganiseerd door de Algemene Rekenkamer. Het doel van deze hackathon was om de open data die door overheidsinstanties en publieke instellingen gepubliceerd wordt toegankelijker te maken voor de inwoners van Nederland. De Slimste Burger doet dit door deze data te indexeren, hier automatisch vragensets van te genereren, en in een quiz gebaseerd op het spel 'de Slimste Mens' mensen hun kennis te laten pijlen en tegen hun vrienden te laten strijden om wie de slimste burger is. De app won de eerste prijs in de hackathon en is ontwikkeld door Joep Meindertsma, Thom van Kalkeren, Tom Dalenberg, Arthur Dingemans, Jurrian Tromp en Tim Nederveen.

### Concept
Doordat het spel toegang heeft tot een gigantische schat aan open data is het mogelijk om door middel van templates per gestarte quiz automatisch een unieke vragenset aan te maken. Dit houdt de herspeelbaarheid van het spel hoog en de vragen actueel. Zodra er na grote evenementen zoals prinsjesdag nieuwe gegevens online staan, kunnen deelnemers door middel van pushnotificaties uitgedaagd worden om te testen of ze nog wel goed genoeg geïnformeerd zijn. Het competitieve element moet ervoor zorgen dat men niet alleen tijdens het spelen leert, maar daarnaast ook uitgedaagd wordt om zich meer te verdiepen in de geldstromen en andere plannen van de overheid.

### Implementatie
##### Backend
Het spel bevat momenteel vier datasets opgeslagen in een NoSQL ArrangoDB instance:
  - DUO onderwijsgegevens
  - OpenSpending dataset: Milieu, Gezondheidszorg, Onderwijs, Cultuur & Recreatie
  - Rijksbegrotingen 2014-2017
  - CBS: uitkeringen/arbeidsongeschiktheid

Waar nodig is data genormaliseerd om betere of voor de speler makkelijkere vergelijkingen mogelijk te maken. Zo zijn CBS-gegevens samengevoegd met inwonersaantallen van steden om een percentage per 1000 inwoners te krijgen en zijn de onderwijsgegevens van individuele scholen geclusterd naar gemeenteniveau.

Op het moment dat een gebruiker een nieuw spel aanmaakt wordt in de RoR backend (draaiende in een Docker instance) een set tevoren aangemaakte vragentemplates (bijvoorbeeld "Hoe vaak past het begrotingsbudget voor {x} in dat voor {y}?") samengesteld en gevuld met willekeurige gegevens uit de database.  Hierbij wordt een zo geschikt mogelijke selectie gemaakt van mogelijke antwoorden (geen opties met dicht bij elkaar liggende waardes, een voorkeur voor grote bekende gemeentes in plaats van kleine, etc.). Deze unieke vragenset wordt terug naar de app gestuurd en daarnaast in de database onder een ID opgeslagen, zodat de speler met dezelfde quiz tegen anderen kan strijden



##### Frontend
Het spel draait op een ReactJS frontend, ook vanuit een Docker container. Daarnaast werd er tijdens en na de pitches een leaderboard getoond waarop de deelnemers uit het publiek live hun scores en ranking bij konden houden
