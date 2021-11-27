create schema olist;

create table olist.orders
(
    order_id varchar(32) not null primary key,
    customer_id varchar(32) not null,
    order_status varchar(16),
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);

create table olist.order_reviews
(
    review_id varchar(32) not null primary key,
    order_id varchar(32) not null,
    review_comment_title text,
    review_comment_message text,
    review_creation_date timestamp,
    review_answer_timestamp timestamp
);

create table olist.order_items
(
    order_id varchar(32) not null,
    order_item_id int not null,
    product_id varchar(32) not null,
    seller_id varchar(32) not null,
    shipping_limit_date timestamp,
    price float,
    freight_value float
);

create table olist.order_payments
(
    order_id varchar(32) not null,
    payment_sequential int,
    payment_type varchar(32),
    payment_installments int,
    payment_value float
);

create table olist.products
(
    product_id varchar(32) not null primary key,
    product_category_name varchar(32),
    product_name_lenght int,
    product_description_lenght int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int
);

create table olist.product_category_name_translation
(
    product_category_name varchar(32) not null primary key,
    product_category_name_english varchar(32)
);

create table olist.customers
(
    customer_id varchar(32) not null primary key,
    customer_unique_id varchar(32) not null,
    customer_zip_code int,
    customer_city varchar(32),
    customer_state varchar(32)
);

create table olist.sellers
(
    seller_id varchar(32) not null primary key,
    seller_zip_code_prefix int,
    seller_city varchar(32),
    seller_state varchar(32)
);

create table olist.geolocation
(
    geolocation_zip_code int not null primary key,
    geolocation_lat float,
    geolocation_lng float,
    geolocation_city varchar(32),
    geolocation_state varchar(32)
);



