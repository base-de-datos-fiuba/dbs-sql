CREATE SCHEMA pokemon;
SET search_path TO pokemon;

CREATE TABLE pokemon (
  IDpoke SMALLINT NOT NULL ,
  pokename CHAR(12) NOT NULL ,
  HP SMALLINT NOT NULL,
  attack SMALLINT NOT NULL,
  defense SMALLINT NOT NULL,
  spattack SMALLINT NOT NULL,
  spdefense SMALLINT NOT NULL,
  speed SMALLINT NOT NULL,
  dualtype BOOLEAN NOT NULL DEFAULT false,
  PRIMARY KEY (IDpoke)
);

CREATE TABLE egggroup (
  IDegg SMALLINT NOT NULL ,
  eggname CHAR(12) NOT NULL ,
  PRIMARY KEY (IDegg)
);

CREATE TABLE type (
	IDtype SMALLINT NOT NULL,
	typename CHAR(12) NOT NULL,
	PRIMARY KEY (IDtype)
);

CREATE TABLE abilities (
	IDAbility SMALLINT NOT NULL,
	abilityname CHAR(14) NOT NULL,
	abilitydescrip VARCHAR(255) NOT NULL,
	PRIMARY KEY (IDAbility)
);
CREATE TABLE categories (
  IDcat SMALLINT NOT NULL,
  category CHAR(8) NOT NULL,
   PRIMARY KEY (IDcat)
);

CREATE TABLE moves (
  IDmove SMALLINT NOT NULL,
  movename CHAR(16) NOT NULL ,
  IDtype SMALLINT NOT NULL,
  IDcat SMALLINT NOT NULL,
  power SMALLINT NOT NULL,
  accuracy SMALLINT NOT NULL,
  PP SMALLINT NOT NULL,
  effect VARCHAR(255) NOT NULL,
  PRIMARY KEY (IDmove),
  CONSTRAINT fk_moves_type FOREIGN KEY (IDtype) REFERENCES type (IDtype),
  CONSTRAINT fk_moves_cat FOREIGN KEY (IDcat) REFERENCES categories (IDcat)
);

CREATE TABLE pokeType (
	IDpoke SMALLINT NOT NULL ,
	IDtype SMALLINT NOT NULL,
	PRIMARY KEY (IDpoke,IDtype),
	CONSTRAINT fk_poketype_poke FOREIGN KEY (IDpoke) REFERENCES pokemon (IDpoke),
	CONSTRAINT fk_poketype_type FOREIGN KEY (IDtype) REFERENCES type (IDtype)
);

CREATE TABLE pokeEgg (
	IDpoke SMALLINT NOT NULL ,
	IDegg SMALLINT NOT NULL,
	PRIMARY KEY (IDpoke,IDegg),
	CONSTRAINT fk_pokeegg_poke FOREIGN KEY (IDpoke) REFERENCES pokemon (IDpoke),
	CONSTRAINT fk_pokeegg_egg FOREIGN KEY (IDegg) REFERENCES egggroup (IDegg)
);

CREATE TABLE pokeAbility (
	IDpoke SMALLINT NOT NULL ,
	IDAbility SMALLINT NOT NULL,
    slot CHAR(1) NOT NULL,
	PRIMARY KEY (IDpoke,IDAbility),
	CONSTRAINT fk_pokeAbilitys_poke FOREIGN KEY (IDpoke) REFERENCES pokemon (IDpoke),
	CONSTRAINT fk_pokeAbilitys_move FOREIGN KEY (IDAbility) REFERENCES abilities (IDAbility)
);

CREATE TABLE pokeMoves (
	IDpoke SMALLINT NOT NULL ,
	IDMove SMALLINT NOT NULL,
    slot SMALLINT NOT NULL CHECK (slot >= 1 AND slot <= 4),
	PRIMARY KEY (IDpoke,IDMove),
	CONSTRAINT fk_pokeMoves_poke FOREIGN KEY (IDpoke) REFERENCES pokemon (IDpoke),
	CONSTRAINT fk_pokeMoves_move FOREIGN KEY (IDMove) REFERENCES moves (IDmove)
);

INSERT INTO type VALUES (1, 'Normal');
INSERT INTO type VALUES (2, 'Fighting');
INSERT INTO type VALUES (3, 'Flying');
INSERT INTO type VALUES (4, 'Poison');
INSERT INTO type VALUES (5, 'Ground');
INSERT INTO type VALUES (6, 'Rock');
INSERT INTO type VALUES (7, 'Bug');
INSERT INTO type VALUES (8, 'Ghost');
INSERT INTO type VALUES (9, 'Steel');
INSERT INTO type VALUES (10, 'Fire');
INSERT INTO type VALUES (11, 'Water');
INSERT INTO type VALUES (12, 'Grass');
INSERT INTO type VALUES (13, 'Electric');
INSERT INTO type VALUES (14, 'Psychic');
INSERT INTO type VALUES (15, 'Ice');
INSERT INTO type VALUES (16, 'Dragon');
INSERT INTO type VALUES (17, 'Dark');
INSERT INTO type VALUES (18, 'Fairy');


INSERT INTO egggroup VALUES (1, 'Monster');
INSERT INTO egggroup VALUES (2, 'Water 1');
INSERT INTO egggroup VALUES (3, 'Bug');
INSERT INTO egggroup VALUES (4, 'Flying');
INSERT INTO egggroup VALUES (5, 'Field');
INSERT INTO egggroup VALUES (6, 'Fairy');
INSERT INTO egggroup VALUES (7, 'Grass');
INSERT INTO egggroup VALUES (8, 'Human-Like');
INSERT INTO egggroup VALUES (9, 'Water 3');
INSERT INTO egggroup VALUES (10, 'Mineral');
INSERT INTO egggroup VALUES (11, 'Amorphous');
INSERT INTO egggroup VALUES (12, 'Water 2');
INSERT INTO egggroup VALUES (13, 'Ditto');
INSERT INTO egggroup VALUES (14, 'Dragon');
INSERT INTO egggroup VALUES (15, 'Undiscovered');
INSERT INTO egggroup VALUES (16, 'Genderless');

INSERT INTO categories VALUES (1, 'Physical');
INSERT INTO categories VALUES (2, 'Special');
INSERT INTO categories VALUES (3, 'Status');

INSERT INTO moves VALUES
  (1,  'Tackle',         1, 1, 40, 100, 35, 'Basic physical strike'),
  (2,  'Growl',          1, 3, 0,  100, 40, 'Lowers target Attack by 1 stage'),
  (3,  'Vine Whip',     12, 1, 45, 100, 25, 'Whips target with vines'),
  (4,  'Ember',         10, 2, 40, 100, 25, '10% chance to burn'),
  (5,  'Water Gun',     11, 2, 40, 100, 25, 'Sprays water at target'),
  (6,  'Thunderbolt',   13, 2, 90, 100, 15, '10% chance to paralyze'),
  (7,  'Ice Beam',      15, 2, 90, 100, 10, '10% chance to freeze'),
  (8,  'Quick Attack',   1, 1, 40, 100, 30, 'Priority +1'),
  (9,  'Gust',           3, 2, 40, 100, 35, 'Ranged wind attack'),
  (10, 'Peck',           3, 1, 35, 100, 35, 'Jabs with a beak'),
  (11, 'Confusion',     14, 2, 50, 100, 25, '10% chance to confuse'),
  (12, 'Psychic',       14, 2, 90, 100, 10, '10% chance to lower Sp. Def'),
  (13, 'Earthquake',     5, 1,100, 100, 10, 'Hits all adjacent grounded targets'),
  (14, 'Rock Slide',     6, 1, 75,  90, 10, '30% chance to flinch'),
  (15, 'Hyper Beam',     1, 2,150,  90, 5,  'User must recharge next turn'),
  (16, 'Slash',          1, 1, 70, 100, 20, 'High critical-hit ratio'),
  (17, 'Poison Sting',   4, 1, 15, 100, 35, '30% chance to poison'),
  (18, 'String Shot',    7, 3, 0,   95, 40, 'Lowers target Speed by 1 stage'),
  (19, 'Harden',         1, 3, 0,    0, 30, 'Raises user Defense by 1 stage'),
  (20, 'Sleep Powder',  12, 3, 0,   75, 15, 'Puts target to sleep'),
  (21, 'Hypnosis',      14, 3, 0,   60, 20, 'Puts target to sleep'),
  (22, 'Lick',           8, 1, 30, 100, 30, '30% chance to paralyze'),
  (23, 'Night Shade',    8, 2, 0,  100, 15, 'Deals damage equal to user level'),
  (24, 'Dragon Rage',   16, 2, 0,  100, 10, 'Always deals 40 HP damage'),
  (25, 'Surf',          11, 2, 90, 100, 15, 'Powerful water wave'),
  (26, 'Flamethrower',  10, 2, 90, 100, 15, '10% chance to burn'),
  (27, 'Razor Leaf',    12, 1, 55,  95, 25, 'High critical-hit ratio'),
  (28, 'ThunderShock',  13, 2, 40, 100, 30, '10% chance to paralyze'),
  (29, 'Double Kick',    2, 1, 30, 100, 30, 'Hits twice'),
  (30, 'Karate Chop',    2, 1, 50, 100, 25, 'Solid chop'),
  (31, 'Wing Attack',    3, 1, 60, 100, 35, 'Strikes with wings'),
  (32, 'Bubble',        11, 2, 40, 100, 30, '10% chance to lower Speed'),
  (33, 'Scratch',        1, 1, 40, 100, 35, 'Basic claw attack'),
  (34, 'Teleport',      14, 3, 0,    0, 20, 'Escapes/wild battle utility'),
  (35, 'Splash',         1, 3, 0,    0, 40, 'No effect'),
  (36, 'Blizzard',      15, 2,110,  70, 5,  '10% chance to freeze');

INSERT INTO abilities VALUES (65, 'Overgrow', 'Amplifies Grass-type attacks when HP is low');
INSERT INTO abilities VALUES (66, 'Blaze', 'Amplifies Fire-type attacks when HP is low');
INSERT INTO abilities VALUES (67, 'Torrent', 'Amplifies Water-type attacks when HP is low');
INSERT INTO abilities VALUES (14, 'Compound Eyes', 'Boosts Accuracy');
INSERT INTO abilities VALUES (68, 'Swarm', 'Amplifies Bug-type attacks when HP is low');
INSERT INTO abilities VALUES (51, 'Keen Eye', 'Accuracy cannot be reduced by an opponent');
INSERT INTO abilities VALUES (77, 'Tangled Feet', 'Raises Speed when confused');
INSERT INTO abilities VALUES (9, 'Static', 'May paralyze an opponent that makes contact');
INSERT INTO abilities VALUES (8, 'Sand Veil', 'Increases Evasion in a sandstorm');
INSERT INTO abilities VALUES (56, 'Cute Charm', 'May cause infatuation on contact');
INSERT INTO abilities VALUES (98, 'Magic Guard', 'Grants total protection from indirect damage');
INSERT INTO abilities VALUES (11, 'Water Absorb', 'Water-type attacks heal the Pokémon');
INSERT INTO abilities VALUES (6, 'Damp', 'Prevents use of self-destruction attacks by any Pokémon on the field');
INSERT INTO abilities VALUES (26, 'Levitate', 'Grants immunity to Ground-type moves');
INSERT INTO abilities VALUES (12, 'Oblivious', 'Prevents infatuation');
INSERT INTO abilities VALUES (108, 'Forewarn', 'Shows the opponents most powerful move');
INSERT INTO abilities VALUES (33, 'Swift Swim', 'Doubles speed under rain conditions');
INSERT INTO abilities VALUES (75, 'Shell Armor', 'Grants protection from critical hits');
INSERT INTO abilities VALUES (29, 'Clear Body', 'Stats cannot be lowered by an opponent');
INSERT INTO abilities VALUES (34, 'Chlorophyll', 'Doubles speed under intense sunlight');
INSERT INTO abilities VALUES (94, 'Solar Power', 'Under intense sunlight, Sp. Attack increased, 1/8 HP lost every turn');
INSERT INTO abilities VALUES (44, 'Rain Dish', 'Gradually recovers HP in rain');
INSERT INTO abilities VALUES (110, 'Tinted Lens', 'Raises power of uneffective moves');
INSERT INTO abilities VALUES (97, 'Sniper', 'Increases power of critical hits');
INSERT INTO abilities VALUES (145, 'Big Pecks', 'Defense cannot be lowered by an opponent');
INSERT INTO abilities VALUES (31, 'Lightning Rod', 'Redirects Electric-type attacks towards this Pokémon, nullifies them and increases Sp. Attack');
INSERT INTO abilities VALUES (146, 'Sand Rush', 'Doubles speed in a sandstorm');
INSERT INTO abilities VALUES (132, 'Friend Guard', 'Decreases damage inflicted against ally Pokémon');
INSERT INTO abilities VALUES (87, 'Dry Skin', 'Recovers HP in rain, loses HP under intense sunlight');
INSERT INTO abilities VALUES (133, 'Weak Armor', 'Raises Speed and lowers Defense upon being hit');
INSERT INTO abilities VALUES (135, 'Light Metal', 'Halves weight');
INSERT INTO abilities VALUES (201, 'Intimidate',   'Lowers opposing Pokémon Attack on entry');
INSERT INTO abilities VALUES (202, 'Flash Fire',   'Powers up Fire moves if it is hit by one; immunity to Fire');
INSERT INTO abilities VALUES (203, 'Run Away',     'Ensures escape from wild battles');
INSERT INTO abilities VALUES (204, 'Pickup',       'May pick up items after battle');
INSERT INTO abilities VALUES (205, 'Technician',   'Boosts moves with base power 60 or lower');
INSERT INTO abilities VALUES (206, 'Guts',         'Boosts Attack if statused');
INSERT INTO abilities VALUES (207, 'No Guard',     'All moves used by/against this Pokémon never miss');
INSERT INTO abilities VALUES (208, 'Vital Spirit', 'Prevents sleep');
INSERT INTO abilities VALUES (209, 'Insomnia',     'Prevents sleep');
INSERT INTO abilities VALUES (210, 'Synchronize',  'Passes burn/paralyze/poison to the inflictor');
INSERT INTO abilities VALUES (211, 'Own Tempo',    'Prevents confusion');
INSERT INTO abilities VALUES (212, 'Sturdy',       'Survives one-hit KO moves; endures from full HP');
INSERT INTO abilities VALUES (213, 'Rock Head',    'Prevents recoil damage');
INSERT INTO abilities VALUES (214, 'Magnet Pull',  'Prevents Steel-type foes from fleeing; boosts Steel encounters');
INSERT INTO abilities VALUES (215, 'Stench',       'Odor may cause flinching; repels wild encounters');
INSERT INTO abilities VALUES (216, 'Sticky Hold',  'Prevents item theft; sticky grip');
INSERT INTO abilities VALUES (217, 'Liquid Ooze',  'Draining moves damage the user instead of healing');
INSERT INTO abilities VALUES (218, 'Skill Link',   'Multi-hit moves always strike the maximum number of times');
INSERT INTO abilities VALUES (219, 'Thick Fat',    'Halves damage from Fire and Ice moves');
INSERT INTO abilities VALUES (220, 'Hydration',    'Heals status in rain at end of turn');
INSERT INTO abilities VALUES (221, 'Arena Trap',   'Prevents grounded foes from escaping/switching');
INSERT INTO abilities VALUES (222, 'Poison Point', 'Contact may poison the attacker');
INSERT INTO abilities VALUES (223, 'Rivalry',      'Boosts damage vs. same gender; lowers vs. opposite');
INSERT INTO abilities VALUES (224, 'Gluttony',     'Eats pinch berries at higher HP threshold');
INSERT INTO abilities VALUES (225, 'Effect Spore', 'Contact may inflict sleep/poison/paralysis');
INSERT INTO abilities VALUES (226, 'Cloud Nine',   'Negates effects of weather');
INSERT INTO abilities VALUES (227, 'Early Bird',   'Wakes up quickly');
INSERT INTO abilities VALUES (46, 'Pressure', 'The foe uses 2 PP instead of 1 for moves');


ALTER TABLE pokemon ADD CONSTRAINT unique_pokename UNIQUE (pokename);
ALTER TABLE egggroup ADD CONSTRAINT unique_eggname UNIQUE (eggname);
ALTER TABLE type ADD CONSTRAINT unique_typename UNIQUE (typename);
ALTER TABLE abilities ADD CONSTRAINT unique_abilityname UNIQUE (abilityname);
ALTER TABLE categories ADD CONSTRAINT unique_category UNIQUE (category);

-- PostgreSQL function syntax
CREATE OR REPLACE FUNCTION stat_average(pokeno SMALLINT) 
RETURNS DECIMAL(6,2) AS $$
DECLARE 
    statavg DECIMAL(6,2);
BEGIN
    SELECT (HP+attack+defense+spattack+spdefense+speed)/6.0 INTO statavg
    FROM pokemon
    WHERE IDpoke=pokeno;
    RETURN statavg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION base_stat_total(pokeno SMALLINT) 
RETURNS SMALLINT AS $$
DECLARE 
    bst SMALLINT;
BEGIN
    SELECT HP+attack+defense+spattack+spdefense+speed INTO bst
    FROM pokemon
    WHERE IDpoke=pokeno;
    RETURN bst;
END;
$$ LANGUAGE plpgsql;

SET search_path TO pokemon;

BEGIN;
-- Bulbasaur line ------------------------------------------------
INSERT INTO pokemon VALUES (1,  'Bulbasaur', 45, 49, 49, 65, 65, 45, true);
INSERT INTO pokeType VALUES (1,12); INSERT INTO pokeType VALUES (1,4);
INSERT INTO pokeEgg  VALUES (1,1);  INSERT INTO pokeEgg  VALUES (1,7);
INSERT INTO pokeAbility VALUES (1,34,'1'); 
INSERT INTO pokeAbility VALUES (1,  65,'2');

INSERT INTO pokemon VALUES (2,  'Ivysaur',   60, 62, 63, 80, 80, 60, true);
INSERT INTO pokeType VALUES (2,12); INSERT INTO pokeType VALUES (2,4);
INSERT INTO pokeEgg  VALUES (2,1);  INSERT INTO pokeEgg  VALUES (2,7);
INSERT INTO pokeAbility VALUES (2,34,'1');
INSERT INTO pokeAbility VALUES (2,  65,'2'); 

INSERT INTO pokemon VALUES (3, 'Venusaur', 80, 82, 83, 100, 100, 80, true);
INSERT INTO pokeType VALUES (3,12); INSERT INTO pokeType VALUES (3,4);
INSERT INTO pokeEgg  VALUES (3,1);  INSERT INTO pokeEgg  VALUES (3,7);
INSERT INTO pokeAbility VALUES (3,34,'1');
INSERT INTO pokeAbility VALUES (3,  65,'2');

-- Charmander line ----------------------------------------------
INSERT INTO pokemon VALUES (4,  'Charmander',39, 52, 43, 60, 50, 65, false);
INSERT INTO pokeType VALUES (4,10);
INSERT INTO pokeEgg  VALUES (4,1);  INSERT INTO pokeEgg VALUES (4,14);
INSERT INTO pokeAbility VALUES (4,66,'1');
INSERT INTO pokeAbility VALUES (4,  94,'3');

INSERT INTO pokemon VALUES (5,  'Charmeleon',58, 64, 58, 80, 65, 80, false);
INSERT INTO pokeType VALUES (5,10);
INSERT INTO pokeEgg  VALUES (5,1);  INSERT INTO pokeEgg VALUES (5,14);
INSERT INTO pokeAbility VALUES (5,66,'1');
INSERT INTO pokeAbility VALUES (5,  94,'3');

INSERT INTO pokemon VALUES (6, 'Charizard', 78, 84, 78, 109, 85, 100, true);
INSERT INTO pokeType VALUES (6,10); INSERT INTO pokeType VALUES (6,3);
INSERT INTO pokeEgg VALUES (6,1); INSERT INTO pokeEgg VALUES (6,14);
INSERT INTO pokeAbility VALUES (6,66,'1');
INSERT INTO pokeAbility VALUES (6,94,'3');

-- Squirtle line -------------------------------------------------
INSERT INTO pokemon VALUES (7,  'Squirtle', 44, 48, 65, 50, 64, 43, false);
INSERT INTO pokeType VALUES (7,11);
INSERT INTO pokeEgg  VALUES (7,1);  INSERT INTO pokeEgg VALUES (7,2);
INSERT INTO pokeAbility VALUES (7,67,'1');
INSERT INTO pokeAbility VALUES (7,  33,'2');

INSERT INTO pokemon VALUES (8,  'Wartortle',59, 63, 80, 65, 80, 58, false);
INSERT INTO pokeType VALUES (8,11);
INSERT INTO pokeEgg  VALUES (8,1);  INSERT INTO pokeEgg VALUES (8,2);
INSERT INTO pokeAbility VALUES (8,67,'1');
INSERT INTO pokeAbility VALUES (8,  33,'2');

INSERT INTO pokemon VALUES (9, 'Blastoise', 79, 83, 100, 85, 105, 78, false);
INSERT INTO pokeType VALUES (9,11);
INSERT INTO pokeEgg VALUES (9,1); INSERT INTO pokeEgg VALUES (9,2);
INSERT INTO pokeAbility VALUES (9,67,'1');
INSERT INTO pokeAbility VALUES (9,44,'3');

-- Caterpie line -------------------------------------------------
INSERT INTO pokemon VALUES (10, 'Caterpie', 45, 30, 35, 20, 20, 45, false);
INSERT INTO pokeType VALUES (10,7);
INSERT INTO pokeEgg  VALUES (10,3);
INSERT INTO pokeAbility VALUES (10,68,'1'); 
INSERT INTO pokeAbility VALUES (10,110,'2');

INSERT INTO pokemon VALUES (11, 'Metapod',  50, 20, 55, 25, 25, 30, false);
INSERT INTO pokeType VALUES (11,7);
INSERT INTO pokeEgg  VALUES (11,3);
INSERT INTO pokeAbility VALUES (11,68,'1');

INSERT INTO pokemon VALUES (12, 'Butterfree', 60, 45, 50, 90, 80, 70, true);
INSERT INTO pokeType VALUES (12,7); INSERT INTO pokeType VALUES (12,3);
INSERT INTO pokeEgg VALUES (12,3);
INSERT INTO pokeAbility VALUES (12,14,'1');
INSERT INTO pokeAbility VALUES (12,110,'3');

-- Weedle line ---------------------------------------------------
INSERT INTO pokemon VALUES (13, 'Weedle',   40, 35, 30, 20, 20, 50, true);
INSERT INTO pokeType VALUES (13,7); INSERT INTO pokeType VALUES (13,4);
INSERT INTO pokeEgg  VALUES (13,3);
INSERT INTO pokeAbility VALUES (13,68,'1');
INSERT INTO pokeAbility VALUES (13,222,'2'); 

INSERT INTO pokemon VALUES (14, 'Kakuna',   45, 25, 50, 25, 25, 35, true);
INSERT INTO pokeType VALUES (14,7); INSERT INTO pokeType VALUES (14,4);
INSERT INTO pokeEgg  VALUES (14,3);
INSERT INTO pokeAbility VALUES (14,68,'1');

INSERT INTO pokemon VALUES (15, 'Beedrill', 65, 90, 40, 45, 80, 75, true);
INSERT INTO pokeType VALUES (15,7); INSERT INTO pokeType VALUES (15,4);
INSERT INTO pokeEgg VALUES (15,3);
INSERT INTO pokeAbility VALUES (15,68,'1');
INSERT INTO pokeAbility VALUES (15,97,'3');

-- Pidgey line ----------------------
INSERT INTO pokemon VALUES (16, 'Pidgey',   40, 45, 40, 35, 35, 56, true);
INSERT INTO pokeType VALUES (16,1); INSERT INTO pokeType VALUES (16,3);
INSERT INTO pokeEgg  VALUES (16,4);
INSERT INTO pokeAbility VALUES (16,51,'1');  

INSERT INTO pokemon VALUES (17, 'Pidgeotto',63, 60, 55, 50, 50, 71, true);
INSERT INTO pokeType VALUES (17,1); INSERT INTO pokeType VALUES (17,3);
INSERT INTO pokeEgg  VALUES (17,4);
INSERT INTO pokeAbility VALUES (17,51,'1');
INSERT INTO pokeAbility VALUES (17, 77,'2');

INSERT INTO pokemon VALUES (18, 'Pidgeot', 83, 80, 75, 70, 70, 101, true);
INSERT INTO pokeType VALUES (18,1); INSERT INTO pokeType VALUES (18,3);
INSERT INTO pokeEgg VALUES (18,4);
INSERT INTO pokeAbility VALUES (18,51,'1');
INSERT INTO pokeAbility VALUES (18,77,'2');
INSERT INTO pokeAbility VALUES (18,145,'3');

-- Rattata line --------------------------------------------------
INSERT INTO pokemon VALUES (19, 'Rattata',  30, 56, 35, 25, 35, 72, false);
INSERT INTO pokeType VALUES (19,1);
INSERT INTO pokeEgg  VALUES (19,5);
INSERT INTO pokeAbility VALUES (19,51,'1');
INSERT INTO pokeAbility VALUES (19,203,'2');
INSERT INTO pokeAbility VALUES (19,206,'3');

INSERT INTO pokemon VALUES (20, 'Raticate', 55, 81, 60, 50, 70, 97, false);
INSERT INTO pokeType VALUES (20,1);
INSERT INTO pokeEgg  VALUES (20,5);
INSERT INTO pokeAbility VALUES (20,51,'1');
INSERT INTO pokeAbility VALUES (20,206,'2');

-- Spearow line --------------------------------------------------
INSERT INTO pokemon VALUES (21, 'Spearow',  40, 60, 30, 31, 31, 70, true);
INSERT INTO pokeType VALUES (21,1); INSERT INTO pokeType VALUES (21,3);
INSERT INTO pokeEgg  VALUES (21,4);
INSERT INTO pokeAbility VALUES (21,51,'1');
INSERT INTO pokeAbility VALUES (21,209,'2'); 

INSERT INTO pokemon VALUES (22, 'Fearow',   65, 90, 65, 61, 61, 100, true);
INSERT INTO pokeType VALUES (22,1); INSERT INTO pokeType VALUES (22,3);
INSERT INTO pokeEgg  VALUES (22,4);
INSERT INTO pokeAbility VALUES (22,51,'1');
INSERT INTO pokeAbility VALUES (22,209,'2');

-- Ekans line ----------------------------------------------------
INSERT INTO pokemon VALUES (23, 'Ekans',    35, 60, 44, 40, 54, 55, false);
INSERT INTO pokeType VALUES (23,4);
INSERT INTO pokeEgg  VALUES (23,5);
INSERT INTO pokeAbility VALUES (23,8,'1');

INSERT INTO pokemon VALUES (24, 'Arbok',    60, 95, 69, 65, 79, 80, false);
INSERT INTO pokeType VALUES (24,4);
INSERT INTO pokeEgg  VALUES (24,5);
INSERT INTO pokeAbility VALUES (24,8,'1');
INSERT INTO pokeAbility VALUES (24,201,'2');  

-- Pikachu line ----------------------
INSERT INTO pokemon VALUES (25, 'Pikachu',  35, 55, 40, 50, 50, 90, false);
INSERT INTO pokeType VALUES (25,13);
INSERT INTO pokeEgg  VALUES (25,5); INSERT INTO pokeEgg VALUES (25,6);
INSERT INTO pokeAbility VALUES (25,9,'1');  
INSERT INTO pokeAbility VALUES (25, 31,'2');

INSERT INTO pokemon VALUES (26, 'Raichu', 60, 90, 55, 90, 80, 110, false);
INSERT INTO pokeType VALUES (26,13);
INSERT INTO pokeEgg VALUES (26,5); INSERT INTO pokeEgg VALUES (26,6);
INSERT INTO pokeAbility VALUES (26,9,'1');
INSERT INTO pokeAbility VALUES (26,31,'3');

-- Sandshrew line -------------------------
INSERT INTO pokemon VALUES (27, 'Sandshrew',50, 75, 85, 20, 30, 40, false);
INSERT INTO pokeType VALUES (27,5);
INSERT INTO pokeEgg  VALUES (27,5);
INSERT INTO pokeAbility VALUES (27,8,'1');
INSERT INTO pokeAbility VALUES (27,146,'2');

INSERT INTO pokemon VALUES (28, 'Sandslash', 75, 100, 110, 45, 55, 65, false);
INSERT INTO pokeType VALUES (28,5);
INSERT INTO pokeEgg VALUES (28,5);
INSERT INTO pokeAbility VALUES (28,8,'1');
INSERT INTO pokeAbility VALUES (28,146,'3');

-- Nidoran♀ line -------------------------------------------------
INSERT INTO pokemon VALUES (29, 'Nidoran♀', 55, 47, 52, 40, 40, 41, true);
INSERT INTO pokeType VALUES (29,4); INSERT INTO pokeType VALUES (29,1);
INSERT INTO pokeEgg  VALUES (29,5);
INSERT INTO pokeAbility VALUES (29,12,'1');
INSERT INTO pokeAbility VALUES (29,222,'2'); 

INSERT INTO pokemon VALUES (30, 'Nidorina', 70, 62, 67, 55, 55, 56, true);
INSERT INTO pokeType VALUES (30,4); INSERT INTO pokeType VALUES (30,1);
INSERT INTO pokeEgg  VALUES (30,5);
INSERT INTO pokeAbility VALUES (30,12,'1');
INSERT INTO pokeAbility VALUES (30,222,'2'); 

INSERT INTO pokemon VALUES (31, 'Nidoqueen',90, 92, 87, 75, 85, 76, true);
INSERT INTO pokeType VALUES (31,4); INSERT INTO pokeType VALUES (31,5);
INSERT INTO pokeEgg  VALUES (31,5);
INSERT INTO pokeAbility VALUES (31,8,'1');
INSERT INTO pokeAbility VALUES (31,222,'2');

-- Nidoran♂ line -------------------------------------------------
INSERT INTO pokemon VALUES (32, 'Nidoran♂', 46, 57, 40, 40, 40, 50, true);
INSERT INTO pokeType VALUES (32,4); INSERT INTO pokeType VALUES (32,1);
INSERT INTO pokeEgg  VALUES (32,5);
INSERT INTO pokeAbility VALUES (32,12,'1');
INSERT INTO pokeAbility VALUES (32,222,'2');  
INSERT INTO pokeAbility VALUES (32,223,'3');

INSERT INTO pokemon VALUES (33, 'Nidorino', 61, 72, 57, 55, 55, 65, true);
INSERT INTO pokeType VALUES (33,4); INSERT INTO pokeType VALUES (33,1);
INSERT INTO pokeEgg  VALUES (33,5);
INSERT INTO pokeAbility VALUES (33,12,'1');
INSERT INTO pokeAbility VALUES (33,222,'2'); 


INSERT INTO pokemon VALUES (34, 'Nidoking', 81,102, 77, 85, 75, 85, true);
INSERT INTO pokeType VALUES (34,4); INSERT INTO pokeType VALUES (34,5);
INSERT INTO pokeEgg  VALUES (34,5);
INSERT INTO pokeAbility VALUES (34,8,'1');
INSERT INTO pokeAbility VALUES (34,222,'2'); 

-- Clefairy line (Clefable 36 exists) ---------------------------
INSERT INTO pokemon VALUES (35, 'Clefairy', 70, 45, 48, 60, 65, 35, false);
INSERT INTO pokeType VALUES (35,18);
INSERT INTO pokeEgg  VALUES (35,6);
INSERT INTO pokeAbility VALUES (35,56,'1');
INSERT INTO pokeAbility VALUES (35,219,'2');

INSERT INTO pokemon VALUES (36, 'Clefable', 95, 70, 73, 95, 90, 60, false);
INSERT INTO pokeType VALUES (36,18);
INSERT INTO pokeEgg VALUES (36,6);
INSERT INTO pokeAbility VALUES (36,56,'1');
INSERT INTO pokeAbility VALUES (36,98,'2');
INSERT INTO pokeAbility VALUES (36,132,'3');

-- Vulpix line ---------------------------------------------------
INSERT INTO pokemon VALUES (37, 'Vulpix',   38, 41, 40, 50, 65, 65, false);
INSERT INTO pokeType VALUES (37,10);
INSERT INTO pokeEgg  VALUES (37,5); INSERT INTO pokeEgg VALUES (37,6);
INSERT INTO pokeAbility VALUES (37,66,'1');  

INSERT INTO pokemon VALUES (38, 'Ninetales',73, 76, 75, 81,100,100, false);
INSERT INTO pokeType VALUES (38,10);
INSERT INTO pokeEgg  VALUES (38,5); INSERT INTO pokeEgg VALUES (38,6);
INSERT INTO pokeAbility VALUES (38,66,'1');
INSERT INTO pokeAbility VALUES (38,202,'2'); 

-- Jigglypuff line ----------------------------------------------
INSERT INTO pokemon VALUES (39, 'Jigglypuff',115,45, 20, 45, 25, 20, true);
INSERT INTO pokeType VALUES (39,1); INSERT INTO pokeType VALUES (39,18);
INSERT INTO pokeEgg  VALUES (39,6);
INSERT INTO pokeAbility VALUES (39,56,'1');

INSERT INTO pokemon VALUES (40, 'Wigglytuff',140,70,45, 85, 50, 45, true);
INSERT INTO pokeType VALUES (40,1); INSERT INTO pokeType VALUES (40,18);
INSERT INTO pokeEgg  VALUES (40,6);
INSERT INTO pokeAbility VALUES (40,56,'1');
INSERT INTO pokeAbility VALUES (40,219,'2');

-- Zubat line ----------------------------------------------------
INSERT INTO pokemon VALUES (41, 'Zubat',    40, 45, 35, 30, 40, 55, true);
INSERT INTO pokeType VALUES (41,4); INSERT INTO pokeType VALUES (41,3);
INSERT INTO pokeEgg  VALUES (41,4);
INSERT INTO pokeAbility VALUES (41,51,'1');
INSERT INTO pokeAbility VALUES (41,208,'2'); 

INSERT INTO pokemon VALUES (42, 'Golbat',   75, 80, 70, 65, 75, 90, true);
INSERT INTO pokeType VALUES (42,4); INSERT INTO pokeType VALUES (42,3);
INSERT INTO pokeEgg  VALUES (42,4);
INSERT INTO pokeAbility VALUES (42,51,'1');
INSERT INTO pokeAbility VALUES (42,208,'2'); 


-- Oddish line ---------------------------------------------------
INSERT INTO pokemon VALUES (43, 'Oddish',   45, 50, 55, 75, 65, 30, true);
INSERT INTO pokeType VALUES (43,12); INSERT INTO pokeType VALUES (43,4);
INSERT INTO pokeEgg  VALUES (43,7);
INSERT INTO pokeAbility VALUES (43,34,'1');

INSERT INTO pokemon VALUES (44, 'Gloom',    60, 65, 70, 85, 75, 40, true);
INSERT INTO pokeType VALUES (44,12); INSERT INTO pokeType VALUES (44,4);
INSERT INTO pokeEgg  VALUES (44,7);
INSERT INTO pokeAbility VALUES (44,34,'1');
INSERT INTO pokeAbility VALUES (44,224,'2'); 

INSERT INTO pokemon VALUES (45, 'Vileplume',75, 80, 85,110, 90, 50, true);
INSERT INTO pokeType VALUES (45,12); INSERT INTO pokeType VALUES (45,4);
INSERT INTO pokeEgg  VALUES (45,7);
INSERT INTO pokeAbility VALUES (45,34,'1');
INSERT INTO pokeAbility VALUES (45,224,'2'); 

-- Paras line ----------------------------------------------------
INSERT INTO pokemon VALUES (46, 'Paras',    35, 70, 55, 45, 55, 25, true);
INSERT INTO pokeType VALUES (46,7); INSERT INTO pokeType VALUES (46,12);
INSERT INTO pokeEgg  VALUES (46,3); INSERT INTO pokeEgg VALUES (46,7);
INSERT INTO pokeAbility VALUES (46,68,'1');
INSERT INTO pokemon VALUES (47, 'Parasect', 60, 95, 80, 60, 80, 30, true);
INSERT INTO pokeType VALUES (47,7); INSERT INTO pokeType VALUES (47,12);
INSERT INTO pokeEgg  VALUES (47,3); INSERT INTO pokeEgg VALUES (47,7);
INSERT INTO pokeAbility VALUES (47,68,'1');

-- Venonat line --------------------------------------------------
INSERT INTO pokemon VALUES (48, 'Venonat',  60, 55, 50, 40, 55, 45, true);
INSERT INTO pokeType VALUES (48,7); INSERT INTO pokeType VALUES (48,4);
INSERT INTO pokeEgg  VALUES (48,3);
INSERT INTO pokeAbility VALUES (48,68,'1');

INSERT INTO pokemon VALUES (49, 'Venomoth', 70, 65, 60, 90, 75, 90, true);
INSERT INTO pokeType VALUES (49,7); INSERT INTO pokeType VALUES (49,3);
INSERT INTO pokeEgg  VALUES (49,3);
INSERT INTO pokeAbility VALUES (49,68,'1');
INSERT INTO pokeAbility VALUES (49,110,'2');

-- Diglett line --------------------------------------------------
INSERT INTO pokemon VALUES (50, 'Diglett',  10, 55, 25, 35, 45, 95, false);
INSERT INTO pokeType VALUES (50,5);
INSERT INTO pokeEgg  VALUES (50,5);
INSERT INTO pokeAbility VALUES (50,8,'1');
INSERT INTO pokeAbility VALUES (50,221,'2');

INSERT INTO pokemon VALUES (51, 'Dugtrio',  35,100, 50, 50, 70,120, false);
INSERT INTO pokeType VALUES (51,5);
INSERT INTO pokeEgg  VALUES (51,5);
INSERT INTO pokeAbility VALUES (51,8,'1');
INSERT INTO pokeAbility VALUES (51,221,'2');

-- Meowth line ---------------------------------------------------
INSERT INTO pokemon VALUES (52, 'Meowth',   40, 45, 35, 40, 40, 90, false);
INSERT INTO pokeType VALUES (52,1);
INSERT INTO pokeEgg  VALUES (52,5);
INSERT INTO pokeAbility VALUES (52,51,'1');
INSERT INTO pokeAbility VALUES (52,204,'2');
INSERT INTO pokeAbility VALUES (52,205,'3');

INSERT INTO pokemon VALUES (53, 'Persian',  65, 70, 60, 65, 65,115, false);
INSERT INTO pokeType VALUES (53,1);
INSERT INTO pokeEgg  VALUES (53,5);
INSERT INTO pokeAbility VALUES (53,51,'1');
INSERT INTO pokeAbility VALUES (53,205,'2');

-- Psyduck line --------------------------------------------------
INSERT INTO pokemon VALUES (54, 'Psyduck',  50, 52, 48, 65, 50, 55, false);
INSERT INTO pokeType VALUES (54,11);
INSERT INTO pokeEgg  VALUES (54,2);
INSERT INTO pokeAbility VALUES (54,11,'1');

INSERT INTO pokemon VALUES (55, 'Golduck',  80, 82, 78, 95, 80, 85, false);
INSERT INTO pokeType VALUES (55,11);
INSERT INTO pokeEgg  VALUES (55,2);
INSERT INTO pokeAbility VALUES (55,11,'1');
INSERT INTO pokeAbility VALUES (55,226,'2');

-- Mankey line ---------------------------------------------------
INSERT INTO pokemon VALUES (56, 'Mankey',   40, 80, 35, 35, 45, 70, false);
INSERT INTO pokeType VALUES (56,2);
INSERT INTO pokeEgg  VALUES (56,8);
INSERT INTO pokeAbility VALUES (56,51,'1');

INSERT INTO pokemon VALUES (57, 'Primeape', 65,105, 60, 60, 70, 95, false);
INSERT INTO pokeType VALUES (57,2);
INSERT INTO pokeEgg  VALUES (57,8);
INSERT INTO pokeAbility VALUES (57,51,'1');
INSERT INTO pokeAbility VALUES (57,208,'2');

-- Growlithe line -----------------------------------------------
INSERT INTO pokemon VALUES (58, 'Growlithe',55, 70, 45, 70, 50, 60, false);
INSERT INTO pokeType VALUES (58,10);
INSERT INTO pokeEgg  VALUES (58,5); INSERT INTO pokeEgg VALUES (58,6);
INSERT INTO pokeAbility VALUES (58,66,'1');
INSERT INTO pokeAbility VALUES (58,201,'2');
INSERT INTO pokeAbility VALUES (58,202,'3'); 

INSERT INTO pokemon VALUES (59, 'Arcanine', 90,110, 80,100, 80, 95, false);
INSERT INTO pokeType VALUES (59,10);
INSERT INTO pokeEgg  VALUES (59,5); INSERT INTO pokeEgg VALUES (59,6);
INSERT INTO pokeAbility VALUES (59,66,'1');
INSERT INTO pokeAbility VALUES (59,201,'2');
INSERT INTO pokeAbility VALUES (59,202,'3');

-- Poliwag line (Poliwrath 62 exists) ---------------------------
INSERT INTO pokemon VALUES (60, 'Poliwag',  40, 50, 40, 40, 40, 90, false);
INSERT INTO pokeType VALUES (60,11);
INSERT INTO pokeEgg  VALUES (60,2);
INSERT INTO pokeAbility VALUES (60,33,'1'); 

INSERT INTO pokemon VALUES (61, 'Poliwhirl',65, 65, 65, 50, 50, 90, false);
INSERT INTO pokeType VALUES (61,11);
INSERT INTO pokeEgg  VALUES (61,2);
INSERT INTO pokeAbility VALUES (61,33,'1');
INSERT INTO pokeAbility VALUES (61, 11,'2');

INSERT INTO pokemon VALUES (62, 'Poliwrath', 90, 95, 95, 70, 90, 70, true);
INSERT INTO pokeType VALUES (62,11); INSERT INTO pokeType VALUES (62,2);
INSERT INTO pokeEgg VALUES (62,2);
INSERT INTO pokeAbility VALUES (62,11,'1');
INSERT INTO pokeAbility VALUES (62,6,'2');
INSERT INTO pokeAbility VALUES (62,33,'3');

-- Abra line -----------------------------------------------------
INSERT INTO pokemon VALUES (63, 'Abra',     25, 20, 15,105, 55, 90, false);
INSERT INTO pokeType VALUES (63,14);
INSERT INTO pokeEgg  VALUES (63,8);
INSERT INTO pokeAbility VALUES (63,26,'1'); 

INSERT INTO pokemon VALUES (64, 'Kadabra',  40, 35, 30,120, 70,105, false);
INSERT INTO pokeType VALUES (64,14);
INSERT INTO pokeEgg  VALUES (64,8);
INSERT INTO pokeAbility VALUES (64,26,'1');

INSERT INTO pokemon VALUES (65, 'Alakazam', 55, 50, 45,135, 85,120, false);
INSERT INTO pokeType VALUES (65,14);
INSERT INTO pokeEgg  VALUES (65,8);
INSERT INTO pokeAbility VALUES (65,26,'1');
INSERT INTO pokeAbility VALUES (65,210,'2');

-- Machop line ---------------------------------------------------
INSERT INTO pokemon VALUES (66, 'Machop',   70, 80, 50, 35, 35, 35, false);
INSERT INTO pokeType VALUES (66,2);
INSERT INTO pokeEgg  VALUES (66,8);
INSERT INTO pokeAbility VALUES (66,51,'1');
INSERT INTO pokeAbility VALUES (66,206,'2');

INSERT INTO pokemon VALUES (67, 'Machoke',  80,100, 70, 50, 60, 45, false);
INSERT INTO pokeType VALUES (67,2);
INSERT INTO pokeEgg  VALUES (67,8);
INSERT INTO pokeAbility VALUES (67,51,'1');
INSERT INTO pokeAbility VALUES (67,206,'2');

INSERT INTO pokemon VALUES (68, 'Machamp',  90,130, 80, 65, 85, 55, false);
INSERT INTO pokeType VALUES (68,2);
INSERT INTO pokeEgg  VALUES (68,8);
INSERT INTO pokeAbility VALUES (68,51,'1');
INSERT INTO pokeAbility VALUES (68,206,'2');
INSERT INTO pokeAbility VALUES (68,207,'3');

-- Bellsprout line ----------------------------------------------
INSERT INTO pokemon VALUES (69, 'Bellsprout',50, 75, 35, 70, 30, 40, true);
INSERT INTO pokeType VALUES (69,12); INSERT INTO pokeType VALUES (69,4);
INSERT INTO pokeEgg  VALUES (69,7);
INSERT INTO pokeAbility VALUES (69,34,'1');

INSERT INTO pokemon VALUES (70, 'Weepinbell',65, 90, 50, 85, 45, 55, true);
INSERT INTO pokeType VALUES (70,12); INSERT INTO pokeType VALUES (70,4);
INSERT INTO pokeEgg  VALUES (70,7);
INSERT INTO pokeAbility VALUES (70,34,'1');

INSERT INTO pokemon VALUES (71, 'Victreebel',80,105, 65,100, 70, 70, true);
INSERT INTO pokeType VALUES (71,12); INSERT INTO pokeType VALUES (71,4);
INSERT INTO pokeEgg  VALUES (71,7);
INSERT INTO pokeAbility VALUES (71,34,'1');
INSERT INTO pokeAbility VALUES (71,224,'2');

-- Tentacool line -----------------------------------------------
INSERT INTO pokemon VALUES (72, 'Tentacool',40, 40, 35, 50,100, 70, true);
INSERT INTO pokeType VALUES (72,11); INSERT INTO pokeType VALUES (72,4);
INSERT INTO pokeEgg  VALUES (72,12);
INSERT INTO pokeAbility VALUES (72,44,'1');

INSERT INTO pokemon VALUES (73, 'Tentacruel',80, 70, 65, 80,120,100, true);
INSERT INTO pokeType VALUES (73,11); INSERT INTO pokeType VALUES (73,4);
INSERT INTO pokeEgg  VALUES (73,12);
INSERT INTO pokeAbility VALUES (73,44,'1');
INSERT INTO pokeAbility VALUES (73,217,'2'); 

-- Geodude line --------------------------------------------------
INSERT INTO pokemon VALUES (74, 'Geodude',  40, 80,100, 30, 30, 20, true);
INSERT INTO pokeType VALUES (74,6); INSERT INTO pokeType VALUES (74,5);
INSERT INTO pokeEgg  VALUES (74,10);
INSERT INTO pokeAbility VALUES (74,75,'1'); 
INSERT INTO pokeAbility VALUES (74,212,'2');
INSERT INTO pokeAbility VALUES (74,213,'3');

INSERT INTO pokemon VALUES (75, 'Graveler', 55, 95,115, 45, 45, 35, true);
INSERT INTO pokeType VALUES (75,6); INSERT INTO pokeType VALUES (75,5);
INSERT INTO pokeEgg  VALUES (75,10);
INSERT INTO pokeAbility VALUES (75,75,'1');
INSERT INTO pokeAbility VALUES (75,212,'2');  
INSERT INTO pokeAbility VALUES (75,213,'3'); 

INSERT INTO pokemon VALUES (76, 'Golem',    80,120,130, 55, 65, 45, true);
INSERT INTO pokeType VALUES (76,6); INSERT INTO pokeType VALUES (76,5);
INSERT INTO pokeEgg  VALUES (76,10);
INSERT INTO pokeAbility VALUES (76,75,'1');
INSERT INTO pokeAbility VALUES (76,212,'2'); 
INSERT INTO pokeAbility VALUES (76,213,'3');

-- Ponyta line ---------------------------------------------------
INSERT INTO pokemon VALUES (77, 'Ponyta',   50, 85, 55, 65, 65, 90, false);
INSERT INTO pokeType VALUES (77,10);
INSERT INTO pokeEgg  VALUES (77,5);
INSERT INTO pokeAbility VALUES (77,66,'1');

INSERT INTO pokemon VALUES (78, 'Rapidash', 65,100, 70, 80, 80,105, false);
INSERT INTO pokeType VALUES (78,10);
INSERT INTO pokeEgg  VALUES (78,5);
INSERT INTO pokeAbility VALUES (78,66,'1');
INSERT INTO pokeAbility VALUES (78,202,'2');

-- Slowpoke line -------------------------------------------------
INSERT INTO pokemon VALUES (79, 'Slowpoke', 90, 65, 65, 40, 40, 15, true);
INSERT INTO pokeType VALUES (79,11); INSERT INTO pokeType VALUES (79,14);
INSERT INTO pokeEgg  VALUES (79,2);  INSERT INTO pokeEgg VALUES (79,8);
INSERT INTO pokeAbility VALUES (79,12,'1');

INSERT INTO pokemon VALUES (80, 'Slowbro',  95, 75,110,100, 80, 30, true);
INSERT INTO pokeType VALUES (80,11); INSERT INTO pokeType VALUES (80,14);
INSERT INTO pokeEgg  VALUES (80,2);  INSERT INTO pokeEgg VALUES (80,8);
INSERT INTO pokeAbility VALUES (80,12,'1');
INSERT INTO pokeAbility VALUES (80,211,'2'); 

-- Magnemite line -----------------------------------------------
INSERT INTO pokemon VALUES (81, 'Magnemite',25, 35, 70, 95, 55, 45, true);
INSERT INTO pokeType VALUES (81,13); INSERT INTO pokeType VALUES (81,9);
INSERT INTO pokeEgg  VALUES (81,16);
INSERT INTO pokeAbility VALUES (81,26,'1');
INSERT INTO pokeAbility VALUES (81,212,'2');

INSERT INTO pokemon VALUES (82, 'Magneton', 50, 60, 95,120, 70, 70, true);
INSERT INTO pokeType VALUES (82,13); INSERT INTO pokeType VALUES (82,9);
INSERT INTO pokeEgg  VALUES (82,16);
INSERT INTO pokeAbility VALUES (82,26,'1');
INSERT INTO pokeAbility VALUES (82,212,'2');
INSERT INTO pokeAbility VALUES (82,214,'3');

-- Farfetch’d ----------------------------------------------------
INSERT INTO pokemon VALUES (83, 'Farfetch’d',52, 90, 55, 58, 62, 60, true);
INSERT INTO pokeType VALUES (83,1); INSERT INTO pokeType VALUES (83,3);
INSERT INTO pokeEgg  VALUES (83,4); INSERT INTO pokeEgg VALUES (83,5);
INSERT INTO pokeAbility VALUES (83,51,'1');
INSERT INTO pokeAbility VALUES (83,208,'2');

-- Doduo line ----------------------------------------------------
INSERT INTO pokemon VALUES (84, 'Doduo',    35, 85, 45, 35, 35, 75, true);
INSERT INTO pokeType VALUES (84,1); INSERT INTO pokeType VALUES (84,3);
INSERT INTO pokeEgg  VALUES (84,4);
INSERT INTO pokeAbility VALUES (84,145,'1');

INSERT INTO pokemon VALUES (85, 'Dodrio',   60,110, 70, 60, 60,110, true);
INSERT INTO pokeType VALUES (85,1); INSERT INTO pokeType VALUES (85,3);
INSERT INTO pokeEgg  VALUES (85,4);
INSERT INTO pokeAbility VALUES (85,145,'1');
INSERT INTO pokeAbility VALUES (85,227,'2');

-- Seel line -----------------------------------------------------
INSERT INTO pokemon VALUES (86, 'Seel',     65, 45, 55, 45, 70, 45, false);
INSERT INTO pokeType VALUES (86,15);
INSERT INTO pokeEgg  VALUES (86,2); INSERT INTO pokeEgg VALUES (86,5);
INSERT INTO pokeAbility VALUES (86,11,'1');
INSERT INTO pokeAbility VALUES (86,219,'2');

INSERT INTO pokemon VALUES (87, 'Dewgong',  90, 70, 80, 70, 95, 70, true);
INSERT INTO pokeType VALUES (87,15); INSERT INTO pokeType VALUES (87,11);
INSERT INTO pokeEgg  VALUES (87,2); INSERT INTO pokeEgg VALUES (87,5);
INSERT INTO pokeAbility VALUES (87,11,'1');
INSERT INTO pokeAbility VALUES (87,219,'2');
INSERT INTO pokeAbility VALUES (87,220,'3');

-- Grimer line ---------------------------------------------------
INSERT INTO pokemon VALUES (88, 'Grimer',   80, 80, 50, 40, 50, 25, false);
INSERT INTO pokeType VALUES (88,4);
INSERT INTO pokeEgg  VALUES (88,11);
INSERT INTO pokeAbility VALUES (88,87,'1');
INSERT INTO pokeAbility VALUES (88,215,'2');

INSERT INTO pokemon VALUES (89, 'Muk',      105,105, 75, 65,100, 50, false);
INSERT INTO pokeType VALUES (89,4);
INSERT INTO pokeEgg  VALUES (89,11);
INSERT INTO pokeAbility VALUES (89,87,'1');
INSERT INTO pokeAbility VALUES (89,215,'2'); 
INSERT INTO pokeAbility VALUES (89,216,'3'); 

-- Shellder line -------------------------------------------------
INSERT INTO pokemon VALUES (90, 'Shellder', 30, 65,100, 45, 25, 40, false);
INSERT INTO pokeType VALUES (90,11);
INSERT INTO pokeEgg  VALUES (90,12);
INSERT INTO pokeAbility VALUES (90,75,'1'); 
INSERT INTO pokeAbility VALUES (90,218,'2'); 

INSERT INTO pokemon VALUES (91, 'Cloyster', 50, 95,180, 85, 45, 70, true);
INSERT INTO pokeType VALUES (91,11); INSERT INTO pokeType VALUES (91,15);
INSERT INTO pokeEgg  VALUES (91,12);
INSERT INTO pokeAbility VALUES (91,75,'1');
INSERT INTO pokeAbility VALUES (91,218,'2');

-- Gastly -------------------------------
INSERT INTO pokemon VALUES (92, 'Gastly',   30, 35, 30,100, 35, 80, true);
INSERT INTO pokeType VALUES (92,8); INSERT INTO pokeType VALUES (92,4);
INSERT INTO pokeEgg  VALUES (92,11);
INSERT INTO pokeAbility VALUES (92,26,'1'); 
INSERT INTO pokeAbility VALUES (92,209,'2');  

INSERT INTO pokemon VALUES (93, 'Haunter',  45, 50, 45,115, 55, 95, true);
INSERT INTO pokeType VALUES (93,8); INSERT INTO pokeType VALUES (93,4);
INSERT INTO pokeEgg  VALUES (93,11);
INSERT INTO pokeAbility VALUES (93,26,'1');
INSERT INTO pokeAbility VALUES (93,209,'2'); 

INSERT INTO pokemon VALUES (94, 'Gengar', 60, 65, 60, 130, 75, 110, true);
INSERT INTO pokeType VALUES (94,8); INSERT INTO pokeType VALUES (94,4);
INSERT INTO pokeEgg VALUES (94,11);
INSERT INTO pokeAbility VALUES (94,26,'1');

-- Onix ----------------------------------------------------------
INSERT INTO pokemon VALUES (95, 'Onix',     35, 45,160, 30, 45, 70, true);
INSERT INTO pokeType VALUES (95,6); INSERT INTO pokeType VALUES (95,5);
INSERT INTO pokeEgg  VALUES (95,10);
INSERT INTO pokeAbility VALUES (95,75,'1');
INSERT INTO pokeAbility VALUES (95,212,'2');
INSERT INTO pokeAbility VALUES (95,213,'3');

-- Drowzee -------------------------------------------------------
INSERT INTO pokemon VALUES (96, 'Drowzee',  60, 48, 45, 43, 90, 42, false);
INSERT INTO pokeType VALUES (96,14);
INSERT INTO pokeEgg  VALUES (96,8);
INSERT INTO pokeAbility VALUES (96,12,'1');
INSERT INTO pokeAbility VALUES (96,209,'2');

-- Jynx -----------------------------------------------------
INSERT INTO pokemon VALUES (124, 'Jynx', 65, 50, 35, 115, 95, 95, true);
INSERT INTO pokeType VALUES (124,15); INSERT INTO pokeType VALUES (124,14);
INSERT INTO pokeEgg VALUES (124,8);
INSERT INTO pokeAbility VALUES (124,12,'1');
INSERT INTO pokeAbility VALUES (124,108,'2');
INSERT INTO pokeAbility VALUES (124,87,'3');

-- Omastar -----------------------------------------------------
INSERT INTO pokemon VALUES (139, 'Omastar', 70, 60, 125, 115, 70, 55, true);
INSERT INTO pokeType VALUES (139,6); INSERT INTO pokeType VALUES (139,11);
INSERT INTO pokeEgg VALUES (139,2); INSERT INTO pokeEgg VALUES (139,9);
INSERT INTO pokeAbility VALUES (139,33,'1');
INSERT INTO pokeAbility VALUES (139,75,'2');
INSERT INTO pokeAbility VALUES (139,133,'3');

-- Articuno ------------------------------------------------------
INSERT INTO pokemon VALUES (144, 'Articuno', 90, 85, 100, 95, 125, 85, true);
INSERT INTO pokeType VALUES (144,15); INSERT INTO pokeType VALUES (144,3);
INSERT INTO pokeEgg VALUES (144,15);
INSERT INTO pokeAbility VALUES (144,46,'1');  -- Pressure (ejemplo, ajusta si tu set difiere)

-- Zapdos --------------------------------------------------------
INSERT INTO pokemon VALUES (145, 'Zapdos', 90, 90, 85, 125, 90, 100, true);
INSERT INTO pokeType VALUES (145,13); INSERT INTO pokeType VALUES (145,3);
INSERT INTO pokeEgg VALUES (145,15);
INSERT INTO pokeAbility VALUES (145,46,'1');  -- Pressure

-- Moltres -------------------------------------------------------
INSERT INTO pokemon VALUES (146, 'Moltres', 90, 100, 90, 125, 85, 90, true);
INSERT INTO pokeType VALUES (146,10); INSERT INTO pokeType VALUES (146,3);
INSERT INTO pokeEgg VALUES (146,15);
INSERT INTO pokeAbility VALUES (146,46,'1');  -- Pressure


-- Metagross -----------------------------------------------------
INSERT INTO pokemon VALUES (376, 'Metagross', 80, 135, 130, 95, 90, 70, true);
INSERT INTO pokeType VALUES (376,9); INSERT INTO pokeType VALUES (376,14);
INSERT INTO pokeEgg VALUES (376,16);
INSERT INTO pokeAbility VALUES (376,29,'1');
INSERT INTO pokeAbility VALUES (376,135,'3');

-- Hydreigon -----------------------------------------------------
INSERT INTO pokemon VALUES (635, 'Hydreigon', 92, 105, 90, 125, 90, 98, true);
INSERT INTO pokeType VALUES (635,16); INSERT INTO pokeType VALUES (635,17);
INSERT INTO pokeEgg VALUES (635,14);
INSERT INTO pokeAbility VALUES (635,26,'1');


-- Moves Section

-- Bulbasaur line
INSERT INTO pokeMoves VALUES (1,  1, 1);  -- Tackle
INSERT INTO pokeMoves VALUES (1,  2, 2);  -- Growl
INSERT INTO pokeMoves VALUES (1,  3, 3);  -- Vine Whip
INSERT INTO pokeMoves VALUES (1, 27, 4);  -- Razor Leaf

INSERT INTO pokeMoves VALUES (2,  1, 1);
INSERT INTO pokeMoves VALUES (2,  3, 2);
INSERT INTO pokeMoves VALUES (2, 27, 3);
INSERT INTO pokeMoves VALUES (2, 12, 4);  -- Psychic

INSERT INTO pokeMoves VALUES (3,  1, 1);
INSERT INTO pokeMoves VALUES (3, 27, 2);
INSERT INTO pokeMoves VALUES (3, 20, 3);  -- Sleep Powder
INSERT INTO pokeMoves VALUES (3, 15, 4);  -- Hyper Beam

-- Charmander line
INSERT INTO pokeMoves VALUES (4, 33, 1);  -- Scratch
INSERT INTO pokeMoves VALUES (4,  2, 2);  -- Growl
INSERT INTO pokeMoves VALUES (4,  4, 3);  -- Ember
INSERT INTO pokeMoves VALUES (4, 16, 4);  -- Slash

INSERT INTO pokeMoves VALUES (5, 33, 1);
INSERT INTO pokeMoves VALUES (5,  4, 2);
INSERT INTO pokeMoves VALUES (5, 26, 3);  -- Flamethrower
INSERT INTO pokeMoves VALUES (5, 16, 4);

INSERT INTO pokeMoves VALUES (6, 33, 1);
INSERT INTO pokeMoves VALUES (6, 26, 2);
INSERT INTO pokeMoves VALUES (6, 31, 3);  -- Wing Attack
INSERT INTO pokeMoves VALUES (6, 15, 4);

-- Squirtle line
INSERT INTO pokeMoves VALUES (7,  1, 1);
INSERT INTO pokeMoves VALUES (7,  5, 2);  -- Water Gun
INSERT INTO pokeMoves VALUES (7, 32, 3);  -- Bubble
INSERT INTO pokeMoves VALUES (7, 25, 4);  -- Surf

INSERT INTO pokeMoves VALUES (8,  1, 1);
INSERT INTO pokeMoves VALUES (8,  5, 2);
INSERT INTO pokeMoves VALUES (8, 25, 3);
INSERT INTO pokeMoves VALUES (8, 15, 4);

INSERT INTO pokeMoves VALUES (9,  1, 1);
INSERT INTO pokeMoves VALUES (9, 25, 2);
INSERT INTO pokeMoves VALUES (9, 13, 3);  -- Earthquake
INSERT INTO pokeMoves VALUES (9, 15, 4);

-- Caterpie line
INSERT INTO pokeMoves VALUES (10, 1, 1);
INSERT INTO pokeMoves VALUES (10,18, 2);  -- String Shot
INSERT INTO pokeMoves VALUES (10,19, 3);  -- Harden
INSERT INTO pokeMoves VALUES (10, 2, 4);

INSERT INTO pokeMoves VALUES (11,19, 1);
INSERT INTO pokeMoves VALUES (11,18, 2);
INSERT INTO pokeMoves VALUES (11, 1, 3);
INSERT INTO pokeMoves VALUES (11, 2, 4);

INSERT INTO pokeMoves VALUES (12,11, 1);  -- Confusion
INSERT INTO pokeMoves VALUES (12,20, 2);  -- Sleep Powder
INSERT INTO pokeMoves VALUES (12, 7, 3);  -- Ice Beam
INSERT INTO pokeMoves VALUES (12, 15, 4);

-- Weedle line
INSERT INTO pokeMoves VALUES (13,17, 1);   -- Weedle     → Poison Sting
INSERT INTO pokeMoves VALUES (14,19, 1);   -- Kakuna     → Harden
INSERT INTO pokeMoves VALUES (15,17, 1);   -- Beedrill   → Poison Sting

-- Pidgey line
INSERT INTO pokeMoves VALUES (16, 1, 1);
INSERT INTO pokeMoves VALUES (16, 9, 2);  -- Gust
INSERT INTO pokeMoves VALUES (16, 8, 3);  -- Quick Attack
INSERT INTO pokeMoves VALUES (16,31, 4);

INSERT INTO pokeMoves VALUES (17, 1, 1);
INSERT INTO pokeMoves VALUES (17, 9, 2);
INSERT INTO pokeMoves VALUES (17,31, 3);
INSERT INTO pokeMoves VALUES (17,15, 4);

INSERT INTO pokeMoves VALUES (18, 1, 1);
INSERT INTO pokeMoves VALUES (18,31, 2);
INSERT INTO pokeMoves VALUES (18,15, 3);
INSERT INTO pokeMoves VALUES (18, 9, 4);
-- Rattata line
INSERT INTO pokeMoves VALUES (19, 1, 1);   -- Rattata    → Tackle
INSERT INTO pokeMoves VALUES (20,16, 1);   -- Raticate   → Slash

-- Spearow line
INSERT INTO pokeMoves VALUES (21,10, 1);   -- Spearow    → Peck
INSERT INTO pokeMoves VALUES (22,31, 1);   -- Fearow     → Wing Attack

-- Ekans line
INSERT INTO pokeMoves VALUES (23,17, 1);   -- Ekans      → Poison Sting
INSERT INTO pokeMoves VALUES (24,16, 1);   -- Arbok      → Slash

-- Pikachu line
INSERT INTO pokeMoves VALUES (25,28, 1);  -- ThunderShock
INSERT INTO pokeMoves VALUES (25, 8, 2);
INSERT INTO pokeMoves VALUES (25, 6, 3);  -- Thunderbolt
INSERT INTO pokeMoves VALUES (25,15, 4);
INSERT INTO pokeMoves VALUES (26, 6, 1);   -- Raichu     → Thunderbolt

-- Sandshrew line
INSERT INTO pokeMoves VALUES (27,13, 1);   -- Sandshrew  → Earthquake
INSERT INTO pokeMoves VALUES (28,13, 1);   -- Sandslash  → Earthquake

-- Nidoran♀ line
INSERT INTO pokeMoves VALUES (29,17, 1);   -- Nidoran♀   → Poison Sting
INSERT INTO pokeMoves VALUES (30,17, 1);   -- Nidorina   → Poison Sting
INSERT INTO pokeMoves VALUES (31,13, 1);   -- Nidoqueen  → Earthquake

-- Nidoran♂ line
INSERT INTO pokeMoves VALUES (32,17, 1);   -- Nidoran♂   → Poison Sting
INSERT INTO pokeMoves VALUES (33,16, 1);   -- Nidorino   → Slash
INSERT INTO pokeMoves VALUES (34,13, 1);   -- Nidoking   → Earthquake

-- Clefairy line
INSERT INTO pokeMoves VALUES (35,12, 1);   -- Clefairy   → Psychic
INSERT INTO pokeMoves VALUES (36,12, 1);   -- Clefable   → Psychic

-- Vulpix line
INSERT INTO pokeMoves VALUES (37, 4, 1);   -- Vulpix     → Ember
INSERT INTO pokeMoves VALUES (38,26, 1);   -- Ninetales  → Flamethrower

-- Jigglypuff line
INSERT INTO pokeMoves VALUES (39, 2, 1);   -- Jigglypuff → Growl
INSERT INTO pokeMoves VALUES (40,15, 1);   -- Wigglytuff → Hyper Beam

-- Zubat line
INSERT INTO pokeMoves VALUES (41,10, 1);   -- Zubat      → Peck
INSERT INTO pokeMoves VALUES (42,31, 1);   -- Golbat     → Wing Attack

-- Oddish line
INSERT INTO pokeMoves VALUES (43, 3, 1);   -- Oddish     → Vine Whip
INSERT INTO pokeMoves VALUES (44,27, 1);   -- Gloom      → Razor Leaf
INSERT INTO pokeMoves VALUES (45,27, 1);   -- Vileplume  → Razor Leaf

-- Paras line
INSERT INTO pokeMoves VALUES (46, 3, 1);   -- Paras      → Vine Whip
INSERT INTO pokeMoves VALUES (47,27, 1);   -- Parasect   → Razor Leaf

-- Venonat line
INSERT INTO pokeMoves VALUES (48,18, 1);   -- Venonat    → String Shot
INSERT INTO pokeMoves VALUES (49,11, 1);   -- Venomoth   → Confusion

-- Diglett line
INSERT INTO pokeMoves VALUES (50,13, 1);   -- Diglett    → Earthquake
INSERT INTO pokeMoves VALUES (51,13, 1);   -- Dugtrio    → Earthquake

-- Meowth line
INSERT INTO pokeMoves VALUES (52, 1, 1);   -- Meowth     → Tackle
INSERT INTO pokeMoves VALUES (53,16, 1);   -- Persian    → Slash

-- Psyduck line
INSERT INTO pokeMoves VALUES (54, 5, 1);   -- Psyduck    → Water Gun
INSERT INTO pokeMoves VALUES (55,25, 1);   -- Golduck    → Surf

-- Mankey line
INSERT INTO pokeMoves VALUES (56,30, 1);   -- Mankey     → Karate Chop
INSERT INTO pokeMoves VALUES (57,29, 1);   -- Primeape   → Double Kick

-- Growlithe line
INSERT INTO pokeMoves VALUES (58, 4, 1);   -- Growlithe  → Ember
INSERT INTO pokeMoves VALUES (59,26, 1);   -- Arcanine   → Flamethrower

-- Poliwag line
INSERT INTO pokeMoves VALUES (60,32, 1);   -- Poliwag    → Bubble
INSERT INTO pokeMoves VALUES (61, 5, 1);   -- Poliwhirl  → Water Gun
INSERT INTO pokeMoves VALUES (62,25, 1);   -- Poliwrath  → Surf

-- Abra line
INSERT INTO pokeMoves VALUES (63,34, 1);   -- Abra       → Teleport
INSERT INTO pokeMoves VALUES (64,11, 1);   -- Kadabra    → Confusion
INSERT INTO pokeMoves VALUES (65,12, 1);   -- Alakazam   → Psychic

-- Machop line
INSERT INTO pokeMoves VALUES (66,30, 1);   -- Machop     → Karate Chop
INSERT INTO pokeMoves VALUES (67,29, 1);   -- Machoke    → Double Kick
INSERT INTO pokeMoves VALUES (68,13, 1);   -- Machamp    → Earthquake

-- Bellsprout line
INSERT INTO pokeMoves VALUES (69, 3, 1);   -- Bellsprout → Vine Whip
INSERT INTO pokeMoves VALUES (70,27, 1);   -- Weepinbell → Razor Leaf
INSERT INTO pokeMoves VALUES (71,27, 1);   -- Victreebel → Razor Leaf

-- Tentacool line
INSERT INTO pokeMoves VALUES (72, 5, 1);   -- Tentacool  → Water Gun
INSERT INTO pokeMoves VALUES (73,25, 1);   -- Tentacruel → Surf

-- Geodude line
INSERT INTO pokeMoves VALUES (74,14, 1);   -- Geodude    → Rock Slide
INSERT INTO pokeMoves VALUES (75,13, 1);   -- Graveler   → Earthquake
INSERT INTO pokeMoves VALUES (76,14, 1);   -- Golem      → Rock Slide

-- Ponyta line
INSERT INTO pokeMoves VALUES (77, 4, 1);   -- Ponyta     → Ember
INSERT INTO pokeMoves VALUES (78,26, 1);   -- Rapidash   → Flamethrower

-- Slowpoke line
INSERT INTO pokeMoves VALUES (79,11, 1);   -- Slowpoke   → Confusion
INSERT INTO pokeMoves VALUES (80,12, 1);   -- Slowbro    → Psychic

-- Magnemite line
INSERT INTO pokeMoves VALUES (81,28, 1);   -- Magnemite  → ThunderShock
INSERT INTO pokeMoves VALUES (82, 6, 1);   -- Magneton   → Thunderbolt

-- Farfetch’d
INSERT INTO pokeMoves VALUES (83,31, 1);   -- Farfetch’d → Wing Attack

-- Doduo line
INSERT INTO pokeMoves VALUES (84,31, 1);   -- Doduo      → Wing Attack
INSERT INTO pokeMoves VALUES (85,16, 1);   -- Dodrio     → Slash

-- Seel line
INSERT INTO pokeMoves VALUES (86, 7, 1);   -- Seel       → Ice Beam
INSERT INTO pokeMoves VALUES (87,36, 1);   -- Dewgong    → Blizzard

-- Grimer line
INSERT INTO pokeMoves VALUES (88,17, 1);   -- Grimer     → Poison Sting
INSERT INTO pokeMoves VALUES (89,13, 1);   -- Muk        → Earthquake

-- Shellder line
INSERT INTO pokeMoves VALUES (90, 5, 1);   -- Shellder   → Water Gun
INSERT INTO pokeMoves VALUES (91,36, 1);   -- Cloyster   → Blizzard
-- Gastly line
INSERT INTO pokeMoves VALUES (92,22, 1);  -- Lick
INSERT INTO pokeMoves VALUES (92,21, 2);  -- Hypnosis
INSERT INTO pokeMoves VALUES (92,23, 3);  -- Night Shade
INSERT INTO pokeMoves VALUES (92,12, 4);

INSERT INTO pokeMoves VALUES (93,22, 1);
INSERT INTO pokeMoves VALUES (93,21, 2);
INSERT INTO pokeMoves VALUES (93,23, 3);
INSERT INTO pokeMoves VALUES (93,12, 4);

INSERT INTO pokeMoves VALUES (94,22, 1);
INSERT INTO pokeMoves VALUES (94,21, 2);
INSERT INTO pokeMoves VALUES (94,12, 3);
INSERT INTO pokeMoves VALUES (94,15, 4);
-- Onix
INSERT INTO pokeMoves VALUES (95,14, 1);   -- Onix       → Rock Slide

-- Drowzee
INSERT INTO pokeMoves VALUES (96,11, 1);   -- Drowzee    → Confusion

-- Jynx
INSERT INTO pokeMoves VALUES (124, 7, 1);  -- Jynx       → Ice Beam

-- Omastar
INSERT INTO pokeMoves VALUES (139,25, 1);  -- Omastar    → Surf

-- Metagross
INSERT INTO pokeMoves VALUES (376,12, 1);  -- Metagross  → Psychic

-- Hydreigon
INSERT INTO pokeMoves VALUES (635,24, 1);  -- Hydreigon  → Dragon Rage

-- Articuno
INSERT INTO pokeMoves VALUES (144, 7, 1);   -- Ice Beam
INSERT INTO pokeMoves VALUES (144,31, 2);   -- Wing Attack
INSERT INTO pokeMoves VALUES (144,36, 3);   -- Blizzard
INSERT INTO pokeMoves VALUES (144,15, 4);   -- Hyper Beam

-- Zapdos
INSERT INTO pokeMoves VALUES (145, 6, 1);   -- Thunderbolt
INSERT INTO pokeMoves VALUES (145,28, 2);   -- ThunderShock
INSERT INTO pokeMoves VALUES (145,31, 3);   -- Wing Attack
INSERT INTO pokeMoves VALUES (145,15, 4);   -- Hyper Beam

-- Moltres
INSERT INTO pokeMoves VALUES (146,26, 1);   -- Flamethrower
INSERT INTO pokeMoves VALUES (146, 4, 2);   -- Ember
INSERT INTO pokeMoves VALUES (146,31, 3);   -- Wing Attack
INSERT INTO pokeMoves VALUES (146,15, 4);   -- Hyper Beam

COMMIT;
