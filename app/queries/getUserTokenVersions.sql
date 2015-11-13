-- *
-- check Auth-Token header

SELECT
	TokenVersions

FROM Utenti

WHERE ID = ? AND Username = ?
