-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Client: 127.0.0.1
-- Généré le: Lun 22 Septembre 2014 à 11:54
-- Version du serveur: 5.5.32
-- Version de PHP: 5.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `trivia`
--
CREATE DATABASE IF NOT EXISTS `trivia` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `trivia`;

-- --------------------------------------------------------

--
-- Structure de la table `domaine`
--

CREATE TABLE IF NOT EXISTS `domaine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idmonde` int(11) NOT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `FK_appartenir` (`idmonde`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `joueur`
--

CREATE TABLE IF NOT EXISTS `joueur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idmonde` int(11) NOT NULL,
  `nom` varchar(40) NOT NULL,
  `prenom` varchar(40) NOT NULL,
  `mail` varchar(255) NOT NULL,
  `login` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `niveau` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_travailler` (`idmonde`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `monde`
--

CREATE TABLE IF NOT EXISTS `monde` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `partie`
--

CREATE TABLE IF NOT EXISTS `partie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idJoueurEnCours` int(11) DEFAULT NULL,
  `idJoueur1` int(11) NOT NULL,
  `idJoueur2` int(11) DEFAULT NULL,
  `dernierCoup` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_doitJouer` (`idJoueur1`),
  KEY `FK_participer1` (`idJoueur2`),
  KEY `FK_participer2` (`idJoueurEnCours`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `probleme`
--

CREATE TABLE IF NOT EXISTS `probleme` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `question`
--

CREATE TABLE IF NOT EXISTS `question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iddomaine` int(11) NOT NULL,
  `idjoueur` int(11) NOT NULL,
  `libelle` text,
  `validation` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_definir` (`iddomaine`),
  KEY `FK_soumettre` (`idjoueur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `reponse`
--

CREATE TABLE IF NOT EXISTS `reponse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idquestion` int(11) NOT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `estBonne` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_correspondre` (`idquestion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `score`
--

CREATE TABLE IF NOT EXISTS `score` (
  `idpartie` int(11) NOT NULL,
  `idjoueur` int(11) NOT NULL,
  `iddomaine` int(11) NOT NULL,
  PRIMARY KEY (`idpartie`,`idjoueur`,`iddomaine`),
  KEY `FK_score` (`iddomaine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `signalement`
--

CREATE TABLE IF NOT EXISTS `signalement` (
  `idprobleme` int(11) NOT NULL,
  `idjoueur` int(11) NOT NULL,
  `idquestion` int(11) NOT NULL,
  `dateS` date DEFAULT NULL,
  PRIMARY KEY (`idprobleme`,`idjoueur`,`idquestion`),
  KEY `FK_signalement` (`idjoueur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `statistiques`
--

CREATE TABLE IF NOT EXISTS `statistiques` (
  `iddomaine` int(11) NOT NULL,
  `idjoueur` int(11) NOT NULL,
  `nbBonnesReponses` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`iddomaine`,`idjoueur`),
  KEY `idjoueur` (`idjoueur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `domaine`
--
ALTER TABLE `domaine`
  ADD CONSTRAINT `FK_appartenir` FOREIGN KEY (`idmonde`) REFERENCES `monde` (`id`);

--
-- Contraintes pour la table `joueur`
--
ALTER TABLE `joueur`
  ADD CONSTRAINT `FK_travailler` FOREIGN KEY (`idmonde`) REFERENCES `monde` (`id`);

--
-- Contraintes pour la table `partie`
--
ALTER TABLE `partie`
  ADD CONSTRAINT `FK_participer2` FOREIGN KEY (`idJoueurEnCours`) REFERENCES `joueur` (`id`),
  ADD CONSTRAINT `FK_doitJouer` FOREIGN KEY (`idJoueur1`) REFERENCES `joueur` (`id`),
  ADD CONSTRAINT `FK_participer1` FOREIGN KEY (`idJoueur2`) REFERENCES `joueur` (`id`);

--
-- Contraintes pour la table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `FK_soumettre` FOREIGN KEY (`idjoueur`) REFERENCES `joueur` (`id`),
  ADD CONSTRAINT `FK_definir` FOREIGN KEY (`iddomaine`) REFERENCES `domaine` (`id`);

--
-- Contraintes pour la table `reponse`
--
ALTER TABLE `reponse`
  ADD CONSTRAINT `FK_correspondre` FOREIGN KEY (`idquestion`) REFERENCES `question` (`id`);

--
-- Contraintes pour la table `score`
--
ALTER TABLE `score`
  ADD CONSTRAINT `FK_score` FOREIGN KEY (`iddomaine`) REFERENCES `domaine` (`id`);

--
-- Contraintes pour la table `signalement`
--
ALTER TABLE `signalement`
  ADD CONSTRAINT `signalement_ibfk_1` FOREIGN KEY (`idprobleme`) REFERENCES `probleme` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_signalement` FOREIGN KEY (`idjoueur`) REFERENCES `joueur` (`id`);

--
-- Contraintes pour la table `statistiques`
--
ALTER TABLE `statistiques`
  ADD CONSTRAINT `statistiques_ibfk_1` FOREIGN KEY (`idjoueur`) REFERENCES `joueur` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_statistiques` FOREIGN KEY (`iddomaine`) REFERENCES `domaine` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
