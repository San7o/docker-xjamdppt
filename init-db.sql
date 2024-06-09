CONNECT 'jdbc:derby://localhost:1527/DerbyDB;create=true';

DROP TABLE Profili;
DROP TABLE Eventi;


CREATE TABLE Profili(username VARCHAR(30) PRIMARY KEY, password VARCHAR(30), nome VARCHAR(30), cognome VARCHAR(30), birthDate DATE, email VARCHAR(30), phoneNumber VARCHAR(10), numeroAcquisti INT, isAdmin BOOLEAN);

INSERT INTO Profili VALUES('admin', '06nimda!', 'Giovanna', 'Varni', '1995-01-01', 'giovannavarni@unitn.it', '1234567890', 0, true);

INSERT INTO Profili VALUES('Qw3rty26', 'utente!06', 'Valerio', 'Asaro', '2004-03-26', 'valerio.asaro@unitn.it', '3713651046', 26, false);

INSERT INTO Profili VALUES('San7os', 'utente!06', 'Giovanni', 'Santini', '2003-07-13', 'giovanni.santini@unitn.it', '3394072388', 2, false);

INSERT INTO Profili VALUES('ZaWarudoDa02', 'utente!06', 'Riginel', 'Ungureanu', '2003-11-29', 'riginel.ungureanu@unitn.it', '3394072388', 20, false);


CREATE TABLE Eventi(titolo VARCHAR(50) PRIMARY KEY, sottotitolo VARCHAR(50), descrizione VARCHAR(300), tipologiaEvento VARCHAR(30), luogo VARCHAR(30), data DATE, ora TIME, image VARCHAR(50), tipologiaBiglietti VARCHAR(30), prezzo REAL, sconto REAL, numeroClick INT);

INSERT INTO Eventi VALUES('Concerto sotto le stelle', 'Un momento da vivere tutto ad un fiato', 'Un concerto all aperto sotto il cielo stellato del Trentino con esibizioni da parte di talentuosi musicisti locali. Portate una coperta e godetevi un esperienza musicale unica.', 'Concerti', 'Trento', '2024-06-15', '20:00', 'evento1.jpeg', 'Seduti', 15.00, 0.00, 256);

INSERT INTO Eventi VALUES('Mostra di arte contemporanea', 'Esplora le opere dei talenti locali', 'Una mostra d arte contemporanea che presenta le opere di artisti emergenti della regione. Scopri nuove prospettive e lasciati ispirare dalle opere esposte.', 'Concerti', 'Rovereto', '2024-07-05', '10:00', 'evento2.jpeg', 'InPiedi', 10.00, 0.00, 120);

INSERT INTO Eventi VALUES('Spettacolo teatrale: Romeo e Giulietta', 'Una produzione teatrale emozionante', 'Una rappresentazione del classico di Shakespeare, Romeo e Giulietta, messa in scena da una compagnia teatrale locale. Un occasione per immergersi nella bellezza del teatro classico.', 'EventiSportivi', 'Trento', '2024-08-20', '19:30', 'evento3.jpeg', 'Seduti', 30.00, 25.00, 180);

INSERT INTO Eventi VALUES('Escursione sul Monte Bondone', 'Una camminata nella natura', 'Un escursione guidata sul suggestivo Monte Bondone, con panorami mozzafiato e la possibilità di esplorare la flora e la fauna locali. Un esperienza immersiva nella bellezza naturale del Trentino.', 'VisiteGuidate', 'Povo', '2024-09-10', '09:00', 'evento4.jpeg', 'InPiedi', 20.00, 0.00, 90);

INSERT INTO Eventi VALUES('Festival enogastronomico del Garda', 'Assaggia le delizie locali', 'Un festival dedicato alla cucina e ai vini della regione del Garda, con degustazioni, bancarelle di prodotti locali e intrattenimento dal vivo. Un occasione per scoprire i sapori autentici del Trentino.', 'SpettacoliTeatrali', 'Riva', '2024-10-15', '12:00', 'evento5.jpeg', 'Seduti', 25.00, 10.00, 150);


