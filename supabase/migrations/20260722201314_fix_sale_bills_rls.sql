DROP POLICY IF EXISTS "Buyers View Own Invoices" ON public.sale_bills;
CREATE POLICY "Buyers View Own Invoices"
    ON public.sale_bills FOR SELECT
    TO authenticated
    USING (
        get_user_role() = 'buyer' AND
        (
            client_id IN (
                SELECT b.society_id 
                FROM residents r
                JOIN flats f ON r.flat_id = f.id
                JOIN buildings b ON f.building_id = b.id
                WHERE r.auth_user_id = auth.uid()
            )
            OR
            request_id IN (
                SELECT id
                FROM requests
                WHERE buyer_id = auth.uid()
            )
        )
    );

DROP POLICY IF EXISTS "Buyers Update Own Invoices" ON public.sale_bills;
CREATE POLICY "Buyers Update Own Invoices"
    ON public.sale_bills FOR UPDATE
    TO authenticated
    USING (
        get_user_role() = 'buyer' AND
        (
            client_id IN (
                SELECT b.society_id 
                FROM residents r
                JOIN flats f ON r.flat_id = f.id
                JOIN buildings b ON f.building_id = b.id
                WHERE r.auth_user_id = auth.uid()
            )
            OR
            request_id IN (
                SELECT id
                FROM requests
                WHERE buyer_id = auth.uid()
            )
        )
    )
    WITH CHECK (
        get_user_role() = 'buyer' AND
        (
            client_id IN (
                SELECT b.society_id 
                FROM residents r
                JOIN flats f ON r.flat_id = f.id
                JOIN buildings b ON f.building_id = b.id
                WHERE r.auth_user_id = auth.uid()
            )
            OR
            request_id IN (
                SELECT id
                FROM requests
                WHERE buyer_id = auth.uid()
            )
        )
    );
