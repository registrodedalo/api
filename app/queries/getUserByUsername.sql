SELECT
	ID,
	Username,
	Password,
	TokenVersions

FROM Utenti

WHERE Username = ?
