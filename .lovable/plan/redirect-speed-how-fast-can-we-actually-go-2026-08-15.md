# Redirect speed: how fast can we actually go?

0.3s അല്ല limit. ഇപ്പോൾ measure ചെയ്ത യഥാർത്ഥ numbers:

```text
nextlink-gen.lovable.app/news   -> 57-116 ms   (fast, edge cache hit)
go.nxtgentechhub.com/news       -> 590-900 ms  (slow)
local dev server /news          -> 310-390 ms  (dev build, not representative)
```

So the app code is already fast. The 0.5-0.9s you feel comes from the custom domain layer (extra proxy hop + cache misses), not from the database lookup.

## What we can still improve

1. Warm in-memory cache in the redirect handler
   Keep recently used slug → destination pairs in the server instance memory (short TTL, e.g. 60s). Repeat visits skip the database entirely.

2. Do not wait for click logging
   Right now the redirect waits for the database call that both resolves the link and writes the click. We split it: resolve fast, write the click in the background so the 302 leaves immediately.

3. Longer edge cache with instant invalidation on edit
   Raise the cached window (e.g. 5 minutes, stale-while-revalidate 1 day). When a link is edited or deactivated, bump a version so the old cached redirect is not served.

4. Custom domain path
   After the above, re-measure `go.nxtgentechhub.com`. If it is still much slower than the `.lovable.app` URL, the remaining cost is the DNS/proxy setup for that subdomain — I will report the exact numbers and what DNS change (if any) helps. This part is not something app code can remove.

## Realistic target after the changes

- `.lovable.app` short links: 30-80 ms
- `go.nxtgentechhub.com` cached links: ~100-200 ms
- First (uncached) hit on the custom domain: ~250-400 ms

## Trade-offs to accept

- With caching, a link you just edited or disabled can still redirect the old way for a few seconds on already-cached edges (invalidation covers most cases, not every edge instantly).
- Click counts stay accurate, but a click may appear in analytics a moment after the redirect instead of at the exact same instant.

## Technical notes

- `src/routes/$slug.ts`: add module-scope LRU/Map cache with TTL, stop awaiting the click insert, extend `cache-control`.
- Database: split `resolve_link` into a pure lookup (no writes) plus a separate lightweight click-insert call, so the read path never touches the write path.
- `src/lib/links.functions.ts`: on create/update/delete, clear the cached entry for that slug.
