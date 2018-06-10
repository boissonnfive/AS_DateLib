---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    DateLib.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Fonctions pour manipuler des dates.
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				- Wikipedia ISO week date : https://en.wikipedia.org/wiki/ISO_week_date
--				- test� sur Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------


(*
Nom				: weekNumberOfDate 
Description		: Renvoi le num�ro de semaine correspondant � la date sp�cifi�e.
maDate        	: (date) date dont on veut le num�ro de semaine.
retour			: (integer) le num�ro de semaine
*)
on numeroDeSemaine(maDate)
	
	if maDate is null then set maDate to (current date)
	
	# log "Date demand�e : " & (date string of maDate)
	
	set anneeEnCours to year of maDate
	set premierJourDeLAnnee to date ("1/1/" & anneeEnCours as text)
	
	# log "Le premier jour de l'ann�e " & anneeEnCours & " �tait le : " & date string of premierJourDeLAnnee
	
	if (weekday of premierJourDeLAnnee as text) is in {"Monday", "Tuesday", "Wednesday", "Thursday"} then
		set semaineEnPlus to 1
		-- log (first word of date string of premierJourDeLAnnee) & " => On ajoute une semaine en plus."
	else
		set semaineEnPlus to 0
		-- log (first word of date string of premierJourDeLAnnee) & " => On n'ajoute pas de semaine suppl�mentaire."
	end if
	
	-- log "Jour : " & first word of (date string of maDate) & " (" & numeroDeJour(weekday of maDate as integer) & ")"
	-- log "Jour : " & first word of (date string of premierJourDeLAnnee) & " (" & numeroDeJour(weekday of premierJourDeLAnnee as integer) & ")"
	
	set dmin to (premierJourDeLAnnee + (8 - numeroDeJour(weekday of premierJourDeLAnnee as integer)) * days)
	# log "On va au premier lundi apr�s le 1er janvier : " & date string of dmin & " (+" & (8 - numeroDeJour(weekday of premierJourDeLAnnee as integer)) & ")"
	
	set dmax to maDate - ((numeroDeJour(weekday of maDate as integer) - 1) * days)
	# log "On revient au lundi de la semaine recherch�e : " & date string of dmax & " (-" & (numeroDeJour(weekday of maDate as integer) - 1) & ")"
	
	# log "Nombre de semaines compl�tes interm�diaires : " & ((dmax - dmin) div weeks)
	# log "On ajoute la derni�re semaine : " & ((dmax - dmin) div weeks) + 1
	# log "On ajoute la premi�re semaine ou pas (" & (first word of date string of premierJourDeLAnnee) & " => +" & semaineEnPlus & ") : " & ((dmax - dmin) div weeks) + 1 + semaineEnPlus
	
	return ((dmax - dmin) div weeks) + 1 + semaineEnPlus
	
end numeroDeSemaine


(*
Nom				: numeroDeJour 
Description		: Renvoi le num�ro de jour quand la semaine commence au Lundi.
jour				: (integer) num�ro de jour AppleScript
retour			: (integer) le num�ro de jour quand la semaine commence au Lundi.
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
Description		: Renvoi la date du premier jour de l'ann�e sp�cifi�e.
annee 	       	: (date) ann�e recherch�e
retour			: (date) la date du premier jour de l'ann�e sp�cifi�e.
*)
on premierJourDeLAnnee(annee)
	return date ("1/1/" & annee as text)
end premierJourDeLAnnee


(*
Nom				: nombreDeJoursEn 
Description		: Renvoi le nombre de jours dans l'ann�e sp�cifi�e.
annee 	       	: (date) ann�e recherch�e
retour			: (integer) le nombre de jour de l'ann�e sp�cifi�e.
*)
on nombreDeJoursEn(annee)
	return (premierJourDeLAnnee(annee + 1) - premierJourDeLAnnee(annee)) div days
end nombreDeJoursEn


(*
Nom				: anneeBissextile 
Description		: Dit si l'ann�e en param�tre est bissextile ou pas.
annee 	       	: (date) ann�e recherch�e
retour			: True si l'ann�e est bissextile, false sinon.
*)
on anneeBissextile(annee)
	
	set bissextile to false
	
	set maDate to date ("29/02/" & annee as text)
	if (month of maDate) is February then set bissextile to true
	
	return bissextile
	
end anneeBissextile



-----------------------------------------------------------------------------------------------------------
--                                                     TESTS
-----------------------------------------------------------------------------------------------------------


-- Pour tester cette biblioth�que :

-- 1�) Installez la biblioth�que dans le dossier : ~/Library/Script Libraries/
-- 2�) Cr�ez un nouveau fichier script contenant le code suivant :

(*
tell script "Date Lib"
	
	set maDate to (current date)
	
	repeat with i from 0 to 99
		set numeroSemaine to numeroDeSemaine(maDate)
		set numeroSemaineShell to do shell script "date " & "-v+" & i & "y +%V"
		# log maDate
		# log numeroSemaine & " = " & numeroSemaineShell
		
		if (numeroSemaine as integer) � (numeroSemaineShell as integer) then
			error "Erreur dans le num�ro de semaine pour la date : " & maDate
		end if
		
		set year of maDate to (get (year of maDate) + 1)
	end repeat
	
	
	
	set trace to ""
	set trace to trace & "Aujourd'hui : " & date string of (current date)
	set trace to trace & return & "Num�ro de semaine : " & numeroDeSemaine(current date)
	set trace to trace & return & "Hier : " & date string of (hier())
	set trace to trace & return & "Demain : " & date string of (demain())
	set trace to trace & return & "Premier jour de l'ann�e : " & date string of (premierJourDeLAnnee(year of (current date)))
	set trace to trace & return & ("Nombre de jours en " & (year of (current date)) as text) & " : " & nombreDeJoursEn(year of (current date))
	set trace to trace & return & "Ann�e bissextile ? (" & (year of (current date) as text) & ") : " & anneeBissextile(year of (current date))
	
	
	display alert trace
	log trace
	
	
end tell

*)


-----------------------------------------------------------------------------------------------------------
--                                                     FIN
-----------------------------------------------------------------------------------------------------------


# Algorithme de la fonction numeroDeSemaine
# -----------------------------------------

# L'id�e est de compter le nombre de semaines compl�tes entre le premier jour de l'ann�e et le jour propos�. Il faut donc enlever la premi�re semaine et la semaine en cours qui peuvent �tre incompl�tes. Pour cela, il faut ajouter des jours � la premi�re semaine pour passer au lundi de la semaine d'apr�s et enlever des jours � la semaine en cours pour revenir au lundi. Puis je fais la diff�rence entre les dates obtenues et je divise par 7. J'obtiens le nombre de semaines interm�diaires compl�tes. � cela je rajoute une semaine pour la semaine en cours + 1 semaine si le premier jour de l'ann�e est compris entre lundi et jeudi inclu.

# 1. Je r�cup�re la date du premier jour de l'ann�e
# 2. Je r�cup�re la date propos�e
# 3. Je r�cup�re le jour de la premi�re semaine pour savoir combien de jour je dois ajouter pour passer � la semaine suivante. Ex : un lundi => 7 jours � ajouter. Un jeudi => 8- 4 = 4 jours � ajouter. => J'obtiens une date dmin.
# 4. Je r�cup�re le nombre de jours �coul�s dans la semaine en cours et j'enl�ve des jours pour revenir au plus proche lundi. => J'obtiens une date dmax
# 5.	Je calcule la diff�rence entre ces deux dates
#		J'ajoute 1 pour la derni�re semaine
#		J'ajoute 1 ou 0 selon que le premier jour de l'ann�e est compris entre lundi et jeudi

