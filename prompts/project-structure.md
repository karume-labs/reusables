# JKUAT Website Architecture Overview

The JKUAT Website repository is a **monorepo** designed with separation of concerns and type safety in mind. It consists of multiple apps and shared packages that allow seamless end-to-end type safety from the backend API to the frontend client.

## 1. Repository Structure

The monorepo uses [Bun](https://bun.sh) workspaces (or npm/yarn workspaces) and is organized into `apps` and `packages`.

### `apps/`
- **`web`**: The frontend application built with **Next.js (App Router)** and **React 19**. It leverages **Tailwind CSS v4** and **Radix UI** (shadcn/ui) for styling and components.
- **`api`**: The backend application built with **ElysiaJS**. It is a fast, type-safe web framework running on Bun. It handles authentication, data processing, and serves as the primary backend for the web app.

### `packages/`
- **`db`**: Contains the database schema and configurations. It uses **Drizzle ORM** with **PostgreSQL**.
- **`types`**: Shared TypeScript types and interfaces used across both the frontend and backend.
- **`validators`**: Shared **Zod** validation schemas to ensure data consistency between frontend submissions and backend processing.

---

## 2. Key Libraries Used

### Frontend (`apps/web`)
- **Framework:** Next.js 16.x (React 19)
- **Styling:** Tailwind CSS v4, Radix UI primitives, `class-variance-authority`, `clsx`, `tailwind-merge`
- **Data Fetching:** `@tanstack/react-query` (TanStack Query v5) and `@elysiajs/eden` (Eden Treaty)
- **Form Handling:** `react-hook-form` with `@hookform/resolvers` (Zod)
- **Rich Text Editor:** `@blocknote/core` and `@blocknote/react`
- **State Management (URL):** `nuqs`

### Backend (`apps/api`)
- **Framework:** ElysiaJS (`elysia`)
- **Authentication:** Better Auth (`better-auth`)
- **Database ORM:** Drizzle ORM (`drizzle-orm`, `drizzle-kit`, `drizzle-zod`)
- **Database Driver:** `postgres`
- **Security & Utilities:** `elysia-helmet`, `elysia-rate-limit`, `@elysiajs/cors`
- **AI Integrations:** Vercel AI SDK (`ai`, `@ai-sdk/google`)

---

## 3. End-to-End Data Flow (Frontend to Backend)

The most defining feature of this architecture is the **Eden Treaty** implementation. Eden Treaty is an ElysiaJS tool that creates a fully type-safe API client on the frontend by simply importing the backend app's type signature. This means if an endpoint changes on the backend, the frontend will immediately show TypeScript errors, avoiding runtime crashes.

### Step 1: Backend Defines the API (Elysia)

In the backend, Elysia routers define endpoints, their validation (using Zod or Elysia's `t`), and their handlers. The main app combines these routers and exports its `typeof app` signature.

```typescript
// apps/api/src/app.ts
import { Elysia } from "elysia";
import { uploadsRoutes } from "@api/features/uploads/routes";
import { contentRoutes } from "@api/features/content/routes";
// ... other imports

export const app = new Elysia()
  // ... plugins (helmet, rateLimit, cors)
  .use(uploadsRoutes)
  .use(contentRoutes)
  // ... other routes

// This export is the secret sauce for Eden Treaty!
export type App = typeof app;
```

### Step 2: Frontend Initializes Eden Treaty Client

In the frontend's shared API utility, the Eden Treaty client is instantiated using the `App` type imported from the backend package.

```typescript
// apps/web/src/features/shared/api.ts
import { treaty } from "@elysiajs/eden";
import type { App } from "@jkuat-website/api"; // Importing the backend type!
import { env } from "@/env";

// `api` now has full autocomplete for all backend endpoints
export const api = treaty<App>(env.NEXT_PUBLIC_API_URL, {
  fetcher: async (url, options) => {
    // Interceptor logic to attach cookies for SSR, handle errors, etc.
    // ...
  }
});
```

### Step 3: Frontend Fetches Data (React Query + Eden Treaty)

When a component needs data, it uses TanStack Query (`useQuery`, `useMutation`) combined with the `api` client. Because of the type generic, the `api` object mirrors the backend routing structure as an object chain.

For example, a `GET /admin/uploads` endpoint becomes `api.admin.uploads.get()`.

```typescript
// apps/web/src/features/admin/services/queries.ts
import { useQuery } from "@tanstack/react-query";
import { api } from "@web/features/shared/api";

export const useAdminUploads = (tableState: { page: number; pageSize: number; q: string }) => {
  return useQuery({
    queryKey: ["admin", "uploads", tableState],
    queryFn: async () => {
      // 1. Fully typed request parameters (query, body, params)
      const res = await api.admin.uploads.get({
        query: {
          page: tableState.page.toString(),
          pageSize: tableState.pageSize.toString(),
          q: tableState.q,
        },
      });
      
      if (res.error) throw new Error("Failed to fetch uploads");
      
      // 2. res.data is fully typed based on the backend's return type!
      return res.data; 
    },
  });
};
```

### Summary of the Flow

1. **User Action:** A user interacts with the UI in the Next.js app.
2. **Frontend Request:** A React Query hook is triggered. It uses the `api` client (Eden Treaty), which constructs a standard `fetch` request using the object path (`api.admin.uploads.get()`).
3. **Network Transit:** The request is sent to the Elysia backend (with cookies/credentials automatically handled by the custom fetcher).
4. **Backend Processing:** Elysia validates the request payload, interacts with PostgreSQL via Drizzle ORM, and returns a JSON response.
5. **Frontend Reception:** The `fetcher` intercepts the response, and Eden parses it. React Query caches the result and triggers a re-render with the fully typed data.
