-- Function to generate a standardized file path
CREATE OR REPLACE FUNCTION generate_file_path(
    item_id INTEGER,
    file_type TEXT,
    file_extension TEXT
) RETURNS TEXT AS $$
BEGIN
    CASE 
        WHEN file_type = 'picture' THEN
            RETURN '/opt/inventory/pictures/' || item_id::TEXT || '.' || file_extension;
        WHEN file_type = 'invoice' THEN
            RETURN '/opt/inventory/invoices/' || item_id::TEXT || '.' || file_extension;
        ELSE
            RAISE EXCEPTION 'Invalid file type: %', file_type;
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Function to validate file extension
CREATE OR REPLACE FUNCTION validate_file_extension(
    file_type TEXT,
    file_extension TEXT
) RETURNS BOOLEAN AS $$
BEGIN
    IF file_type = 'picture' THEN
        RETURN file_extension = ANY(ARRAY['jpg', 'jpeg', 'png']);
    ELSIF file_type = 'invoice' THEN
        RETURN file_extension = ANY(ARRAY['pdf', 'doc', 'docx']);
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to update file path
CREATE OR REPLACE FUNCTION update_file_path(
    p_item_id INTEGER,
    p_file_type TEXT,
    p_file_extension TEXT
) RETURNS TEXT AS $$
DECLARE
    new_path TEXT;
BEGIN
    -- Validate the file extension
    IF NOT validate_file_extension(p_file_type, p_file_extension) THEN
        RAISE EXCEPTION 'Invalid file extension: % for file type: %', p_file_extension, p_file_type;
    END IF;

    -- Generate the new path
    new_path := generate_file_path(p_item_id, p_file_type, p_file_extension);

    -- Update the appropriate column
    IF p_file_type = 'picture' THEN
        UPDATE inventory SET picture_path = new_path WHERE id = p_item_id;
    ELSIF p_file_type = 'invoice' THEN
        UPDATE inventory SET invoice_path = new_path WHERE id = p_item_id;
    END IF;

    RETURN new_path;
END;
$$ LANGUAGE plpgsql;

-- Function to get items missing files
CREATE OR REPLACE FUNCTION get_items_missing_files(p_file_type TEXT) 
RETURNS TABLE (
    id INTEGER,
    item_name TEXT,
    category TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT i.id, i.item_name::TEXT, i.category::TEXT
    FROM inventory i
    WHERE CASE 
        WHEN p_file_type = 'picture' THEN picture_path IS NULL
        WHEN p_file_type = 'invoice' THEN invoice_path IS NULL
        ELSE FALSE
    END;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW inventory_files AS
SELECT 
    id,
    item_name,
    category,
    CASE WHEN picture_path IS NOT NULL THEN TRUE ELSE FALSE END as has_picture,
    CASE WHEN invoice_path IS NOT NULL THEN TRUE ELSE FALSE END as has_invoice,
    picture_path,
    invoice_path
FROM inventory;