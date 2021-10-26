CREATE TABLE `invest_ideas` (
`id` int NOT NULL AUTO_INCREMENT,
`name` varchar(100) UNIQUE NOT NULL,
`description` text,

`price_at_start` float(24) NOT NULL,
`target_price` float(24) NOT NULL,
`current_price` float(24) NOT NULL,

`date_published` date NOT NULL,
`date_horizon` date NOT NULL,

`idea_source` varchar(100) NOT NULL,
PRIMARY KEY (`id`),
FULLTEXT KEY `ii_fulltext_description` (`description`)
) ENGINE=MyISAM;
