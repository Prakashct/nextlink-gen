CREATE OR REPLACE FUNCTION public.resolve_link(_slug text, _referrer text DEFAULT NULL)
RETURNS TABLE (destination_url text, status text)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  _link_id uuid;
  _resolved_destination text;
  _is_active boolean;
BEGIN
  SELECT l.id, l.destination_url, l.is_active
    INTO _link_id, _resolved_destination, _is_active
  FROM public.links AS l
  WHERE l.slug = lower(_slug);

  IF _link_id IS NULL THEN
    RETURN QUERY SELECT NULL::text, 'not_found'::text;
    RETURN;
  END IF;

  IF NOT _is_active THEN
    RETURN QUERY SELECT NULL::text, 'disabled'::text;
    RETURN;
  END IF;

  INSERT INTO public.click_events (link_id, referrer)
  VALUES (_link_id, left(_referrer, 500));

  RETURN QUERY SELECT _resolved_destination, 'ok'::text;
END;
$$;

REVOKE ALL ON FUNCTION public.resolve_link(text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.resolve_link(text, text) FROM anon;
REVOKE ALL ON FUNCTION public.resolve_link(text, text) FROM authenticated;
GRANT EXECUTE ON FUNCTION public.resolve_link(text, text) TO service_role;