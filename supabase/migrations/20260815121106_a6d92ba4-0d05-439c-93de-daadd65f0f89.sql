DROP TRIGGER IF EXISTS sync_link_click_count_after_insert ON public.click_events;
DROP FUNCTION IF EXISTS public.sync_link_click_count();