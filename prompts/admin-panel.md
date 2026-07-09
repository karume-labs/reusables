# Vaunt Admin Panel Architecture

The admin panel follows a consistent, composable component architecture designed for rapid CRUD page creation. Every admin data page is built from the same set of reusable primitives, ensuring visual consistency and minimal boilerplate.

## 1. Page Layout Hierarchy

Every admin page lives inside a two-level layout:

```
AdminAppShell                         (shell: sidebar + header + footer)
  └── AdminPanelPageLayout            (page chrome: title, description, "Add New" button)
        └── DataToolbar               (filter card: search, selects, view toggle)
        └── DataTable                 (data grid: columns, rows, pagination, empty state)
              └── TableMenuActions    (row-level actions: edit, delete w/ confirmation)
```

### 1.1 `AdminAppShell` — Global Shell

**Location:** `features/admin/components/AdminAppShell.tsx`

The top-level layout wrapper providing the persistent chrome around all admin pages:

- **Header** (60–64px): Site logo (collapsible sidebar toggle), color scheme toggle, user avatar
- **Navbar** (280px expanded / 80px collapsed): Navigation links via `AdminNavbar`
- **Main**: `DynamicBreadcrumbs` (auto-generated from URL) + page content (`{children}`)
- **Footer** (60px): Copyright

```tsx
<AppShell padding={{ base: "md", sm: "xl" }}
  header={{ height: { base: 60, md: 64 } }}
  navbar={{ width: { base: 280, sm: isExpanded ? 280 : 80 }, breakpoint: "sm" }}
>
  <AppShellHeader>...</AppShellHeader>
  <AdminNavbar ... />
  <AppShellMain>
    <DynamicBreadcrumbs homeLabel="Dashboard" homeHref="/admin" />
    {children}
  </AppShellMain>
  <AppShellFooter>...</AppShellFooter>
</AppShell>
```

### 1.2 `AdminPanelPageLayout` — Page Chrome

**Location:** `features/shared/components/AdminPanelPageLayout.tsx`

Wraps each admin content page with a consistent header area. Title + description are left-aligned; the "Add New" button sits on the right on the same row.

```tsx
interface AdminPanelPageLayoutProps {
  title: string;
  description?: string;
  addNewLabel?: string;    // Button text (e.g., "Generate Coupon")
  onAddNew?: () => void;   // Opens the create modal
  children: ReactNode;     // DataToolbar + DataTable
}
```

Layout:
```
<Container size="xl" py="lg">
  <Stack>
    <Group justify="space-between" align="flex-start">
      <Stack gap={4}>
        <Title order={1}>...</Title>
        <Text c="dimmed">...</Text>
      </Stack>
      <Button leftSection={<IconPlus />}>...</Button>    ← right side
    </Group>
    {children}
  </Stack>
</Container>
```

### 1.3 `DataToolbar` — Filter Card

**Location:** `features/shared/components/table/DataToolbar.tsx`

A bordered card containing filter controls. Mirrors the baykart dashboard's `MarketPlaceListingsFiltersCard` pattern.

```tsx
interface DataToolbarProps {
  children: ReactNode;                    // Filter fields (e.g., TextInput, Select)
  onClear?: () => void;                   // Clears all URL search params
  viewMode?: "table" | "grid";           // Current view mode
  onViewModeChange?: (mode: ...) => void; // Toggle between table/grid
}
```

Layout:
```
<Card withBorder shadow="sm" p="lg">
  <Stack gap="lg">
    <Group justify="space-between">
      <Stack gap={2}>
        <Text fw={500}>Filters</Text>
        <Text size="sm" c="dimmed">Refine results</Text>
      </Stack>
      <Group>
        <Paper> [ IconList | IconLayoutGrid ] </Paper>    ← view toggle (optional)
        <Button variant="light">Clear All</Button>
      </Group>
    </Group>
    <Divider />
    <SimpleGrid cols={{ base: 1, sm: 2, md: 3 }}>
      {children}    ← consumer provides filter fields
    </SimpleGrid>
  </Stack>
</Card>
```

Consumers pass `<TextInput>`, `<Select>`, `<NumberInput>`, etc. as children. Each field wires directly to `nuqs` via `useQueryState` or the `useDataTablePagination` hook.

---

## 2. Data Table Architecture

### 2.1 `DataTable` — Core Table Component

**Location:** `features/shared/components/table/DataTable.tsx`

A generic table component built on `@tanstack/react-table`. It handles the full lifecycle: loading → data → empty.

```tsx
interface DataTableProps<TData> {
  columns: ColumnDef<TData, unknown>[];   // Column definitions
  data: TData[];                           // Current page data
  totalRecords: number;                    // Total count across all pages
  page: number;                            // 1-indexed current page
  pageSize: number;                        // Rows per page
  onPageChange: (page: number) => void;   // Page change handler
  onPageSizeChange?: (pageSize: number) => void;
  onClearFilters?: () => void;            // Shown in empty state
  loading?: boolean;                       // Shows skeleton when true
  viewMode?: "table" | "grid";           // Rendering mode
  renderCard?: (item: TData) => ReactNode; // Grid card renderer
}
```

**States:**

| State | Rendering |
|-------|-----------|
| `loading: true` | `<DataTableSkeleton columnCount={columns.length} />` |
| `data.length > 0` | Table rows via `useReactTable` + `flexRender` |
| `data.length === 0` | Empty state: `IconTableOff` + "No results found" + optional "Clear Filters" button |

**Pagination footer** (shown when `totalRecords > 0`):

```
Showing X to Y of Z records    [Rows per page: 10 ▼]    [« ‹ 1 ··· N › »]
```

Pagination uses Mantine's `<Pagination withEdges>` component directly (not `@tanstack/react-table`'s pagination plugin), keeping page state 1-indexed to match the URL query params.

### 2.2 `DataTableSkeleton` — Loading State

**Location:** `features/shared/components/table/DataTableSkeleton.tsx`

A skeleton placeholder matching the `DataTable` layout. Accepts `columnCount` and `rowCount` props.

```tsx
<DataTableSkeleton columnCount={6} rowCount={8} />
```

Renders:
- Table header with skeleton `<TableTh>` lines
- Body with skeleton `<TableTd>` cells (variable widths)
- Pagination bar with skeleton controls

### 2.3 `TableMenuActions` — Row Action Menu

**Location:** `features/shared/components/table/TableMenuActions.tsx`

A reusable `<Menu>` wrapper used in every table's `actions` column. Provides consistent three-dot trigger, positioning, and shadow.

```tsx
<TableMenuActions>
  <TableMenuActions.Item leftSection={<IconEdit size={14} />} onClick={...}>
    Edit
  </TableMenuActions.Item>
  <TableMenuActions.ConfirmItem
    leftSection={<IconTrash size={14} />}
    color="red"
    onConfirm={() => handleDelete(id)}
  >
    Delete
  </TableMenuActions.ConfirmItem>
</TableMenuActions>
```

#### Sub-components

| Component | Purpose |
|-----------|---------|
| `TableMenuActions.Item` | Standard `Menu.Item` — for non-destructive actions (edit, view) |
| `TableMenuActions.ConfirmItem` | Wraps `Menu.Item` with `openConfirmModal` — for destructive actions |
| `TableMenuActions.Label` | `Menu.Label` — group headings in the dropdown |
| `TableMenuActions.Divider` | `Menu.Divider` — visual separators |

**`ConfirmItem`** shows a centered confirmation dialog before the action fires:

```
┌──────────────────────────────────┐
│ Confirm action                   │
│                                  │
│ Are you sure? This action cannot │
│ be undone.                       │
│                                  │
│          [Cancel]    [Delete]    │
└──────────────────────────────────┘
```

`ConfirmItem` accepts these props:

| Prop | Default | Description |
|------|---------|-------------|
| `onConfirm` | required | Called when user confirms |
| `modalTitle` | `"Confirm action"` | Dialog title |
| `modalChildren` | Default warning text | Custom message or ReactNode |
| `confirmLabel` | `"Delete"` | Confirm button text |
| `leftSection` | — | Icon or element |
| `color` | — | Menu item color |
| `disabled` | — | Disable the menu item |

---

## 3. URL State Persistence with `nuqs`

### 3.1 `useDataTablePagination` Hook

**Location:** `features/shared/hooks/useDataTablePagination.ts`

Central hook that synchronizes pagination and search state with URL query parameters via `nuqs`. Every admin view uses this hook.

```ts
const {
  page, setPage,           // 1-indexed page number (URL param: ?page=1)
  pageSize, setPageSize,   // Rows per page (URL param: ?pageSize=10)
  search, setSearch,       // Search string (URL param: ?search=...)
  debouncedSearch,         // Search value debounced at 500ms
  handlePaginationChange,  // Converts react-table PaginationState → URL
  pagination,              // { pageIndex: page - 1, pageSize }
  clearFilters,            // Resets page + search to defaults
} = useDataTablePagination({ defaultPageSize?: 10, syncWithUrl?: true, debounceMs?: 500 });
```

**URL Query Params managed:**

| Param | Type | Default | Hook output |
|-------|------|---------|-------------|
| `?page=` | integer | 1 | `page` / `setPage` |
| `?pageSize=` | integer | 10 | `pageSize` / `setPageSize` |
| `?search=` | string | "" | `search` / `setSearch` |

**Debounce flow:**

```
User types → setSearch("abc") → URL updates immediately (?search=abc)
                              → debouncedSearch lags 500ms → passed to API query
```

This ensures the URL reflects current input immediately (so page refreshes preserve state), while API calls are batched.

**`clearFilters()`** resets both page and search to defaults. For the URL-synced case it removes the params (triggering defaults); for local state it explicitly resets to `page=1` and `search=""`.

### 3.2 Additional Filters

For filters beyond search (status, type, date range, etc.), each filter uses `nuqs` directly with its own `useQueryState`:

```tsx
const [status, setStatus] = useQueryState("status", parseAsString.withDefault(""));

<Select
  label="Status"
  value={status}
  onChange={(val) => {
    setStatus(val || null);
    setPage(1);   // Reset to page 1 when filter changes
  }}
  data={["active", "inactive"]}
/>
```

The `clearFilters` callback passed to `DataToolbar` typically resets all filter state:

```tsx
const clearAll = () => {
  clearFilters();    // reset page + search
  setStatus(null);   // reset additional filters
  setType(null);
};
```

---

## 4. Complete Page Example: `AdminCouponsView`

**Location:** `features/admin/components/AdminCouponsView.tsx`

This is the canonical example showing the full pattern:

```tsx
export const AdminCouponsView = () => {
  const [opened, { open, close }] = useDisclosure(false);

  const { page, pageSize, setPage, setPageSize, search, setSearch,
          debouncedSearch, clearFilters } = useDataTablePagination();

  const { data, isLoading } = useAdminCoupons(page, pageSize, debouncedSearch);

  const columns: ColumnDef<Coupon>[] = [
    { accessorKey: "code", header: "Code", ... },
    { accessorKey: "discountType", header: "Type", ... },
    { accessorKey: "discountValue", header: "Value", ... },
    { accessorKey: "isActive", header: "Status", ... },
    { accessorKey: "createdAt", header: "Created At", ... },
    {
      id: "actions",
      header: "",
      cell: () => (
        <TableMenuActions>
          <TableMenuActions.Item leftSection={<IconEdit />}>Edit</TableMenuActions.Item>
          <TableMenuActions.ConfirmItem leftSection={<IconTrash />} color="red"
            onConfirm={() => handleDelete(id)}>Delete</TableMenuActions.ConfirmItem>
        </TableMenuActions>
      ),
    },
  ];

  return (
    <AdminPanelPageLayout
      title="Coupons"
      description="Create and manage discount codes."
      addNewLabel="GENERATE NEW COUPON"
      onAddNew={open}
    >
      <DataToolbar onClear={clearFilters}>
        <TextInput placeholder="Search by code..."
          leftSection={<IconSearch />} value={search}
          onChange={(e) => setSearch(e.currentTarget.value)} />
      </DataToolbar>

      <DataTable columns={columns} data={data?.data ?? []}
        totalRecords={data?.meta?.total ?? 0}
        page={page} pageSize={pageSize}
        onPageChange={(p) => setPage(p)}
        onPageSizeChange={(s) => setPageSize(s)}
        onClearFilters={clearFilters}
        loading={isLoading} />

      <CreateCouponModal opened={opened} close={close} />
    </AdminPanelPageLayout>
  );
};
```

### Flow Summary

1. User navigates to `/admin/coupons`
2. `AdminAppShell` renders the sidebar + header + breadcrumbs
3. `AdminPanelPageLayout` renders "Coupons" page header with "Generate New Coupon" button
4. `DataToolbar` shows a search input wired to `nuqs` via `useDataTablePagination`
5. `DataTable` fetches data via `useAdminCoupons(page, pageSize, debouncedSearch)`
6. URL updates immediately on search; API calls debounce at 500ms
7. Pagination changes sync to `?page=` URL param
8. "Generate New Coupon" button opens `CreateCouponModal`
9. Row actions menu shows Edit/Delete via `TableMenuActions`
10. Delete triggers a confirm modal before executing

---

## 5. File Structure

```
features/shared/
  components/
    AdminPanelPageLayout.tsx       — Page chrome (title + description + add button)
    table/
      DataTable.tsx                — Generic data grid with pagination
      DataTableSkeleton.tsx        — Loading skeleton for DataTable
      DataToolbar.tsx              — Filter card with view toggle
      TableMenuActions.tsx         — Row actions menu + ConfirmItem
  hooks/
    useDataTablePagination.ts      — nuqs-powered pagination/search hook

features/admin/
  components/
    AdminAppShell.tsx              — Global shell (sidebar + header + footer)
    AdminNavbar.tsx                — Sidebar navigation
    AdminPageHeader.tsx            — [deprecated — use AdminPanelPageLayout]
    AdminCouponsView.tsx           — Example page
    AdminLeadsView.tsx
    AdminContactsView.tsx
    AdminAbandonedCartsView.tsx
    AdminReviewsView.tsx
    AdminEmailLogsView.tsx
    AdminEmailPreviewsView.tsx
    AdminCatalogView.tsx
    AdminDashboardView.tsx         — Dashboard (metrics + chart, no DataTable)
```

---

## 6. Quick Reference

### Adding a new admin page

```tsx
export const AdminMyFeatureView = () => {
  const [opened, { open, close }] = useDisclosure(false);
  const { page, pageSize, setPage, setPageSize, search, setSearch,
          debouncedSearch, clearFilters } = useDataTablePagination();
  const { data, isLoading } = useAdminMyFeature(page, pageSize, debouncedSearch);

  const columns: ColumnDef<MyType>[] = [
    // ... accessor columns
    { id: "actions", header: "", cell: () => (
      <TableMenuActions>
        <TableMenuActions.Item leftSection={<IconEdit />} onClick={...}>Edit</TableMenuActions.Item>
        <TableMenuActions.ConfirmItem leftSection={<IconTrash />} color="red"
          onConfirm={...}>Delete</TableMenuActions.ConfirmItem>
      </TableMenuActions>
    )},
  ];

  return (
    <AdminPanelPageLayout title="My Feature" description="Manage..."
      addNewLabel="Add New" onAddNew={open}>
      <DataToolbar onClear={clearFilters}>
        <TextInput placeholder="Search..."
          value={search} onChange={(e) => setSearch(e.currentTarget.value)} />
      </DataToolbar>
      <DataTable columns={columns} data={data?.data ?? []}
        totalRecords={data?.meta?.total ?? 0}
        page={page} pageSize={pageSize}
        onPageChange={(p) => setPage(p)}
        onPageSizeChange={(s) => setPageSize(s)}
        onClearFilters={clearFilters} loading={isLoading} />
      <CreateModal opened={opened} close={close} />
    </AdminPanelPageLayout>
  );
};
```

### Key conventions

| Concern | Convention |
|---------|-----------|
| Page wrapper | Use `AdminPanelPageLayout` (not raw `<Container>`) |
| Modal for create | `useDisclosure` + modal component, triggered by `onAddNew` |
| URL state | `useDataTablePagination` for page/search/pageSize; `useQueryState` for extra filters |
| Debounce | Hook returns both `search` (immediate) and `debouncedSearch` (500ms) |
| API query | Always pass `debouncedSearch` (not raw `search`) to the query |
| Actions column | `TableMenuActions.Item` for safe actions; `ConfirmItem` for destructive |
| Empty state | Built into `DataTable` — no manual empty checks needed |
| Loading state | `loading` prop on `DataTable` — shows skeleton automatically |
