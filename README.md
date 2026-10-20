# Shorten URL

Build a Premium URL Shortener Web Application

Create a simple, fast, premium URL Shortener web application for my company NextGen Tech Hub.

The purpose of this application is to allow me to paste any long URL and create a short, clean, branded URL using my own domain.

Example:

Original URL:
https://rzp.io/rzp/eLlgHw0w

Custom Slug:
clinic

Generated URL:
https://go.nxtgentechhub.in/clinic

When someone visits the short URL, they should be immediately redirected to the original destination URL.

1. Application Goal

Build a lightweight URL management system similar to Bitly, but designed primarily for my own business use.

The application should allow me to:

Create short links

Create custom slugs

Automatically generate slugs

Copy short links

Edit destination URLs

Disable links

Delete links

Track clicks

Search existing links

Manage all links from one dashboard

2. Authentication

Create a secure Admin Login.

Only authenticated admin users should be able to access the dashboard and manage links.

Use Supabase Authentication.

Do not expose admin pages or link-management APIs publicly.

3. Dashboard

After login, show a clean premium dashboard.

At the top show:

Total Links
Total Clicks
Active Links

Add a prominent:

+ Create New Link

button.

Below that, display all created links.

Each link should show:

Short URL

Destination URL

Total Clicks

Created Date

Status: Active / Disabled

Actions:

Copy | Edit | Disable/Enable | Delete

Include a search field so I can quickly search by slug or destination URL.

4. Create Short Link

When clicking Create New Link, show a simple form.

Destination URL

Example:

https://example.com/very-long-url

Validate that this is a proper HTTP/HTTPS URL.

Custom Slug

Example:

webinar

Show a live preview:

go.nxtgentechhub.in/webinar

If the custom slug already exists, show:

"This short link is already in use. Please choose another."

Allow only URL-safe characters.

Normalize slugs appropriately.

Automatic Slug

The custom slug should be optional.

If I don't enter one, automatically generate a short unique slug such as:

x7k2p

Then provide:

Create Short Link

After creation, clearly show the final short URL with a Copy Link button.

5. Redirect System

When someone opens:

https://go.nxtgentechhub.in/webinar

Look up webinar in the database.

If it exists and is active, immediately redirect the visitor to its destination URL.

Use an appropriate temporary redirect such as 302 or 307 so that I can change the destination URL later.

The redirect should be extremely fast.

Do not show an intermediate page before redirecting.

If the short link does not exist, show a clean branded 404 – Link Not Found page.

If the link has been disabled, show:

"This link is currently unavailable."

6. Edit Existing Links

Allow me to change the destination URL without changing the existing short URL.

Example:

Existing:

go.nxtgentechhub.in/webinar

currently redirects to:

zoom-link-A

I should be able to change the destination to:

zoom-link-B

while keeping:

go.nxtgentechhub.in/webinar

unchanged.

This feature is very important.

7. Click Tracking

Whenever a short URL is opened, record a click event before redirecting.

Track at minimum:

Short link

Timestamp

Referrer, when available

Show the total number of clicks for every short URL.

Also create a simple analytics view showing:

Total Clicks

Clicks Today

Clicks Last 7 Days

Clicks Last 30 Days

Show a simple date-based click chart.

Do not collect unnecessary personally identifiable information.

8. Database

Use Supabase.

Create an appropriate database structure.

Links

Include fields such as:

id

slug

destination_url

is_active

click_count

created_at

updated_at

created_by

The slug must be unique.

Click Events

Create a separate click-events table containing:

id

link_id

clicked_at

referrer

Create proper relationships and indexes for fast redirects and analytics.

Use secure Supabase Row Level Security policies.

9. Security

Security is important.

Implement:

Admin authentication

Supabase Row Level Security

URL validation

Unique slug validation

Protection against unsafe database input

Redirect-loop prevention

Rate limiting where practical

Protected admin routes

Secure environment variables

Never expose Supabase service-role secrets or other private credentials in frontend code.

Do not allow dangerous protocols such as:

javascript:

data:

file:

Only allow valid http:// and https:// destination URLs.

10. UI / Design

The application should look like a premium SaaS product.

Brand:

NextGen Tech Hub

Style:

Minimal

Modern

Premium

Professional

Fast

Mobile responsive

Use a clean dashboard with good spacing, modern cards, subtle shadows, rounded corners and professional typography.

Avoid unnecessary animations or visual clutter.

The most important action should always be:

Create Short Link

11. Copy Function

Every short URL should have a one-click Copy button.

After clicking it, show:

✓ Link Copied

12. Delete Confirmation

Never immediately delete a link.

Show a confirmation:

Delete this short link?

Explain that anyone using the short URL will no longer be redirected.

Buttons:

Cancel

Delete Link

13. Architecture

Build this as a production-ready application.

Recommended stack:

React / Next.js-compatible architecture

TypeScript

Tailwind CSS

Supabase Database

Supabase Authentication

Keep the code modular, clean and maintainable.

Prioritize redirect speed, reliability and security over unnecessary features.

Main User Flow

Admin

Login
↓
Dashboard
↓
Create New Link
↓
Paste Destination URL
↓
Enter Custom Slug OR Auto Generate
↓
Create
↓
Copy Short URL

Visitor

Open:

go.nxtgentechhub.in/webinar

↓

Find slug in database

↓

Record click

↓

Redirect immediately to original destination.

Important

First build a fully functional V1.

Do not add unnecessary features that make the application complicated.

The V1 priority is:

Create → Shorten → Copy → Redirect → Track → Edit

Make sure the application is genuinely functional and connected to Supabase, not just a UI prototype.

After creating the application, guide me step-by-step through:

Connecting Supabase

Creating the required database tables

Setting up authentication

Configuring environment variables

Testing redirects

Connecting my custom domain/subdomain

Testing go.nxtgentechhub.in/example

Deploying the production version

Do not assume these integrations are complete until they have actually been configured and tested.

This project was built with [Lovable](https://lovable.dev).

**Live app**: https://nextlink-gen.lovable.app

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/2f3ebad6-d039-4fcf-a041-c4a0a86c2f69).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
