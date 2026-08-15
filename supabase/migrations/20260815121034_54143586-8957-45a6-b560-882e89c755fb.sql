CREATE OR REPLACE FUNCTION public.sync_link_click_count()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.links
  SET click_count = click_count + 1
  WHERE id = NEW.link_id;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS sync_link_click_count_after_insert ON public.click_events;
CREATE TRIGGER sync_link_click_count_after_insert
AFTER INSERT ON public.click_events
FOR EACH ROW
EXECUTE FUNCTION public.sync_link_click_count();

REVOKE ALL ON FUNCTION public.sync_link_click_count() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.sync_link_click_count() FROM anon;
REVOKE ALL ON FUNCTION public.sync_link_click_count() FROM authenticated;
GRANT EXECUTE ON FUNCTION public.sync_link_click_count() TO service_role;