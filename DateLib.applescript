---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    DateLib.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Fonctions pour manipuler des dates.
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				- Wikipedia ISO week date : https://en.wikipedia.org/wiki/ISO_week_date
--				- testé sur Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------


(*
Nom				: weekNumberOfDate 
Description		: Renvoi le numéro de semaine correspondant à la date spécifiée.
maDate        	: (date) date dont on veut le numéro de semaine.
retour			: (integer) le numéro de semaine
*)
on numeroDeSemaine(maDate)
	
	if maDate is null then set maDate to (current date)
	
	# log "Date demandée : " & (date string of maDate)
	
	set anneeEnCours to year of maDate
	set premierJourDeLAnnee to date ("1/1/" & anneeEnCours as text)
	
	# log "Le premier jour de l'année " & anneeEnCours & " était le : " & date string of premierJourDeLAnnee
	
	if (weekday of premierJourDeLAnnee as text) is in {"Monday", "Tuesday", "Wednesday", "Thursday"} then
		set semaineEnPlus to 1
		-- log (first word of date string of premierJourDeLAnnee) & " => On ajoute une semaine en plus."
	else
		set semaineEnPlus to 0
		-- log (first word of date string of premierJourDeLAnnee) & " => On n'ajoute pas de semaine supplémentaire."
	end if
	
	-- log "Jour : " & first word of (date string of maDate) & " (" & numeroDeJour(weekday of maDate as integer) & ")"
	-- log "Jour : " & first word of (date string of premierJourDeLAnnee) & " (" & numeroDeJour(weekday of premierJourDeLAnnee as integer) & ")"
	
	set dmin to (premierJourDeLAnnee + (8 - numeroDeJour(weekday of premierJourDeLAnnee as integer)) * days)
	# log "On va au premier lundi après le 1er janvier : " & date string of dmin & " (+" & (8 - numeroDeJour(weekday of premierJourDeLAnnee as integer)) & ")"
	
	set dmax to maDate - ((numeroDeJour(weekday of maDate as integer) - 1) * days)
	# log "On revient au lundi de la semaine recherchée : " & date string of dmax & " (-" & (numeroDeJour(weekday of maDate as integer) - 1) & ")"
	
	# log "Nombre de semaines complètes intermédiaires : " & ((dmax - dmin) div weeks)
	# log "On ajoute la dernière semaine : " & ((dmax - dmin) div weeks) + 1
	# log "On ajoute la première semaine ou pas (" & (first word of date string of premierJourDeLAnnee) & " => +" & semaineEnPlus & ") : " & ((dmax - dmin) div weeks) + 1 + semaineEnPlus
	
	return ((dmax - dmin) div weeks) + 1 + semaineEnPlus
	
end numeroDeSemaine


(*
Nom				: numeroDeJour 
Description		: Renvoi le numéro de jour quand la semaine commence au Lundi.
jour				: (integer) numéro de jour AppleScript
retour			: (integer) le numéro de jour quand la semaine commence au Lundi.
*)
on numeroDeJour(jour)
	if jour is 1 then
		return 7
	else
		return jour - 1
	end if
end numeroDeJour


(*
Nom				: hier 
Description		: Renvoi la date d'hier.
retour			: (date) la date d'hier.
*)
on hier()
	return (current date) - 1 * days
end hier


(*
Nom				: demain 
Description		: Renvoi la date de demain.
retour			: (date) la date de demain.
*)
on demain()
	return (current date) + 1 * days
end demain


(*
Nom				: premierJourDeLAnnee 
Description		: Renvoi la date du premier jour de l'année spécifiée.
annee 	       	: (date) année recherchée
retour			: (date) la date du premier jour de l'année spécifiée.
*)
on premierJourDeLAnnee(annee)
	return date ("1/1/" & annee as text)
end premierJourDeLAnnee


(*
Nom				: nombreDeJoursEn 
Description		: Renvoi le nombre de jours dans l'année spécifiée.
annee 	       	: (date) année recherchée
retour			: (integer) le nombre de jour de l'année spécifiée.
*)
on nombreDeJoursEn(annee)
	return (premierJourDeLAnnee(annee + 1) - premierJourDeLAnnee(annee)) div days
end nombreDeJoursEn


(*
Nom				: anneeBissextile 
Description		: Dit si l'année en paramètre est bissextile ou pas.
annee 	       	: (date) année recherchée
retour			: True si l'année est bissextile, false sinon.
*)
on anneeBissextile(annee)
	
	set bissextile to false
	
	set maDate to date ("29/02/" & annee as text)
	if (month of maDate) is February then set bissextile to true
	
	return bissextile
	
end anneeBissextile


(*
Nom				: initialiseTemps 
Description		: Initialise l'heure de la date à 00h00 et 0 secondes.
maDate 	       	: (date) date dont on veut initialiser l'heure.
retour			: (date) La même date mais à 00h00 et 0 secondes.
Remarque		: Utile quand on veut ajouter une heure précise à une date
Exemple			: set maDate to (current date)
				  set maDateA0Heure to initialiseTemps(maDate)
				  set maDateRDV to maDateA0Heure + 9 * hours + 30 * minutes 
*)
on initialiseTemps(maDate)
	tell maDate to set maDateAMinuit to it - (its time)
	return maDateAMinuit
end initialiseTemps



(*
Nom				: jourEnFrancais 
Description		: Renvoi le nom du jour de la semaine en français.
maDate 	       	: (date) date dont on veut le jour de la semaine.
retour			: (text) Le nom du jour de la semaine.
Remarque		: Par défaut, AppleScript renvoi le nom du jour en anglais.
*)
on jourEnFrancais(maDate)
	set chaineDate to maDate as string
	get 1st word of chaineDate
end jourEnFrancais


(*
Nom				: moisEnFrancais 
Description		: Renvoi le nom du mois en français.
maDate 	       	: (date) date dont on veut le mois en français.
retour			: (text) Le nom du mois.
Remarque		: Par défaut, AppleScript renvoi le nom du mois en anglais.
*)
on moisEnFrancais(maDate)
	set chaineDate to maDate as string
	get 3rd word of chaineDate
end moisEnFrancais

-----------------------------------------------------------------------------------------------------------
--                                                     TESTS
-----------------------------------------------------------------------------------------------------------


-- Pour tester cette bibliothèque :

-- 1°) Installez la bibliothèque dans le dossier : ~/Library/Script Libraries/
-- 2°) Créez un nouveau fichier script contenant le code suivant :

(*
tell script "Date Lib"
	
	set maDate to (current date)
	
	repeat with i from 0 to 99
		set numeroSemaine to numeroDeSemaine(maDate)
		set numeroSemaineShell to do shell script "date " & "-v+" & i & "y +%V"
		# log maDate
		# log numeroSemaine & " = " & numeroSemaineShell
		
		if (numeroSemaine as integer) ≠ (numeroSemaineShell as integer) then
			error "Erreur dans le numéro de semaine pour la date : " & maDate
		end if
		
		set year of maDate to (get (year of maDate) + 1)
	end repeat
	
	
	
	set trace to ""
	set trace to trace & "Aujourd'hui : " & date string of (current date)
	set trace to trace & return & "Heure : " & time string of (current date)
	set trace to trace & return & "Nom du jour : " & jourEnFrancais(current date)
	set trace to trace & return & "Nom du mois : " & moisEnFrancais(current date)
	set trace to trace & return & "Numéro de semaine : " & numeroDeSemaine(current date)
	set trace to trace & return & "Hier : " & date string of (hier())
	set trace to trace & return & "Demain : " & date string of (demain())
	set trace to trace & return & "Premier jour de l'année : " & date string of (premierJourDeLAnnee(year of (current date)))
	set trace to trace & return & ("Nombre de jours en " & (year of (current date)) as text) & " : " & nombreDeJoursEn(year of (current date))
	set trace to trace & return & "Année bissextile ? (" & (year of (current date) as text) & ") : " & anneeBissextile(year of (current date))
	set trace to trace & return & "Ma date à 00h00 : " & initialiseTemps((current date))
	
	
	display alert trace
	log trace
	
	
end tell

*)


-----------------------------------------------------------------------------------------------------------
--                                                     FIN
-----------------------------------------------------------------------------------------------------------


# Algorithme de la fonction numeroDeSemaine
# -----------------------------------------

# L'idée est de compter le nombre de semaines complètes entre le premier jour de l'année et le jour proposé. Il faut donc enlever la première semaine et la semaine en cours qui peuvent être incomplètes. Pour cela, il faut ajouter des jours à la première semaine pour passer au lundi de la semaine d'après et enlever des jours à la semaine en cours pour revenir au lundi. Puis je fais la différence entre les dates obtenues et je divise par 7. J'obtiens le nombre de semaines intermédiaires complètes. À cela je rajoute une semaine pour la semaine en cours + 1 semaine si le premier jour de l'année est compris entre lundi et jeudi inclu.

# 1. Je récupère la date du premier jour de l'année
# 2. Je récupère la date proposée
# 3. Je récupère le jour de la première semaine pour savoir combien de jour je dois ajouter pour passer à la semaine suivante. Ex : un lundi => 7 jours à ajouter. Un jeudi => 8- 4 = 4 jours à ajouter. => J'obtiens une date dmin.
# 4. Je récupère le nombre de jours écoulés dans la semaine en cours et j'enlève des jours pour revenir au plus proche lundi. => J'obtiens une date dmax
# 5.	Je calcule la différence entre ces deux dates
#		J'ajoute 1 pour la dernière semaine
#		J'ajoute 1 ou 0 selon que le premier jour de l'année est compris entre lundi et jeudi

