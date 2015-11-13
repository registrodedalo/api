-- database
CREATE DATABASE dedalo
DEFAULT CHARACTER SET = 'utf8'
DEFAULT COLLATE = 'utf8_general_ci';

USE dedalo;

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2015-11-13 15:18:22.954




-- tables
-- Table AnniScolastici
CREATE TABLE AnniScolastici (
    ID int  NOT NULL  AUTO_INCREMENT,
    Nome varchar(30)  NOT NULL,
    DataInizio date  NOT NULL,
    DataFine date  NOT NULL,
    IDScuola int  NOT NULL,
    CONSTRAINT AnniScolastici_pk PRIMARY KEY (ID)
);

-- Table Assenze
CREATE TABLE Assenze (
    ID int  NOT NULL  AUTO_INCREMENT,
    Data date  NOT NULL,
    IDStudente int  NOT NULL,
    IDGiustificazione int  NULL,
    CONSTRAINT Assenze_pk PRIMARY KEY (ID)
);

-- Table Calendario
CREATE TABLE Calendario (
    ID int  NOT NULL  AUTO_INCREMENT,
    Tipo int  NOT NULL,
    Data date  NOT NULL,
    IDMateria int  NOT NULL,
    IDOraLezione int  NULL,
    IDInsegnante int  NOT NULL,
    Descrizione text  NOT NULL,
    CONSTRAINT Calendario_pk PRIMARY KEY (ID)
);

-- Table Classi
CREATE TABLE Classi (
    ID int  NOT NULL  AUTO_INCREMENT,
    Nome varchar(50)  NOT NULL,
    Anno int  NOT NULL,
    IDScuola int  NOT NULL,
    IDAnnoScolastico int  NOT NULL,
    CONSTRAINT Classi_pk PRIMARY KEY (ID)
);

-- Table CollaboratoriScolastici
CREATE TABLE CollaboratoriScolastici (
    ID int  NOT NULL  AUTO_INCREMENT,
    IDUtente int  NOT NULL,
    CONSTRAINT CollaboratoriScolastici_pk PRIMARY KEY (ID)
);

-- Table Comunicazioni
CREATE TABLE Comunicazioni (
    ID int  NOT NULL  AUTO_INCREMENT,
    Oggetto varchar(200)  NOT NULL,
    Testo text  NOT NULL,
    Scadenza timestamp  NULL,
    CONSTRAINT Comunicazioni_pk PRIMARY KEY (ID)
);

-- Table Dispositivi
CREATE TABLE Dispositivi (
    DID varchar(15)  NOT NULL,
    Tipo int  NOT NULL,
    Creazione timestamp  NOT NULL,
    Aggiornamento timestamp  NOT NULL,
    DeviceUri text  NULL,
    IDUtente int  NOT NULL,
    CONSTRAINT Dispositivi_pk PRIMARY KEY (DID)
);

-- Table Genitori
CREATE TABLE Genitori (
    ID int  NOT NULL  AUTO_INCREMENT,
    IDUtente int  NOT NULL,
    CONSTRAINT Genitori_pk PRIMARY KEY (ID)
);

-- Table Giustificazioni
CREATE TABLE Giustificazioni (
    ID int  NOT NULL  AUTO_INCREMENT,
    IDInsegnante int  NOT NULL,
    Data datetime  NOT NULL,
    CONSTRAINT Giustificazioni_pk PRIMARY KEY (ID)
);

-- Table IngressiUscite
CREATE TABLE IngressiUscite (
    ID int  NOT NULL  AUTO_INCREMENT,
    Tipo int  NOT NULL,
    Data timestamp  NOT NULL,
    IDStudente int  NOT NULL,
    IDGiustificazione int  NULL,
    CONSTRAINT IngressiUscite_pk PRIMARY KEY (ID)
);

-- Table Insegnanti
CREATE TABLE Insegnanti (
    ID int  NOT NULL  AUTO_INCREMENT,
    IDUtente int  NOT NULL,
    IDScuola int  NOT NULL,
    CONSTRAINT Insegnanti_pk PRIMARY KEY (ID)
);

-- Table Lezioni
CREATE TABLE Lezioni (
    ID int  NOT NULL  AUTO_INCREMENT,
    IDInsegnante int  NOT NULL,
    IDClasse int  NOT NULL,
    Argomento text  NOT NULL,
    Data date  NOT NULL,
    Ora int  NOT NULL,
    Creazione datetime  NOT NULL,
    Aggiornamento datetime  NOT NULL,
    CONSTRAINT Lezioni_pk PRIMARY KEY (ID)
);

-- Table Materie
CREATE TABLE Materie (
    ID int  NOT NULL  AUTO_INCREMENT,
    Nome varchar(100)  NOT NULL,
    NomeVisualizzato varchar(30)  NOT NULL,
    CONSTRAINT Materie_pk PRIMARY KEY (ID)
);

-- Table NoteClasse
CREATE TABLE NoteClasse (
    ID int  NOT NULL  AUTO_INCREMENT,
    Testo text  NOT NULL,
    Data timestamp  NOT NULL,
    IDInsegnante int  NOT NULL,
    IDClasse int  NOT NULL,
    CONSTRAINT NoteClasse_pk PRIMARY KEY (ID)
);

-- Table OreLezione
CREATE TABLE OreLezione (
    ID int  NOT NULL  AUTO_INCREMENT,
    Ora int  NOT NULL,
    Inizio time  NOT NULL,
    Fine time  NOT NULL,
    IDMateria int  NOT NULL,
    IDClasse int  NOT NULL,
    Note text  NULL,
    CONSTRAINT OreLezione_pk PRIMARY KEY (ID)
);

-- Table RelClassiComunicazioni
CREATE TABLE RelClassiComunicazioni (
    IDComunicazione int  NOT NULL,
    IDClasse int  NOT NULL,
    CONSTRAINT RelClassiComunicazioni_pk PRIMARY KEY (IDComunicazione,IDClasse)
);

-- Table RelClassiInsegnanti
CREATE TABLE RelClassiInsegnanti (
    IDClasse int  NOT NULL,
    IDInsegnante int  NOT NULL,
    IDMateria int  NOT NULL,
    Coordinatore bool  NOT NULL  DEFAULT false,
    CONSTRAINT RelClassiInsegnanti_pk PRIMARY KEY (IDClasse,IDInsegnante,IDMateria)
);

-- Table RelGenitoriStudenti
CREATE TABLE RelGenitoriStudenti (
    IDGenitore int  NOT NULL,
    IDStudente int  NOT NULL,
    CONSTRAINT RelGenitoriStudenti_pk PRIMARY KEY (IDGenitore)
);

-- Table RelOreLezioneInsegnanti
CREATE TABLE RelOreLezioneInsegnanti (
    IDOraLezione int  NOT NULL,
    IDInsegnante int  NOT NULL,
    CONSTRAINT RelOreLezioneInsegnanti_pk PRIMARY KEY (IDOraLezione,IDInsegnante)
);

-- Table RelStudentiAnniScolastici
CREATE TABLE RelStudentiAnniScolastici (
    IDStudente int  NOT NULL,
    IDAnnoScolastico int  NOT NULL,
    CONSTRAINT RelStudentiAnniScolastici_pk PRIMARY KEY (IDStudente,IDAnnoScolastico)
);

-- Table RelStudentiNote
CREATE TABLE RelStudentiNote (
    IDNoteClasse int  NOT NULL,
    IDStudente int  NOT NULL,
    CONSTRAINT RelStudentiNote_pk PRIMARY KEY (IDNoteClasse,IDStudente)
);

-- Table Scuole
CREATE TABLE Scuole (
    ID int  NOT NULL  AUTO_INCREMENT,
    Nome varchar(50)  NOT NULL,
    Luogo varchar(100)  NOT NULL,
    Tipologia text  NOT NULL,
    CONSTRAINT Scuole_pk PRIMARY KEY (ID)
);

-- Table Studenti
CREATE TABLE Studenti (
    ID int  NOT NULL  AUTO_INCREMENT,
    DataNascita date  NOT NULL,
    CodiceFiscale varchar(16)  NOT NULL,
    Residenza text  NOT NULL,
    EsoneroIRC bool  NOT NULL  DEFAULT false,
    EsoneroEdFisica bool  NOT NULL  DEFAULT false,
    Note text  NULL,
    IDClasse int  NOT NULL,
    IDUtente int  NOT NULL,
    CONSTRAINT Studenti_pk PRIMARY KEY (ID)
);

-- Table Utenti
CREATE TABLE Utenti (
    ID int  NOT NULL  AUTO_INCREMENT,
    Username varchar(50)  NOT NULL,
    Password binary(60)  NOT NULL,
    Nome varchar(50)  NOT NULL,
    Cognome varchar(50)  NOT NULL,
    U2FEnabled bool  NOT NULL  DEFAULT false,
    U2F text  NULL,
    TokenVersions text  NULL,
    UNIQUE INDEX Utenti_ak_1 (Username),
    CONSTRAINT Utenti_pk PRIMARY KEY (ID)
);

-- Table Verifiche
CREATE TABLE Verifiche (
    ID int  NOT NULL  AUTO_INCREMENT,
    Tipologia int  NOT NULL,
    Descrizione text  NOT NULL,
    Data date  NOT NULL,
    CONSTRAINT Verifiche_pk PRIMARY KEY (ID)
);

-- Table Voti
CREATE TABLE Voti (
    ID int  NOT NULL  AUTO_INCREMENT,
    Valutazione decimal(4,2)  NOT NULL,
    FaMedia bool  NOT NULL  DEFAULT true,
    IDStudente int  NOT NULL,
    IDVerifica int  NOT NULL,
    CONSTRAINT Voti_pk PRIMARY KEY (ID)
);





-- foreign keys
-- Reference:  AnniScolastici_Scuole (table: AnniScolastici)


ALTER TABLE AnniScolastici ADD CONSTRAINT AnniScolastici_Scuole FOREIGN KEY AnniScolastici_Scuole (IDScuola)
    REFERENCES Scuole (ID);
-- Reference:  Assenze_Giustificazioni (table: Assenze)


ALTER TABLE Assenze ADD CONSTRAINT Assenze_Giustificazioni FOREIGN KEY Assenze_Giustificazioni (IDGiustificazione)
    REFERENCES Giustificazioni (ID);
-- Reference:  Assenze_Studenti (table: Assenze)


ALTER TABLE Assenze ADD CONSTRAINT Assenze_Studenti FOREIGN KEY Assenze_Studenti (IDStudente)
    REFERENCES Studenti (ID);
-- Reference:  CalendarioVerifiche_Insegnanti (table: Calendario)


ALTER TABLE Calendario ADD CONSTRAINT CalendarioVerifiche_Insegnanti FOREIGN KEY CalendarioVerifiche_Insegnanti (IDInsegnante)
    REFERENCES Insegnanti (ID);
-- Reference:  CalendarioVerifiche_Materie (table: Calendario)


ALTER TABLE Calendario ADD CONSTRAINT CalendarioVerifiche_Materie FOREIGN KEY CalendarioVerifiche_Materie (IDMateria)
    REFERENCES Materie (ID);
-- Reference:  CalendarioVerifiche_OreLezione (table: Calendario)


ALTER TABLE Calendario ADD CONSTRAINT CalendarioVerifiche_OreLezione FOREIGN KEY CalendarioVerifiche_OreLezione (IDOraLezione)
    REFERENCES OreLezione (ID);
-- Reference:  Classi_AnniScolastici (table: Classi)


ALTER TABLE Classi ADD CONSTRAINT Classi_AnniScolastici FOREIGN KEY Classi_AnniScolastici (IDAnnoScolastico)
    REFERENCES AnniScolastici (ID);
-- Reference:  Classi_Scuola (table: Classi)


ALTER TABLE Classi ADD CONSTRAINT Classi_Scuola FOREIGN KEY Classi_Scuola (IDScuola)
    REFERENCES Scuole (ID);
-- Reference:  CollaboratoreScolastico_Utenti (table: CollaboratoriScolastici)


ALTER TABLE CollaboratoriScolastici ADD CONSTRAINT CollaboratoreScolastico_Utenti FOREIGN KEY CollaboratoreScolastico_Utenti (IDUtente)
    REFERENCES Utenti (ID);
-- Reference:  Dispostivi_Utenti (table: Dispositivi)


ALTER TABLE Dispositivi ADD CONSTRAINT Dispostivi_Utenti FOREIGN KEY Dispostivi_Utenti (IDUtente)
    REFERENCES Utenti (ID);
-- Reference:  Genitori_Utenti (table: Genitori)


ALTER TABLE Genitori ADD CONSTRAINT Genitori_Utenti FOREIGN KEY Genitori_Utenti (IDUtente)
    REFERENCES Utenti (ID);
-- Reference:  Giustificazioni_Insegnanti (table: Giustificazioni)


ALTER TABLE Giustificazioni ADD CONSTRAINT Giustificazioni_Insegnanti FOREIGN KEY Giustificazioni_Insegnanti (IDInsegnante)
    REFERENCES Insegnanti (ID);
-- Reference:  IngressiUscite_Giustificazioni (table: IngressiUscite)


ALTER TABLE IngressiUscite ADD CONSTRAINT IngressiUscite_Giustificazioni FOREIGN KEY IngressiUscite_Giustificazioni (IDGiustificazione)
    REFERENCES Giustificazioni (ID);
-- Reference:  IngressiUscite_Studenti (table: IngressiUscite)


ALTER TABLE IngressiUscite ADD CONSTRAINT IngressiUscite_Studenti FOREIGN KEY IngressiUscite_Studenti (IDStudente)
    REFERENCES Studenti (ID);
-- Reference:  Lezioni_Classi (table: Lezioni)


ALTER TABLE Lezioni ADD CONSTRAINT Lezioni_Classi FOREIGN KEY Lezioni_Classi (IDClasse)
    REFERENCES Classi (ID);
-- Reference:  Lezioni_Insegnanti (table: Lezioni)


ALTER TABLE Lezioni ADD CONSTRAINT Lezioni_Insegnanti FOREIGN KEY Lezioni_Insegnanti (IDInsegnante)
    REFERENCES Insegnanti (ID);
-- Reference:  NoteClasse_Classi (table: NoteClasse)


ALTER TABLE NoteClasse ADD CONSTRAINT NoteClasse_Classi FOREIGN KEY NoteClasse_Classi (IDClasse)
    REFERENCES Classi (ID);
-- Reference:  NoteClasse_Professori (table: NoteClasse)


ALTER TABLE NoteClasse ADD CONSTRAINT NoteClasse_Professori FOREIGN KEY NoteClasse_Professori (IDInsegnante)
    REFERENCES Insegnanti (ID);
-- Reference:  OreLezione_Classi (table: OreLezione)


ALTER TABLE OreLezione ADD CONSTRAINT OreLezione_Classi FOREIGN KEY OreLezione_Classi (IDClasse)
    REFERENCES Classi (ID);
-- Reference:  OreLezione_Materie (table: OreLezione)


ALTER TABLE OreLezione ADD CONSTRAINT OreLezione_Materie FOREIGN KEY OreLezione_Materie (IDMateria)
    REFERENCES Materie (ID);
-- Reference:  Professori_Scuole (table: Insegnanti)


ALTER TABLE Insegnanti ADD CONSTRAINT Professori_Scuole FOREIGN KEY Professori_Scuole (IDScuola)
    REFERENCES Scuole (ID);
-- Reference:  Professori_Utenti (table: Insegnanti)


ALTER TABLE Insegnanti ADD CONSTRAINT Professori_Utenti FOREIGN KEY Professori_Utenti (IDUtente)
    REFERENCES Utenti (ID);
-- Reference:  RelClassiComunicazioni_Classi (table: RelClassiComunicazioni)


ALTER TABLE RelClassiComunicazioni ADD CONSTRAINT RelClassiComunicazioni_Classi FOREIGN KEY RelClassiComunicazioni_Classi (IDClasse)
    REFERENCES Classi (ID);
-- Reference:  RelClassiComunicazioni_Comunicazioni (table: RelClassiComunicazioni)


ALTER TABLE RelClassiComunicazioni ADD CONSTRAINT RelClassiComunicazioni_Comunicazioni FOREIGN KEY RelClassiComunicazioni_Comunicazioni (IDComunicazione)
    REFERENCES Comunicazioni (ID);
-- Reference:  RelClassiProfessori4_Classi (table: RelClassiInsegnanti)


ALTER TABLE RelClassiInsegnanti ADD CONSTRAINT RelClassiProfessori4_Classi FOREIGN KEY RelClassiProfessori4_Classi (IDClasse)
    REFERENCES Classi (ID);
-- Reference:  RelClassiProfessori4_Professori (table: RelClassiInsegnanti)


ALTER TABLE RelClassiInsegnanti ADD CONSTRAINT RelClassiProfessori4_Professori FOREIGN KEY RelClassiProfessori4_Professori (IDInsegnante)
    REFERENCES Insegnanti (ID);
-- Reference:  RelClassiProfessori_Materie (table: RelClassiInsegnanti)


ALTER TABLE RelClassiInsegnanti ADD CONSTRAINT RelClassiProfessori_Materie FOREIGN KEY RelClassiProfessori_Materie (IDMateria)
    REFERENCES Materie (ID);
-- Reference:  RelGenitoriStudenti_Genitori (table: RelGenitoriStudenti)


ALTER TABLE RelGenitoriStudenti ADD CONSTRAINT RelGenitoriStudenti_Genitori FOREIGN KEY RelGenitoriStudenti_Genitori (IDGenitore)
    REFERENCES Genitori (ID);
-- Reference:  RelGenitoriStudenti_Studenti (table: RelGenitoriStudenti)


ALTER TABLE RelGenitoriStudenti ADD CONSTRAINT RelGenitoriStudenti_Studenti FOREIGN KEY RelGenitoriStudenti_Studenti (IDStudente)
    REFERENCES Studenti (ID);
-- Reference:  RelOreLezioneInsegnanti_Insegnanti (table: RelOreLezioneInsegnanti)


ALTER TABLE RelOreLezioneInsegnanti ADD CONSTRAINT RelOreLezioneInsegnanti_Insegnanti FOREIGN KEY RelOreLezioneInsegnanti_Insegnanti (IDInsegnante)
    REFERENCES Insegnanti (ID);
-- Reference:  RelOreLezioneInsegnanti_OreLezione (table: RelOreLezioneInsegnanti)


ALTER TABLE RelOreLezioneInsegnanti ADD CONSTRAINT RelOreLezioneInsegnanti_OreLezione FOREIGN KEY RelOreLezioneInsegnanti_OreLezione (IDOraLezione)
    REFERENCES OreLezione (ID);
-- Reference:  RelStudentiAnniScolastici_AnniScolastici (table: RelStudentiAnniScolastici)


ALTER TABLE RelStudentiAnniScolastici ADD CONSTRAINT RelStudentiAnniScolastici_AnniScolastici FOREIGN KEY RelStudentiAnniScolastici_AnniScolastici (IDAnnoScolastico)
    REFERENCES AnniScolastici (ID);
-- Reference:  RelStudentiAnniScolastici_Studenti (table: RelStudentiAnniScolastici)


ALTER TABLE RelStudentiAnniScolastici ADD CONSTRAINT RelStudentiAnniScolastici_Studenti FOREIGN KEY RelStudentiAnniScolastici_Studenti (IDStudente)
    REFERENCES Studenti (ID);
-- Reference:  RelStudentiNote_NoteClasse (table: RelStudentiNote)


ALTER TABLE RelStudentiNote ADD CONSTRAINT RelStudentiNote_NoteClasse FOREIGN KEY RelStudentiNote_NoteClasse (IDNoteClasse)
    REFERENCES NoteClasse (ID);
-- Reference:  RelStudentiNote_Studenti (table: RelStudentiNote)


ALTER TABLE RelStudentiNote ADD CONSTRAINT RelStudentiNote_Studenti FOREIGN KEY RelStudentiNote_Studenti (IDStudente)
    REFERENCES Studenti (ID);
-- Reference:  Studenti_Classi (table: Studenti)


ALTER TABLE Studenti ADD CONSTRAINT Studenti_Classi FOREIGN KEY Studenti_Classi (IDClasse)
    REFERENCES Classi (ID);
-- Reference:  Studenti_Utenti (table: Studenti)


ALTER TABLE Studenti ADD CONSTRAINT Studenti_Utenti FOREIGN KEY Studenti_Utenti (IDUtente)
    REFERENCES Utenti (ID);
-- Reference:  Voti_Studenti (table: Voti)


ALTER TABLE Voti ADD CONSTRAINT Voti_Studenti FOREIGN KEY Voti_Studenti (IDStudente)
    REFERENCES Studenti (ID);
-- Reference:  Voti_Verifiche (table: Voti)


ALTER TABLE Voti ADD CONSTRAINT Voti_Verifiche FOREIGN KEY Voti_Verifiche (IDVerifica)
    REFERENCES Verifiche (ID);



-- End of file.
