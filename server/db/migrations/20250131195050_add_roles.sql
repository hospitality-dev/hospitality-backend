-- migrate:up
CREATE TABLE IF NOT EXISTS
        roles (
                id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
                created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
                updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
                deleted_at timestamp,
                title TEXT NOT NULL,
                company_id UUID REFERENCES companies (id) ON DELETE CASCADE,
                is_default BOOLEAN NOT NULL DEFAULT FALSE
        );

INSERT INTO
        roles (id, title, is_default)
VALUES
        (
                'ce9d72a4-f196-4306-acb1-f905e032222a',
                'owner',
                TRUE
        ),
        (
                '735530aa-17e9-4f74-baf1-3547dd200566',
                'general_manager',
                TRUE
        ),
        (
                'b8b9792f-353e-4fe2-a1e1-6c3b52c016f5',
                'location_manager',
                TRUE
        ),
        (
                '7e8e9ae7-cb07-493c-acab-4952a637f107',
                'human_relations',
                TRUE
        ),
        (
                '48996e0f-8ee4-4a96-aed8-caf9c107509d',
                'head_chef',
                TRUE
        ),
        (
                '2ccab95a-ce95-4115-96f6-879457f02f84',
                'chef',
                TRUE
        ),
        (
                'd4d256f3-da01-4b00-a144-53e6c1f5fd44',
                'receptionist',
                TRUE
        ),
        (
                'cee98f61-e36d-47ea-a339-1b2d229975e9',
                'housekeeping',
                TRUE
        ),
        (
                '9663491f-fdab-4b70-881c-ae2ad3a6ac74',
                'maintenance',
                TRUE
        ),
        (
                '12915dc4-7012-4b90-9d20-ccc3e93f2b90',
                'accounting',
                TRUE
        ),
        (
                '4a23add1-c035-42e4-ae16-8225d45f5185',
                'host/ess',
                TRUE
        ),
        (
                'ddd69845-59ce-4948-bad3-d28e84ddffae',
                'server/waiter',
                TRUE
        ),
        (
                'a38829b0-6bb0-4d8d-82fc-b898106a5af9',
                'bartender',
                TRUE
        ),
        (
                '3ad5ee15-c70f-4bab-8134-6cfc8d2c49dc',
                'cashier',
                TRUE
        ),
        (
                'ed403937-9cf0-4627-9002-29954c376469',
                'employee',
                TRUE
        );

-- migrate:down
DROP TABLE IF EXISTS roles;