/*use baseball;                 /*  local db */
use heroku_e836e55a7a50c1c; /* cloud db */

/* user roles */
CREATE TABLE user_roles (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   role VARCHAR(256) NOT NULL,
   PRIMARY KEY(id)
);

INSERT INTO user_roles (role)
   VALUES("director");
INSERT INTO user_roles (role)
   VALUES("guest");

/* users */
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(64) NOT NULL,
	last_name VARCHAR(64) NOT NULL,
	email VARCHAR(128) NOT NULL,
	hash VARCHAR(512) NOT NULL,
	phone VARCHAR(20),
	is_mobile TINYINT(1) DEFAULT 0,
	role_id INT UNSIGNED NOT NULL,
	
	PRIMARY KEY(id),
	FOREIGN KEY users_role_id_fk (role_id)
      REFERENCES user_roles(id),
    UNIQUE KEY email_uk (email)
);

/* locations */
CREATE TABLE locations (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   name VARCHAR(256) NOT NULL,
   street_number INT,
   street_name VARCHAR(256),
   city VARCHAR(256),
   state VARCHAR(64),
   zip INT,
   website VARCHAR(512),

   PRIMARY KEY (id)
);


/* players */
CREATE TABLE players (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   first_name VARCHAR(256) NOT NULL,
   middle_name VARCHAR(256),
   last_name VARCHAR(256) NOT NULL,
   date_of_birth DATE NOT NULL,
   birth_cert_file_location VARCHAR(512),

   PRIMARY KEY (id)
);

/* stables */
CREATE TABLE stables (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   name VARCHAR(256) NOT NULL,
   website VARCHAR(512),

   PRIMARY KEY (id)
);

/* age groups */
CREATE TABLE age_groups (
   age_group VARCHAR(3) NOT NULL,

   PRIMARY KEY (age_group)
);

INSERT INTO age_groups VALUES ("5U");
INSERT INTO age_groups VALUES ("6U");
INSERT INTO age_groups VALUES ("7U");
INSERT INTO age_groups VALUES ("8U");
INSERT INTO age_groups VALUES ("9U");
INSERT INTO age_groups VALUES ("10U");
INSERT INTO age_groups VALUES ("11U");
INSERT INTO age_groups VALUES ("12U");
INSERT INTO age_groups VALUES ("13U");
INSERT INTO age_groups VALUES ("14U");
INSERT INTO age_groups VALUES ("15U");
INSERT INTO age_groups VALUES ("16U");
INSERT INTO age_groups VALUES ("17U");
INSERT INTO age_groups VALUES ("18U");

/* levels */
CREATE TABLE levels (
   level VARCHAR(5) NOT NULL,

   PRIMARY KEY (level)
);

INSERT INTO levels VALUES ("AA");
INSERT INTO levels VALUES ("AAA");
INSERT INTO levels VALUES ("Major");

/* teams */
CREATE TABLE teams (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   name VARCHAR(256) NOT NULL,
   stable_id INT UNSIGNED,
   age_group VARCHAR(3) NOT NULL,
   level VARCHAR(5) NOT NULL,
   year VARCHAR(4) NOT NULL,

   PRIMARY KEY (id),
   FOREIGN KEY teams_stable_id_fk (stable_id) 
      REFERENCES stables(id)
      ON DELETE CASCADE,
   FOREIGN KEY teams_age_group_fk (age_group)
      REFERENCES age_groups(age_group),
   FOREIGN KEY teams_level_fk (level)
      REFERENCES levels(level)
);

/* rosters */
CREATE TABLE rosters (
   team_id INT UNSIGNED NOT NULL,
   player_id INT UNSIGNED NOT NULl,

   PRIMARY KEY (team_id, player_id),
   FOREIGN KEY rosters_team_id_fk (team_id)
      REFERENCES teams(id)
      ON DELETE CASCADE,
   FOREIGN KEY rosters_player_id_fk (player_id)
      REFERENCES players(id)
      ON DELETE CASCADE
);

CREATE TABLE formats (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	description VARCHAR(256) NOT NULL,

    PRIMARY KEY(id)
);

INSERT INTO formats (description) values("Pool Play Into Single Elimination");
INSERT INTO formats (description) values("Pool Play Into Double Elimination");

  
/* main tournaments table */
CREATE TABLE tournaments (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   name VARCHAR(256) NOT NULL,
   start_date DATE NOT NULL, 
   end_date DATE NOT NULL,
   director_id INT UNSIGNED NOT NULL,

   PRIMARY KEY (id),
   FOREIGN KEY tournaments_users_fk (director_id)
      REFERENCES users(id)
);

/* tournaments detail table */
CREATE TABLE division_tournaments (
   id INT UNSIGNED NOT NULL AUTO_INCREMENT,
   tournament_id INT UNSIGNED NOT NULL,
   age_group VARCHAR(3) NOT NULL,
   level VARCHAR(5),
   open_flag TINYINT(1) NOT NULL DEFAULT 1,
   location_id INT UNSIGNED,
   format_id INT UNSIGNED,
   registration_fee DECIMAL(5,2),
   registration_deadline DATE,
   min_teams INT UNSIGNED NOT NULL DEFAULT 3,
   max_teams INT UNSIGNED NOT NULL DEFAULT 16,
   bracket_id INT UNSIGNED, /** not used yet **/


   PRIMARY KEY (id),
   FOREIGN KEY division_tournaments_tournament_id_fk (tournament_id)
      REFERENCES tournaments(id),
   FOREIGN KEY division_tournaments_age_group_fk (age_group)
      REFERENCES age_groups(age_group),
   FOREIGN KEY division_tournaments_level_fk (level)
      REFERENCES levels(level),
   FOREIGN KEY division_tournaments_location_id_fk (location_id)
      REFERENCES locations(id),
   FOREIGN KEY division_tournaments_format_id_fk (format_id)
      REFERENCES formats(id)

);

/**
 * triggers not allowed in free version of cleardb on heroku
 * this functionality has been moved into tournaments.js
DELIMITER $$
CREATE TRIGGER open_tournaments_ins_trig BEFORE INSERT ON tournaments
   FOR EACH ROW
   BEGIN
      IF NEW.level IS NULL THEN
	 SET NEW.open_flag = 1;
      ELSEIF LOWER(NEW.level) = "open" THEN
	 SET NEW.level = NULL;
	 SET NEW.open_flag = 1;
      ELSE
	 SET NEW.open_flag = 0;
      END IF;
   END;$$

CREATE TRIGGER open_tournaments_upd_trig BEFORE UPDATE ON tournaments 
   FOR EACH ROW
   BEGIN
      IF NEW.level IS NULL THEN
	 SET NEW.open_flag = 1;
      ELSEIF LOWER(NEW.level) = "open" THEN
	 SET NEW.level = NULL;
	 SET NEW.open_flag = 1;
      ELSE
	 SET NEW.open_flag = 0;
      END IF;
   END; $$

DELIMITER ; */
commit;
