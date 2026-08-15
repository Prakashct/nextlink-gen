-- Pure read: no writes on the redirect hot path.
CREATE OR REPLACE FUNCTION public.lookup_link(_slug text)
RETURNS TABLE (link_id uuid, destination_url text, status text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    l.id,
    CASE WHEN l.is_active THEN l.destination_url ELSE NULL END,
    CASE WHEN l.is_active THEN 'ok' ELSE 'disabled' END
  FROM public.links AS l
  WHERE l.slug = lower(_slug)
  UNION ALL
  SELECT NULL::uuid, NULL::text, 'not_found'::text
  WHERE NOT EXISTS (SELECT 1 FROM public.links AS l2 WHERE l2.slug = lower(_slug))
$$;

REVOKE ALL ON FUNCTION public.lookup_link(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.lookup_link(text) FROM anon;
REVOKE ALL ON FUNCTION public.lookup_link(text) FROM authenticated;
GRANT EXECUTE ON FUNCTION public.lookup_link(text) TO service_role;

-- Background click logging, called after the redirect response is sent.
CREATE OR REPLACE FUNCTION public.log_click(_link_id uuid, _referrer text DEFAULT NULL)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.click_events (link_id, referrer)
  VALUES (_link_id, left(_referrer, 500));
END;
$$;

REVOKE ALL ON FUNCTION public.log_click(uuid, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.log_click(uuid, text) FROM anon;
REVOKE ALL ON FUNCTION public.log_click(uuid, text) FROM authenticated;
GRANT EXECUTE ON FUNCTION public.log_click(uuid, text) TO service_role;