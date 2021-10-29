DELIMITER $$
CREATE PROCEDURE invest_ideas__get(
name varchar(100), /* - название идеи , проверяется точное вхождение в строку в любом месте, чтобы не фильтровать по названию, необходимо передать NULL*/
description varchar(100),  /* - описание идеи, подсчитывается вхождение каждого слова в описании, чем больше тем выше рейтинг по которому впоследствии отсортирует от большего к меньшему записи */
target_profit_gte float(24), /* - наименьший целевой доход, задается  числом с плавающей запятой в %, чтобы не фильтровать - необходимо передать NULL */
target_profit_lte float(24), /* - наибольший целевой доход, задается  числом с плавающей запятой в процентах,  чтобы не фильтровать - необходимо передать NULL */
idea_source varchar(100) /* - источник идеи , проверяется точное вхождение в строку в любом месте, чтобы не фильтровать по названию, необходимо передать NULL */
)
BEGIN

    SET name = IFNULL(name, '');
    SET description = IFNULL(description, '');
    SET target_profit_gte = IFNULL(target_profit_gte ,-10000.0);
    SET target_profit_lte = IFNULL(target_profit_lte , 10000.0);
    SET idea_source = IFNULL(idea_source , '');

    Select 
       ii.id as id, /* - Порядковый номер в таблице, начинается с 1 */
       ii.name as name, /* - Титульное имя идеи, заголовок */
       ii.description as description, /* - Подробное описание идеи */
       ii.price_at_start as price_at_start, /* - Цена акций в момент публикации идеи, не может быть отрицательной, выражена в рубля */
       ii.current_price as current_price, /* - Цена акций на текущий момент, не может быть отрицательной, выражена в рублях */
       ii.target_price as target_price, /* - Целевая цена акций планируемая на дату завершения срока идеи, не может быть отрицательной, выражена в рублях */
       ii.date_published as date_published, /* - Дата публикации идеи */
       ii.date_horizon as date_horizon, /* - Целевая дата для идеи, когда цена станет целевой */
       ii.idea_source as idea_source, /* - Титульное имя источник идеи */
       MATCH (ii.description ) AGAINST (CONCAT('*', description, '*') IN BOOLEAN MODE) as score, /* - Оценка количества совпадений в описании с фильтром по description, применима когда был фильтр по описанию, иначе 0 */
       (ii.target_price / ii.price_at_start * 100 - 100) as profit /* - Планируемая прибыль в процентах, рассчитывается как отношение целевой цены к стартовой цене минус 100% */

    FROM invest_ideas as ii

    WHERE ii.name like CONCAT('%', name, '%') and
      (ii.target_price / ii.price_at_start * 100 - 100) between target_profit_gte  and target_profit_lte and
      ii.idea_source  like CONCAT('%', idea_source , '%');
END $$
DELIMITER ;
