CREATE TABLE customer (
    customer_id   INTEGER     NOT NULL,
    email         VARCHAR(50),
    passcode      VARCHAR(20) NOT NULL,
    first_name    VARCHAR(30) NOT NULL,
    last_name     VARCHAR(30),
    country_code  NUMBER(2) DEFAULT 0,
    mobile_number NUMBER(10) NOT NULL,
    dashpass      VARCHAR(10) DEFAULT 'InActive',
    PRIMARY KEY (customer_id)
);

CREATE TABLE zipcode (
    zipcode   NUMBER(6),
    city      VARCHAR(20) NOT NULL,
    state_name VARCHAR(20),
    PRIMARY KEY (zipcode)
);

CREATE TABLE address (
    address_id   INTEGER,
    street_no    INTEGER,
    street_name  VARCHAR(50) NOT NULL,
    zipcode      NUMBER(6) NOT NULL,
    customer_id  INTEGER,
    PRIMARY KEY (address_id),
    FOREIGN KEY (zipcode) REFERENCES zipcode (zipcode) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

CREATE TABLE restaurant (
    restaurant_id   INTEGER,
    restaurant_name VARCHAR(30) NOT NULL,
    cuisine_category VARCHAR(20),
    email           VARCHAR(50),
    contact_no      NUMBER(10) NOT NULL,
    rating          NUMBER(3, 2),
    PRIMARY KEY (restaurant_id)
);

CREATE TABLE reviews (
    restaurant_id      INTEGER,
    customer_id        INTEGER,
    review_description VARCHAR(500),
    rating             NUMBER(3, 2) NOT NULL,
    review_date        DATE,
    PRIMARY KEY (restaurant_id, customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

CREATE TABLE image (
    image_reference_id INTEGER,
    image_location     VARCHAR(100),
    PRIMARY KEY (image_reference_id)
);

CREATE TABLE food (
    food_id             INTEGER,
    food_name           VARCHAR(20) NOT NULL,
    food_description    VARCHAR(100),
    category            VARCHAR(20),
    options             VARCHAR(10),
    price               NUMBER(8, 2) NOT NULL,
    calorie             INTEGER,
    image_reference_id  INTEGER,
    restaurant_id       INTEGER,
    PRIMARY KEY (food_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (image_reference_id) REFERENCES image (image_reference_id) ON DELETE CASCADE
);

CREATE TABLE order_details (
    order_id             INTEGER,
    order_date           DATE      NOT NULL,
    order_time           TIMESTAMP NOT NULL,
    order_contact_number NUMBER(10) NOT NULL,
    price                NUMBER(10, 2) NOT NULL,
    tax                  NUMBER(10, 3) DEFAULT 8.025,
    promo_code           VARCHAR(30) DEFAULT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_pickup (
    order_id    INTEGER,
    customer_id INTEGER,
    PRIMARY KEY (order_id, customer_id),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES order_details (order_id) ON DELETE CASCADE
);

CREATE TABLE door_dasher (
    ssn               CHAR(9),
    dasher_name       VARCHAR(40) NOT NULL,
    driving_license_id INTEGER     NOT NULL,
    email             VARCHAR(50),
    contact_number    NUMBER(10) NOT NULL,
    rating            NUMBER(3, 2),
    orders_fulfilled  INTEGER DEFAULT 0,
    bank_account_number NUMBER(20) NOT NULL,
    PRIMARY KEY (ssn)
);

CREATE TABLE order_delivery (
    order_id            INTEGER,
    delivery_fee        NUMBER(6, 2),
    delivery_status     NUMBER(1) DEFAULT 0,
    delivery_tip        NUMBER(6, 2),
    delivery_address_id INTEGER NOT NULL,
    door_dasher_ssn      CHAR(9),
    PRIMARY KEY (order_id),
    FOREIGN KEY (delivery_address_id) REFERENCES address (address_id),
    FOREIGN KEY (order_id) REFERENCES order_details (order_id) ON DELETE CASCADE,
    FOREIGN KEY (door_dasher_ssn) REFERENCES door_dasher (ssn) ON DELETE CASCADE
);

CREATE TABLE payment (
    payment_id  INTEGER,
    customer_id INTEGER,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

CREATE TABLE card_details (
    card_no      NUMBER(16),
    cvc          NUMBER(3) NOT NULL,
    expiry_month VARCHAR(3) NOT NULL,
    expiry_year  NUMBER(4) NOT NULL,
    PRIMARY KEY (card_no)
);

CREATE TABLE card (
    payment_id INTEGER,
    card_no    NUMBER(16) NOT NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (payment_id) REFERENCES payment (payment_id) ON DELETE CASCADE,
    FOREIGN KEY (card_no) REFERENCES card_details (card_no) ON DELETE CASCADE
);

CREATE TABLE venmo (
    payment_id INTEGER,
    venmo_id   VARCHAR(30) NOT NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (payment_id) REFERENCES payment (payment_id) ON DELETE CASCADE
);

CREATE TABLE paypal (
    payment_id INTEGER,
    paypal_id  VARCHAR(30) NOT NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (payment_id) REFERENCES payment (payment_id) ON DELETE CASCADE
);

CREATE TABLE transactions (
    transaction_id   INTEGER,
    transaction_status NUMBER(1) NOT NULL,
    transaction_date DATE,
    transaction_time TIMESTAMP,
    order_id         INTEGER,
    payment_id       INTEGER,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (payment_id) REFERENCES payment (payment_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES order_details (order_id) ON DELETE CASCADE
);

CREATE TABLE offer (
    offer_id            INTEGER,
    discount_amount     NUMBER(4),
    discount_percentage NUMBER(3) DEFAULT 0.000,
    PRIMARY KEY (offer_id)
);

CREATE TABLE vehicle (
    vehicle_plate_no NUMBER(4),
    state_code       VARCHAR(5) NOT NULL,
    dasher_ssn       CHAR(9),
    vehicle_type     VARCHAR(10) DEFAULT 'Car',
    PRIMARY KEY (vehicle_plate_no),
    FOREIGN KEY (dasher_ssn) REFERENCES door_dasher (ssn) ON DELETE CASCADE
);

CREATE TABLE food_order (
    food_id INTEGER,
    order_id INTEGER,
    PRIMARY KEY (food_id, order_id),
    FOREIGN KEY (food_id) REFERENCES food (food_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES order_details (order_id) ON DELETE CASCADE
);

-- In case you need to start over
DROP TABLE IF EXISTS food_order;
DROP TABLE IF EXISTS vehicle;
DROP TABLE IF EXISTS offer;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS paypal;
DROP TABLE IF EXISTS venmo;
DROP TABLE IF EXISTS card;
DROP TABLE IF EXISTS card_details;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS order_delivery;
DROP TABLE IF EXISTS door_dasher;
DROP TABLE IF EXISTS order_pickup;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS food;
DROP TABLE IF EXISTS image;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS restaurant;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS zipcode;
DROP TABLE IF EXISTS customer;
