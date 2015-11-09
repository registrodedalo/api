SELECT
	Classi.ID AS ID,
	Classi.Nome AS Nome,
	Classi.Anno AS Anno,
	AnniScolastici.ID AS 'AnnoScolastico.ID',
	AnniScolastici.Nome AS 'AnnoScolastico.Nome',
	AnniScolastici.DataInizio AS 'AnnoScolastico.Inizio',
	AnniScolastici.DataFine AS 'AnnoScolastico.Fine',
	Scuole.ID AS 'Scuola.ID',
	Scuole.Nome AS 'Scuola.Nome'

FROM Classi

INNER JOIN Scuole
	ON Classi.IDScuola = Scuole.ID

INNER JOIN AnniScolastici
	ON Classi.IDScuola = AnniScolastici.ID
