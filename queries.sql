-- Dashboard -1

SELECT o.order_id, i.item_price, o.quantity, i.item_cat, i.item_name, o.created_at, a.delivery_address1, a.delivery_address2, a.delivery_city, a.delivery_zipcode, o.delivery
FROM orders o
LEFT JOIN item i ON o.item_id = i.item_id
LEFT JOIN address a ON o.add_id = a.add_id;


-- Dashboard -2

-- This is a stock1

create view stock1 as
SELECT 
  s1.item_name,
  s1.ing_id,
  s1.ing_name,
  s1.ing_weight,
  s1.ing_price,
  s1.order_quantity,
  s1.recipe_quantity,
  s1.order_quantity * s1.recipe_quantity AS ordered_weight,
  s1.ing_price / s1.ing_weight AS unit_cost,
  (s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) AS ingredient_cost
FROM (
  SELECT 
    o.item_id,
    i.sku,
    i.item_name,
    r.ing_id,
    ing.ing_name,
    r.quantity AS recipe_quantity,
    SUM(o.quantity) AS order_quantity,
    ing.ing_weight,
    ing.ing_price
  FROM orders o
  LEFT JOIN item i ON o.item_id = i.item_id
  LEFT JOIN recipe r ON i.sku = r.recipie_id   -- ✅ correct spelling
  LEFT JOIN ingredient ing ON ing.ing_id = r.ing_id
  GROUP BY 
    o.item_id,
    i.sku,
    i.item_name,
    r.ing_id,
    r.quantity,
    ing.ing_name,
    ing.ing_weight,
    ing.ing_price
) s1

-- data type mismatches for this Create a Mapping Table 
CREATE TABLE id_mapping (
    ing_id VARCHAR(20),
    item_id VARCHAR(20)
);
INSERT INTO id_mapping (ing_id, item_id) VALUES
('ING001', 'it_001'),
('ING002', 'it_002'),
('ING003', 'it_003'),
('ING004', 'it_004'),
('ING005', 'it_005'),
('ING006', 'it_006'),
('ING007', 'it_007'),
('ING008', 'it_008'),
('ING009', 'it_009'),
('ING010', 'it_010'),
('ING011', 'it_011'),
('ING012', 'it_012'),
('ING013', 'it_013'),
('ING014', 'it_014'),
('ING015', 'it_015'),
('ING016', 'it_016'),
('ING017', 'it_017'),
('ING018', 'it_018'),
('ING019', 'it_019'),
('ING020', 'it_020'),
('ING021', 'it_021'),
('ING022', 'it_022'),
('ING023', 'it_023'),
('ING024', 'it_024'),
('ING025', 'it_025'),
('ING026', 'it_026'),
('ING027', 'it_027'),
('ING028', 'it_028'),
('ING029', 'it_029'),
('ING030', 'it_030'),
('ING031', 'it_031'),
('ING032', 'it_032'),
('ING033', 'it_033'),
('ING034', 'it_034'),
('ING035', 'it_035'),
('ING036', 'it_036'),
('ING037', 'it_037'),
('ING038', 'it_038'),
('ING039', 'it_039'),
('ING040', 'it_040'),
('ING041', 'it_041'),
('ING042', 'it_042');

-- This Caluculate Orderd weight | Total weight | Remaing weight

SELECT s2.ing_name,
       s2.ordered_weight,
       ing.ing_weight * inv.quantity AS total_inv_weight,
       ing.ing_weight * inv.quantity-s2.ordered_weight as remaining_weight
FROM (
    SELECT ing_id,
           ing_name,
           SUM(ordered_weight) AS ordered_weight
    FROM stock1 
    GROUP BY ing_name, ing_id
) s2
LEFT JOIN id_mapping map ON map.ing_id = s2.ing_id
LEFT JOIN inventory inv ON inv.item_id = map.item_id
LEFT JOIN ingredient ing ON ing.ing_id = s2.ing_id;

-- This Caluculate pay for each employee based on there hourly rate

SELECT  
    r.date,
    s.first_name,
    s.last_name,
    s.hourly_rate,
    sh.start_time,
    sh.end_time,
    ((HOUR(TIMEDIFF(sh.end_time, sh.start_time)) * 60) + 
     MINUTE(TIMEDIFF(sh.end_time, sh.start_time))) / 60 AS hours_in_shift,
    (((HOUR(TIMEDIFF(sh.end_time, sh.start_time)) * 60) + 
      MINUTE(TIMEDIFF(sh.end_time, sh.start_time))) / 60) * s.hourly_rate AS staff_cost
FROM roat r
LEFT JOIN staff s ON r.staff_id = s.staff_id
LEFT JOIN shift sh ON r.shift_id = sh.shift_id
LIMIT 0, 1000;
