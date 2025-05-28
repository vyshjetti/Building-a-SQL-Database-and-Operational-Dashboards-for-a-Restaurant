-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/8fxEtP
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Table Creation
CREATE TABLE `orders` (
    `row_id` INT NOT NULL,
    `order_id` VARCHAR(10) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `quantity` INT NOT NULL,
    `cust_id` INT NOT NULL,
    `add_id` INT NOT NULL,
    `item_id` VARCHAR(10) NOT NULL,
    `delivery` BOOLEAN NOT NULL,
    PRIMARY KEY (
        `row_id`
    )
);

CREATE TABLE `customers` (
    `cust_id` INT NOT NULL,
    `cust_firstname` VARCHAR(50) NOT NULL,
    `cust_lastname` VARCHAR(50) NOT NULL,
    PRIMARY KEY (
        `cust_id`
    )
);

CREATE TABLE `address` (
    `add_id` INT NOT NULL,
    `delivery_address1` VARCHAR(200) NOT NULL,
    `delivery_address2` VARCHAR(200) NULL,
    `delivery_city` VARCHAR(50) NOT NULL,
    `delivery_zipcode` VARCHAR(20) NOT NULL,
    PRIMARY KEY (
        `add_id`
    )
);

CREATE TABLE `item` (
    `item_id` VARCHAR(10) NOT NULL,
    `sku` VARCHAR(20) NOT NULL,
    `item_name` VARCHAR(50) NOT NULL,
    `item_cat` VARCHAR(50) NOT NULL,
    `item_size` VARCHAR(20) NOT NULL,
    `item_price` DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (
        `item_id`
    ),
    UNIQUE KEY `uk_item_sku` (`sku`) -- Added UNIQUE constraint for sku to be referenced by recipe
);

CREATE TABLE `ingredient` (
    `ing_id` VARCHAR(10) NOT NULL,
    `ing_name` VARCHAR(200) NOT NULL,
    `ing_weight` INT NOT NULL,
    `ing_meas` VARCHAR(20) NOT NULL,
    `ing_price` DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (
        `ing_id`
    )
);

CREATE TABLE `recipe` (
    `row_id` INT NOT NULL,
    `recipie_id` VARCHAR(20) NOT NULL, -- Assuming this is meant to be 'recipe_id'
    `ing_id` VARCHAR(10) NOT NULL,
    `quantity` INT NOT NULL,
    PRIMARY KEY (
        `row_id`
    )
);

CREATE TABLE `inventory` (
    `inv_id` INT NOT NULL,
    `item_id` VARCHAR(10) NOT NULL,
    `quantity` INT NOT NULL,
    PRIMARY KEY (
        `inv_id`
    )
);

CREATE TABLE `staff` (
    `staff_id` VARCHAR(20) NOT NULL,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `position` VARCHAR(100) NOT NULL,
    `hourly_rate` DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (
        `staff_id`
    )
);

CREATE TABLE `shift` (
    `shift_id` VARCHAR(20) NOT NULL,
    `day_of_week` VARCHAR(10) NOT NULL,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    PRIMARY KEY (
        `shift_id`
    )
);

CREATE TABLE `roat` ( -- Assuming 'roat' means 'roster' or 'rota'
    `row_id` INT NOT NULL,
    `roat_id` VARCHAR(20) NOT NULL,
    `date` DATETIME NOT NULL,
    `shift_id` VARCHAR(20) NOT NULL,
    `staff_id` VARCHAR(20) NOT NULL,
    PRIMARY KEY (
        `row_id`
    )
);

-- Add Indexes for Foreign Key Columns (where not already a PRIMARY KEY or UNIQUE)
-- These are for the columns in the *referencing* table if they are not already indexed.
-- MySQL usually adds an index automatically for the FK column, but it's good practice
-- to be explicit or ensure the referenced column is indexed.

-- Foreign Key Constraints (Corrected Directions and Added Indexes)

-- orders.cust_id references customers.cust_id
ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_cust_id` FOREIGN KEY(`cust_id`)
REFERENCES `customers` (`cust_id`);

-- orders.add_id references address.add_id
ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_add_id` FOREIGN KEY(`add_id`)
REFERENCES `address` (`add_id`);

-- orders.item_id references item.item_id
ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_item_id` FOREIGN KEY(`item_id`)
REFERENCES `item` (`item_id`);

-- recipe.ing_id references ingredient.ing_id
ALTER TABLE `recipe` ADD CONSTRAINT `fk_recipe_ing_id` FOREIGN KEY(`ing_id`)
REFERENCES `ingredient` (`ing_id`);

-- recipe.recipie_id references item.sku (item.sku must be UNIQUE)
ALTER TABLE `recipe` ADD CONSTRAINT `fk_recipe_item_sku` FOREIGN KEY(`recipie_id`)
REFERENCES `item` (`sku`);

-- inventory.item_id references item.item_id
ALTER TABLE `inventory` ADD CONSTRAINT `fk_inventory_item_id` FOREIGN KEY(`item_id`)
REFERENCES `item` (`item_id`);

-- roat.shift_id references shift.shift_id
ALTER TABLE `roat` ADD CONSTRAINT `fk_roat_shift_id` FOREIGN KEY(`shift_id`)
REFERENCES `shift` (`shift_id`);

-- roat.staff_id references staff.staff_id
ALTER TABLE `roat` ADD CONSTRAINT `fk_roat_staff_id` FOREIGN KEY(`staff_id`)
REFERENCES `staff` (`staff_id`);





-- Removed: fk_roat_date referencing orders.created_at.
-- This was removed because 'orders.created_at' is a datetime and is unlikely to be unique,
-- which is a requirement for a referenced column in a foreign key.
-- If you need to link roster entries to specific orders, consider adding
-- an 'order_id' column to 'roat' that references 'orders.order_id' (if orders.order_id is unique).



