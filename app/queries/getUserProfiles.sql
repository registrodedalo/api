-- /auth/me

SELECT
	Username,
	
	Nome,
	
	Cognome,
	
	CASE
		WHEN (SELECT COUNT(*) FROM Insegnanti WHERE IDUtente = ?) > 0 THEN 1 ELSE 0
	END AS 'Insegnante',
	
	CASE
		WHEN (SELECT COUNT(*) FROM Studenti WHERE IDUtente = ?) > 0 THEN 1 ELSE 0
	END AS 'Studente',
	
	CASE
		WHEN (SELECT COUNT(*) FROM CollaboratoriScolastici WHERE IDUtente = ?) > 0 THEN 1 ELSE 0
	END AS 'Collaboratore'

FROM Utenti

WHERE ID = ?
