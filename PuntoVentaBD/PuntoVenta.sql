CREATE TABLE state (
    state_id SMALLINT PRIMARY KEY,
    state_type VARCHAR,
    state_description TEXT
);

CREATE TABLE product_category (
    product_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR
);

CREATE TABLE unit_measure (
    unit_measure_id SERIAL PRIMARY KEY,
    unit_name VARCHAR
);

CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    product_category_id INTEGER,
    product_name VARCHAR,
    unit_measure_id INTEGER,
    package_size DECIMAL(10,2) CHECK(package_size >= 0),
    unit_price DECIMAL(10,2) CHECK(unit_price >= 0),
    FOREIGN KEY (product_category_id) REFERENCES product_category(product_category_id),
    FOREIGN KEY (unit_measure_id) REFERENCES unit_measure(unit_measure_id)
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    quantity INTEGER CHECK(quantity >= 0),
    unit_price DECIMAL(10,2) CHECK(unit_price >= 0),
    total_in_stock DECIMAL(10,2) CHECK(total_in_stock >= 0),
    total_sold DECIMAL(10,2) CHECK(total_sold >= 0),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE payment_method (
    payment_method_id SMALLINT PRIMARY KEY,
    method_type VARCHAR
);

CREATE TABLE user_account (
    user_account_id SERIAL PRIMARY KEY,
    user_name VARCHAR,
    user_last_name VARCHAR,
    user_second_last_name VARCHAR,
    email VARCHAR UNIQUE,
    password VARCHAR,
    state_id SMALLINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (state_id) REFERENCES state(state_id)
);

CREATE TABLE supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR,
    phone VARCHAR,
    email VARCHAR,
    address TEXT
);

CREATE TABLE purchase (
    purchase_id SERIAL PRIMARY KEY,
    user_account_id INTEGER,
    supplier_id INTEGER,
    total_payment DECIMAL(10,2) CHECK(total_payment >= 0),
    payment_method_id SMALLINT,
    purchase_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id)
);

CREATE TABLE purchase_detail (
    purchase_id INTEGER,
    consecutive SMALLINT,
    product_id INTEGER,
    quantity INTEGER CHECK(quantity >= 0),
    unit_price DECIMAL(10,2) CHECK(unit_price >= 0),
    total_price DECIMAL(10,2) CHECK(total_price >= 0),
    PRIMARY KEY (purchase_id, consecutive),
    FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE permission (
    permission_id SMALLINT PRIMARY KEY,
    permission_type VARCHAR,
    permission_description TEXT
);

CREATE TABLE module (
    module_id SMALLINT PRIMARY KEY,
    module_name VARCHAR,
    module_description TEXT
);

CREATE TABLE profile (
    profile_id SMALLINT PRIMARY KEY,
    profile_type VARCHAR,
    profile_description TEXT
);

CREATE TABLE profile_detail (
    user_account_id INTEGER,
    consecutive SMALLINT,
    module_id INTEGER,
    profile_id INTEGER,
    permission_id INTEGER,
    PRIMARY KEY (user_account_id, consecutive),
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id),
    FOREIGN KEY (module_id) REFERENCES module(module_id),
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id),
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
);

CREATE TABLE user_detail (
    user_account_id INTEGER,
    consecutive SMALLINT,
    profile_id INTEGER,
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    PRIMARY KEY (user_account_id, consecutive),
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id),
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id)
);

CREATE TABLE sale (
    sale_id SERIAL PRIMARY KEY,
    user_account_id INTEGER,
    payment_method_id SMALLINT,
    sale_date DATE DEFAULT CURRENT_DATE,
    total_payment DECIMAL(10,2) CHECK(total_payment >= 0),
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id)
);

CREATE TABLE sale_detail (
    sale_id INTEGER,
    consecutive SMALLINT,
    product_id INTEGER,
    quantity INTEGER CHECK(quantity >= 0),
    unit_price DECIMAL(10,2) CHECK(unit_price >= 0),
    total_price DECIMAL(10,2) CHECK(total_price >= 0),
    PRIMARY KEY (sale_id, consecutive),
    FOREIGN KEY (sale_id) REFERENCES sale(sale_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Estados ya definidos
INSERT INTO state (state_id, state_type, state_description) VALUES
(1, 'activo', 'Usuario activo'),
(2, 'inactivo', 'Usuario desactivado temporalmente'),
(3, 'bloqueado', 'Usuario bloqueado por seguridad'),
(4, 'pendiente', 'Usuario registrado pero no verificado o compras pendientes'),
(5, 'completado', 'Compra o venta completada'),
(6, 'cancelado', 'Compra o venta cancelada'),
(7, 'disponible', 'Productos disponibles'),
(8, 'casi agotado', 'Productos casi agotados'),
(9, 'agotado', 'Productos agotados');

-- Categorías de producto
INSERT INTO product_category (category_name) VALUES
('Bebidas'),
('Alimentos'),
('Higiene'),
('Limpieza');

-- Unidades de medida
INSERT INTO unit_measure (unit_name) VALUES
('litro'),
('kilogramo'),
('unidad'),
('caja');

-- Productos
INSERT INTO product (product_category_id, product_name, unit_measure_id, package_size, unit_price) VALUES
(1, 'Coca-Cola', 1, 2.0, 20.0),
(1, 'Pepsi', 1, 2.0, 19.0),
(2, 'Pan de caja', 2, 0.5, 15.0),
(3, 'Jabón de tocador', 3, 1, 5.0),
(4, 'Detergente líquido', 4, 3.0, 35.0);

-- Inventario
INSERT INTO inventory (product_id, quantity, unit_price, total_in_stock, total_sold) VALUES
(1, 100, 20.0, 2000.0, 500.0),
(2, 80, 19.0, 1520.0, 300.0),
(3, 50, 15.0, 750.0, 150.0),
(4, 200, 5.0, 1000.0, 400.0),
(5, 30, 35.0, 1050.0, 200.0);

-- Métodos de pago
INSERT INTO payment_method (payment_method_id, method_type) VALUES
(1, 'Efectivo'),
(2, 'Tarjeta de crédito'),
(3, 'Transferencia'),
(4, 'PayPal');

-- Usuarios
INSERT INTO user_account (user_name, user_last_name, user_second_last_name, email, password, state_id) VALUES
('Juan', 'Pérez', 'Gómez', 'juanp@mail.com', '12345', 1),
('Ana', 'López', 'Martínez', 'anal@mail.com', '12345', 1),
('Carlos', 'Sánchez', 'Ramírez', 'carlos@mail.com', '12345', 2);

-- Proveedores
INSERT INTO supplier (supplier_name, phone, email, address) VALUES
('Distribuidora ABC', '5551234567', 'abc@mail.com', 'Av. Central 123'),
('Distribuidora XYZ', '5559876543', 'xyz@mail.com', 'Calle 45 #67');

-- Compras
INSERT INTO purchase (user_account_id, supplier_id, total_payment, payment_method_id) VALUES
(1, 1, 500.0, 1),
(2, 2, 350.0, 2);

-- Detalle de compras
INSERT INTO purchase_detail (purchase_id, consecutive, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 10, 20.0, 200.0),
(1, 2, 3, 20, 15.0, 300.0),
(2, 1, 2, 10, 19.0, 190.0),
(2, 2, 4, 8, 20.0, 160.0);

-- Permisos
INSERT INTO permission (permission_id, permission_type, permission_description) VALUES
(1, 'INSERT', 'Permiso para insertar información'),
(2, 'SELECT', 'Permiso para ver información'),
(3, 'UPDATE', 'Permiso para modificar información'),
(4, 'DELETE', 'Permiso para borrar información');


-- Módulos
INSERT INTO module (module_id, module_name, module_description) VALUES
(1, 'Ventas', 'Módulo de ventas'),
(2, 'Compras', 'Módulo de compras'),
(3, 'Inventario', 'Módulo de inventario');

-- Perfiles
INSERT INTO profile (profile_id, profile_type, profile_description) VALUES
(1, 'Administrador', 'Perfil con todos los permisos'),
(2, 'Vendedor', 'Perfil con permisos limitados a ventas');

-- Detalle de perfil
INSERT INTO profile_detail (user_account_id, consecutive, module_id, profile_id, permission_id) VALUES
(1, 1, 1, 1, 1),
(1, 2, 2, 1, 2),
(2, 1, 1, 2, 1),
(2, 2, 3, 2, 1);

-- Detalle de usuario
INSERT INTO user_detail (user_account_id, consecutive, profile_id, start_date, end_date) VALUES
(1, 1, 1, CURRENT_DATE, NULL),
(2, 1, 2, CURRENT_DATE, NULL);

-- Ventas
INSERT INTO sale (user_account_id, payment_method_id, total_payment) VALUES
(1, 1, 120.0),
(2, 2, 80.0);

-- Detalle de ventas
INSERT INTO sale_detail (sale_id, consecutive, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 3, 20.0, 60.0),
(1, 2, 3, 4, 15.0, 60.0),
(2, 1, 2, 4, 19.0, 76.0);


CREATE OR REPLACE FUNCTION generar_consecutivo()
RETURNS TRIGGER AS $$
DECLARE
    max_consec INTEGER;
    grupo_valor INTEGER;
BEGIN
    -- Obtener el valor de la columna que define el grupo dinámicamente
    EXECUTE format('SELECT ($1).' || TG_ARGV[0])
    INTO grupo_valor
    USING NEW;

    -- Solo asigna si no se ha especificado un consecutive
    IF NEW.consecutive IS NULL THEN
        -- Tomamos el máximo consecutive de la tabla actual
        EXECUTE format(
            'SELECT COALESCE(MAX(consecutive), 0) FROM %I WHERE %I = $1',
            TG_TABLE_NAME,
            TG_ARGV[0]
        )
        INTO max_consec
        USING grupo_valor;

        NEW.consecutive := max_consec + 1;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_consecutive_purchase_detail
BEFORE INSERT ON purchase_detail
FOR EACH ROW
EXECUTE FUNCTION generar_consecutivo('purchase_id');

CREATE TRIGGER trigger_consecutive_profile_detail
BEFORE INSERT ON profile_detail
FOR EACH ROW
EXECUTE FUNCTION generar_consecutivo('user_account_id');

CREATE TRIGGER trigger_consecutive_user_detail
BEFORE INSERT ON user_detail
FOR EACH ROW
EXECUTE FUNCTION generar_consecutivo('user_account_id');

CREATE TRIGGER trigger_consecutive_sale_detail
BEFORE INSERT ON sale_detail
FOR EACH ROW
EXECUTE FUNCTION generar_consecutivo('sale_id');
