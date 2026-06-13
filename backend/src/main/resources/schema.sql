CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    phone VARCHAR(255),
    district VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fine_categories (
    id UUID PRIMARY KEY,
    category_code VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    amount NUMERIC(12,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS fines (
    id UUID PRIMARY KEY,
    reference_no VARCHAR(255) NOT NULL UNIQUE,
    category_id UUID NOT NULL,
    officer_id UUID NOT NULL,
    driver_name VARCHAR(255) NOT NULL,
    vehicle_no VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT fk_fines_category FOREIGN KEY (category_id) REFERENCES fine_categories (id),
    CONSTRAINT fk_fines_officer FOREIGN KEY (officer_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY,
    fine_id UUID NOT NULL UNIQUE,
    amount_paid NUMERIC(12,2) NOT NULL,
    payment_method VARCHAR(255) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    paid_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    transaction_ref VARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT fk_payments_fine FOREIGN KEY (fine_id) REFERENCES fines (id)
);

CREATE INDEX IF NOT EXISTS idx_fines_category_id ON fines(category_id);
CREATE INDEX IF NOT EXISTS idx_fines_officer_id ON fines(officer_id);
CREATE INDEX IF NOT EXISTS idx_payments_fine_id ON payments(fine_id);