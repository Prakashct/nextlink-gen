export const BRAND_NAME = "NextGen Tech Hub";
export const SHORT_DOMAIN = "go.nxtgentechhub.in";

export function shortUrl(slug: string) {
  return `https://${SHORT_DOMAIN}/${slug}`;
}
