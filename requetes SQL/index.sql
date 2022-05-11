--Quels sont les numéros (id_livre) des livres qui n'ont pas été rendu à la biblothèque
SELECT id_livre FROM emprunt WHERE date_rendu IS NULL;
+----------+
| id_livre |
+----------+
|      105 |
|      100 |
+----------+


--REQUETES IMBRIQUES

--Nous aimerions connaitre les n° des livres que Chloé à emprunté :

SELECT id_livre FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'chloé');
+----------+
| id_livre |
+----------+
|      100 |
|      105 |
+----------+

--Nous aimerions connaitre les prénoms qui ont emprunté un livre le 11/12/2016
SELECT prenom FROM abonne WHERE id_abonne IN (SELECT id_abonne FROM emprunt WHERE date_sortie = '2016-12-11');
+--------+
| prenom |
+--------+
| Chloe  |
+--------+

--Combien de livre Guillaume a emprunté à la bibliotheque
SELECT COUNT(*) AS nombre_de_livres_empruntes_par_Guillaume FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Guillaume');
+----------------------------------------+
| nombre_de_livre_emprunté_par_Guillaume |
+----------------------------------------+
|                                      2 |
+----------------------------------------+

--Nous aimerions connaitre la liste des abonnés ayant déja emprunté un livre d'Alphonse Daudet
SELECT prenom FROM abonne WHERE id_abonne IN (SELECT id_abonne FROM emprunt WHERE id_livre IN (SELECT id_livre FROM livre WHERE auteur = 'ALPHONSE DAUDET'));
+--------+
| prenom |
+--------+
| Laura  |
+--------+

--Nous aimerions connaitre les titres des livres que Chloe a emprunté
SELECT titre FROM livre WHERE id_livre IN (SELECT id_livre FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe'));
+-------------------------+
| titre                   |
+-------------------------+
| Une vie                 |
| Les Trois Mousquetaires |
+-------------------------+

--Nous aimerions connaitre les titres des livres que Chloe n'a pas emprunté
SELECT titre FROM livre WHERE id_livre NOT IN (SELECT id_livre FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe'));
+-----------------+
| titre           |
+-----------------+
| Bel-Ami         |
| Le père Goriot  |
| Le Petit chose  |
| La Reine Margot |
+-----------------+

--Nous aimerions connaitre les titres des livres que Chloe n'a pas encore rendu
SELECT titre FROM livre WHERE id_livre IN (SELECT id_livre FROM emprunt WHERE date_rendu IS NULL AND id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe'));
+-------------------------+
| titre                   |
+-------------------------+
| Les Trois Mousquetaires |
+-------------------------+


--REQUETES en jointure

--Nous aimerions connaitres les dates de sortie et les dates de rendu pour l'abonné Guillaume.
SELECT prenom, date_sortie, date_rendu FROM abonne, emprunt WHERE emprunt.id_abonne = abonne.id_abonne AND prenom = 'Guillaume';
+-----------+-------------+------------+
| prenom    | date_sortie | date_rendu |
+-----------+-------------+------------+
| Guillaume | 2016-12-07  | 2016-12-11 |
| Guillaume | 2016-12-15  | 2016-12-30 |
+-----------+-------------+------------+

--Nous aimerions conntaitre les dates de sortie et les dates de rendu pour les livre écrit par Alphone Daudet
SELECT  date_sortie, date_rendu, auteur, titre 
FROM livre, emprunt 
WHERE livre.id_livre = emprunt.id_livre 
AND auteur = 'ALPHONSE DAUDET'; 

--Qui a emprunté le livre "une vie" sur l'année 2016 ?
SELECT  prenom, auteur, date_sortie, date_rendu, titre
FROM abonne, livre, emprunt 
WHERE abonne.id_abonne = emprunt.id_abonne
AND emprunt.id_livre = livre.id_livre 
AND date_sortie LIKE '2016%'
AND titre = 'une vie'; 

Nous aimerions connaitre le nombre de livre emprunté par chaque abonné
SELECT  COUNT(*) AS nombre_de_livres_empruntes_par, prenom
FROM abonne, emprunt 
WHERE abonne.id_abonne = emprunt.id_abonne
GROUP BY prenom
ORDER BY nombre_de_livres_empruntes_par DESC;
+--------------------------------+-----------+
| nombre_de_livres_empruntes_par | prenom    |
+--------------------------------+-----------+
|                              3 | Benoit    |
|                              2 | Chloe     |
|                              2 | Guillaume |
|                              1 | Laura     |
+--------------------------------+-----------+
SELECT  prenom
FROM abonne, emprunt 
WHERE abonne.id_abonne = emprunt.id_abonne
GROUP BY prenom
ORDER BY COUNT(id_emprunt) DESC
limit 1;
+--------+
| prenom |
+--------+
| Benoit |
+--------+

--Nous aimerions connaitre le nombre de livre qu'il reste à rendre par abonné
SELECT  COUNT(*) AS nombre, prenom
FROM abonne, emprunt 
WHERE abonne.id_abonne = emprunt.id_abonne
AND date_rendu IS NULL
GROUP BY prenom;
+--------+--------+
| nombre | prenom |
+--------+--------+
|      1 | Benoit |
|      1 | Chloe  |
+--------+--------+

--Qui a emprunté Quoi et Quand? 
SELECT  prenom, titre, auteur,  date_sortie, date_rendu
FROM abonne, livre, emprunt 
WHERE abonne.id_abonne = emprunt.id_abonne
AND emprunt.id_livre = livre.id_livre ; 
+-------------------------+-------------------+-----------+-------------+------------+
| titre                   | auteur            | prenom    | date_sortie | date_rendu |
+-------------------------+-------------------+-----------+-------------+------------+
| Une vie                 | GUY DE MAUPASSANT | Guillaume | 2016-12-07  | 2016-12-11 |
| Bel-Ami                 | GUY DE MAUPASSANT | Benoit    | 2016-12-07  | 2016-12-18 |
| Une vie                 | GUY DE MAUPASSANT | Chloe     | 2016-12-11  | 2016-12-19 |
| Le Petit chose          | ALPHONSE DAUDET   | Laura     | 2016-12-12  | 2016-12-22 |
| La Reine Margot         | ALEXANDRE DUMAS   | Guillaume | 2016-12-15  | 2016-12-30 |
| Les Trois Mousquetaires | ALEXANDRE DUMAS   | Benoit    | 2017-01-02  | 2017-01-15 |
| Les Trois Mousquetaires | ALEXANDRE DUMAS   | Chloe     | 2017-02-15  | NULL       |
| Une vie                 | GUY DE MAUPASSANT | Benoit    | 2017-02-20  | NULL       |
+-------------------------+-------------------+-----------+-------------+------------+

--Affichez la liste des abonnés e des id_livre qu'ils on emprunté
SELECT prenom, id_livre
FROM emprunt, abonne
WHERE emprunt.id_abonne = abonne.id_abonne
ORDER BY prenom;
+-----------+----------+
| prenom    | id_livre |
+-----------+----------+
| Benoit    |      100 |
| Benoit    |      101 |
| Benoit    |      105 |
| Chloe     |      100 |
| Chloe     |      105 |
| Guillaume |      100 |
| Guillaume |      104 |
| Laura     |      103 |
+-----------+----------+

--Ajoutez vous dans la liste des abonnés
INSERT INTO abonne ( prenom) VALUES ('Alexandre');
SELECT * FROM abonne;
+-----------+-----------+
| id_abonne | prenom    |
+-----------+-----------+
|         1 | Guillaume |
|         2 | Benoit    |
|         3 | Chloe     |
|         4 | Laura     |
|         5 | Alexandre |
+-----------+-----------+


--Affichez tous les livres sans exception puis les id_abonne (ou prenom en allant jusqu'à la 3eme table) qui les ont emprunté si c'est le cas
SELECT auteur, titre, id_abonne
FROM livre
LEFT JOIN emprunt USING (id_livre);
+-------------------+-------------------------+-----------+
| auteur            | titre                   | id_abonne |
+-------------------+-------------------------+-----------+
| GUY DE MAUPASSANT | Une vie                 |         1 |
| GUY DE MAUPASSANT | Bel-Ami                 |         2 |
| GUY DE MAUPASSANT | Une vie                 |         3 |
| ALPHONSE DAUDET   | Le Petit chose          |         4 |
| ALEXANDRE DUMAS   | La Reine Margot         |         1 |
| ALEXANDRE DUMAS   | Les Trois Mousquetaires |         2 |
| ALEXANDRE DUMAS   | Les Trois Mousquetaires |         3 |
| GUY DE MAUPASSANT | Une vie                 |         2 |
| HONORE DE BALZAC  | Le père Goriot          |      NULL |
+-------------------+-------------------------+-----------+

SELECT prenom, auteur, titre, date_sortie 
FROM abonne
RIGHT JOIN emprunt USING (id_abonne)
RIGHT JOIN livre USING (id_livre);
+-----------+-------------------+-------------------------+-------------+
| prenom    | auteur            | titre                   | date_sortie |
+-----------+-------------------+-------------------------+-------------+
| Guillaume | GUY DE MAUPASSANT | Une vie                 | 2016-12-07  |
| Chloe     | GUY DE MAUPASSANT | Une vie                 | 2016-12-11  |
| Benoit    | GUY DE MAUPASSANT | Une vie                 | 2017-02-20  |
| Benoit    | GUY DE MAUPASSANT | Bel-Ami                 | 2016-12-07  |
| NULL      | HONORE DE BALZAC  | Le père Goriot          | NULL        |
| Laura     | ALPHONSE DAUDET   | Le Petit chose          | 2016-12-12  |
| Guillaume | ALEXANDRE DUMAS   | La Reine Margot         | 2016-12-15  |
| Benoit    | ALEXANDRE DUMAS   | Les Trois Mousquetaires | 2017-01-02  |
| Chloe     | ALEXANDRE DUMAS   | Les Trois Mousquetaires | 2017-02-15  |
+-----------+-------------------+-------------------------+-------------+











