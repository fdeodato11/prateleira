# Prateleira Virtual

A modern Rails 8 e-commerce application built with Hotwire (Turbo + Stimulus), featuring admin management, shopping cart, authentication, and full Brazilian Portuguese localization.

## Features

- **Admin Dashboard** — Stats cards, Chartkick charts (products by category/status), low-stock alerts, quick actions
- **Product Management** — Full CRUD with soft delete (discard), image upload (Active Storage + libvips), status workflow (active/draft/inactive/archived)
- **Category Management** — Hierarchical categories with slugs, soft delete/restore
- **User Management** — Admin user listing, role toggle (admin/user), self-demotion protection
- **Authentication** — Rails 8 built-in auth (`has_secure_password`), sessions, password reset
- **Shopping Cart** — Session-based cart, add/remove items, quantity management, persistent across login
- **Product Catalog** — Search, filter by category/price, sort, pagination (Pagy)
- **Internationalization** — Full pt-BR locale (currency R$, dates DD/MM/YYYY, all UI text), English fallback
- **Design System** — CSS custom properties, responsive layouts (public header + admin sidebar), inline SVG icons (Lucide-style)

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Rails 8.0.5 |
| Ruby | 3.3.6 (rbenv) |
| Database | MySQL 8.4 (InnoDB, utf8mb4) |
| Auth | Rails 8 built-in + Pundit (deny-by-default) |
| Frontend | Hotwire (Turbo + Stimulus), Importmap |
| Images | Active Storage + libvips |
| Search | MySQL Full-Text (MATCH AGAINST) |
| Pagination | Pagy |
| Charts | Chartkick + Chart.js |
| Testing | RSpec, FactoryBot, Faker, SimpleCov (85%+ coverage) |
| Linting | RuboCop (Rails Omakase), Brakeman |
| CI/CD | GitHub Actions (test, lint, security) |
| Deploy | Kamal (Docker) |

## Getting Started

### Prerequisites

- Ruby 3.3.6 (via rbenv/rvm)
- MySQL 8.4+
- Node.js 18+ (for asset compilation if needed)
- libvips (`sudo apt-get install libvips-dev`)

### Setup

```bash
# Clone and enter
git clone <repo-url>
cd prateleira

# Install dependencies
bundle install

# Database setup
bin/rails db:create db:migrate db:seed

# Start server
bin/dev
```

Visit `http://localhost:3000`

### Default Admin

```
Email: admin@prateleira.com
Password: password123
```

## Project Structure

```
app/
├── controllers/
│   ├── admin/           # Admin namespace (dashboard, products, categories, users)
│   ├── concerns/        # Authentication, Authorization, Pagination
├── models/
│   ├── product.rb       # Status enum, search, discard, validations
│   ├── category.rb      # Slug, hierarchy, products association
│   ├── user.rb          # Admin boolean, has_secure_password
│   ├── cart.rb          # Session-based, add/remove/total
│   └── cart_item.rb     # Quantity, unique per cart+product
├── views/
│   ├── admin/           # Dashboard, CRUD tables, forms
│   ├── products/        # Catalog, show, search/filter
│   ├── carts/           # Cart view
│   ├── layouts/         # application.html.erb, admin.html.erb
├── helpers/
│   └── icons_helper.rb  # 25 inline SVG icons (Lucide-style)
├── assets/stylesheets/
│   └── application.css  # Design system (CSS variables, responsive)
└── javascript/
    └── controllers/     # Stimulus controllers
```

## Key Conventions

- **Authorization**: All admin controllers inherit `Admin::BaseController` → `Pundit::Authorization` → `verify_authorized`
- **Soft Delete**: `discard` gem → `Product.discarded`, `Category.kept`, `.discard`, `.undiscard`
- **Status Enum**: `Product.status` → `active: 0, draft: 1, inactive: 2, archived: 3`
- **Money**: Stored as integer cents (`price_cents`), displayed via `number_to_currency` (R$)
- **I18n**: All views use `t("labels.key")`, controllers use `t("admin.products.create.notice")`

## Testing

```bash
# Run all specs
bundle exec rspec

# With coverage report
COVERAGE=true bundle exec rspec
open coverage/index.html
```

**Current**: 119 examples, 0 failures, 85.5% line coverage

> **Note**: System specs require Chrome/Chromedriver (not available in WSL by default).

## Linting & Security

```bash
# RuboCop
bundle exec rubocop

# Brakeman (security)
bundle exec brakeman
```

## Deployment (Kamal)

```bash
# Configure .kamal/secrets and config/deploy.yml
kamal setup
kamal deploy
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | MySQL connection string | `mysql2://root:password@localhost/prateleira_development` |
| `RAILS_MASTER_KEY` | Credentials encryption | `config/master.key` |
| `ACTIVE_STORAGE_SERVICE` | Storage backend | `local` |

## License

MIT