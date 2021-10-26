DELIMITER $$
CREATE PROCEDURE invest_ideas__get(name varchar(100), description varchar(100), target_profit_gte float(24), target_profit_lte float(24), idea_source varchar(100))
BEGIN

    SET name = IFNULL(name, '');
    SET description = IFNULL(description, '');
    SET target_profit_gte = IFNULL(target_profit_gte ,-10000.0);
    SET target_profit_lte = IFNULL(target_profit_lte , 10000.0);
    SET idea_source = IFNULL(idea_source , '');

    Select ii.id as id, ii.name as name, ii.description as description,
       ii.price_at_start as price_at_start, ii.current_price as current_price,
       ii.target_price as target_price, ii.date_published as date_published,
       ii.date_horizon as date_horizon,  ii.idea_source as idea_source,
       MATCH (ii.description ) AGAINST (CONCAT('*', description, '*') IN BOOLEAN MODE) as score ,
       (ii.target_price / ii.price_at_start * 100 - 100) as profit

    FROM invest_ideas as ii

    WHERE ii.name like CONCAT('%', name, '%') and
      (ii.target_price / ii.price_at_start * 100 - 100) between target_profit_gte  and target_profit_lte and
      ii.idea_source  like CONCAT('%', idea_source , '%');
END $$
DELIMITER ;