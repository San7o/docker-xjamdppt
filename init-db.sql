CONNECT 'jdbc:derby://localhost:1527/DerbyDB;create=true';



CREATE TABLE Profili(username VARCHAR(30) PRIMARY KEY, password VARCHAR(30), nome VARCHAR(30), cognome VARCHAR(30), birthDate DATE, email VARCHAR(30), phoneNumber VARCHAR(10), numeroAcquisti INT, isAdmin BOOLEAN);

INSERT INTO Profili VALUES('admin', '06nimda!', 'Vincenzo', 'Marco', '1990-01-01', 'marcotheofficial@unitn.it', '1234567890', 0, true);




CREATE TABLE Eventi(titolo VARCHAR(50) PRIMARY KEY, sottotitolo VARCHAR(50), descrizione VARCHAR(300), tipologia VARCHAR(30), luogo VARCHAR(30), data DATE, ora TIME, timage BLOB, tipologiaBiglietti VARCHAR(30), prezzo REAL, sconto REAL, numeroClick INT);

INSERT INTO Eventi VALUES('Concerto sotto le stelle', 'Serata di musica classica', 'Un concerto all aperto sotto il cielo stellato del Trentino con esibizioni da parte di talentuosi musicisti locali. Portate una coperta e godetevi un esperienza musicale unica.', 'A piedi', 'Trento', '2024-06-15', '20:00', NULL, 'Generale', 15.00, 0.00, 256);

INSERT INTO Eventi VALUES('Mostra d arte contemporanea', 'Esplora le opere dei talenti locali', 'Una mostra d arte contemporanea che presenta le opere di artisti emergenti della regione. Scopri nuove prospettive e lasciati ispirare dalle opere esposte.', 'A piedi', 'Rovereto', '2024-07-05', '10:00', NULL, 'Generale', 10.00, 0.00, 120);

INSERT INTO Eventi VALUES('Spettacolo teatrale: Romeo e Giulietta', 'Una produzione teatrale emozionante', 'Una rappresentazione del classico di Shakespeare, Romeo e Giulietta, messa in scena da una compagnia teatrale locale. Un occasione per immergersi nella bellezza del teatro classico.', 'A sedere', 'Trento', '2024-08-20', '19:30', NULL, 'VIP', 30.00, 0.10, 180);

INSERT INTO Eventi VALUES('Escursione sul Monte Bondone', 'Una camminata nella natura', 'Un escursione guidata sul suggestivo Monte Bondone, con panorami mozzafiato e la possibilità di esplorare la flora e la fauna locali. Un esperienza immersiva nella bellezza naturale del Trentino.', 'A piedi', 'Povo', '2024-09-10', '09:00', NULL, 'Generale', 20.00, 0.00, 90);

INSERT INTO Eventi VALUES('Festival enogastronomico del Garda', 'Assaggia le delizie locali', 'Un festival dedicato alla cucina e ai vini della regione del Garda, con degustazioni, bancarelle di prodotti locali e intrattenimento dal vivo. Un occasione per scoprire i sapori autentici del Trentino.', 'A piedi', 'Riva del Garda', '2024-10-15', '12:00', NULL, 'Generale', 25.00, 0.00, 150);


