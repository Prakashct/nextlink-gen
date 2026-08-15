import { createFileRoute } from "@tanstack/react-router";
import { normalizeSlug } from "@/lib/slug";

// Server-only redirect route: /:slug -> destination URL (302), click recorded first.
export const Route = createFileRoute("/$slug")({
  server: {
    handlers: {
      GET: async ({ params, request }) => {
        const slug = normalizeSlug(params.slug ?? "");
        if (!slug) return Response.redirect(new URL("/unavailable?reason=not_found", request.url), 302);

        try {
          const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
          const referrer = request.headers.get("referer");
          const { data, error } = await supabaseAdmin.rpc("resolve_link", {
            _slug: slug,
            ...(referrer ? { _referrer: referrer } : {}),
          });

          if (error) throw error;
          const result = Array.isArray(data) ? data[0] : data;

          if (result?.status === "ok" && result.destination_url) {
            const destination = new URL(result.destination_url);
            const current = new URL(request.url);
            // Redirect-loop protection: never bounce back to this same short URL.
            if (destination.host === current.host) {
              return Response.redirect(new URL("/unavailable?reason=loop", request.url), 302);
            }
            return new Response(null, {
              status: 302,
              headers: { location: destination.toString(), "cache-control": "no-store" },
            });
          }

          const reason = result?.status === "disabled" ? "disabled" : "not_found";
          return Response.redirect(new URL(`/unavailable?reason=${reason}`, request.url), 302);
        } catch (err) {
          console.error("redirect lookup failed", err);
          return Response.redirect(new URL("/unavailable?reason=error", request.url), 302);
        }
      },
    },
  },
});
