# Sri Lanka Police - Traffic Fine Payment System

A production-ready, multi-platform digital traffic fine payment system for the Sri Lanka Police Department. Citizens and officers can look up, pay, and track traffic fines across web and mobile channels, with real-time SMS notifications to officers via Notify.lk.

## Monorepo Structure

```
sl-police-traffic-fine-system/
├── backend/              # Spring Boot REST API (Java 17)
├── web-payment/          # React SPA - public fine payment portal
├── web-admin/            # React Admin Portal - analytics & monitoring
├── mobile/               # Flutter Android app - on-the-spot payment
├── postman_collection.json
└── README.md
```

## Tech Stack

| Layer | Technology |
|---|---|
| Backend API | Java 17, Spring Boot 3.x, Spring Security, JPA |
| Database | Supabase (PostgreSQL) |
| Authentication | JWT (JJWT 0.11.5) |
| SMS | Notify.lk API |
| Web Payment | React 18, TypeScript, Vite, Zod |
| Web Admin | React 18, TypeScript, Vite, Recharts |
| Mobile | Flutter, Riverpod, Dio, go_router |

## Prerequisites

- Java 17+
- Maven 3.8+
- Node.js 18+
- Flutter SDK (stable)
- Supabase account (PostgreSQL database)
- Notify.lk account (SMS)

## Setup Instructions

### 1. Backend

```bash
cd backend
# Edit src/main/resources/application.properties with your credentials
mvn spring-boot:run
```

Server runs at `http://localhost:8080`

**Default seeded users:**

| Email | Password | Role |
|---|---|---|
| admin@police.lk | admin123 | ADMIN |
| officer@police.lk | officer123 | OFFICER |

### 2. Web Payment Portal

```bash
cd web-payment
npm install
# Set VITE_API_URL in .env (default: http://localhost:8080/api)
npm run dev
```

Runs at `http://localhost:3000`

### 3. Web Admin Portal

```bash
cd web-admin
npm install
# Set VITE_API_URL in .env (default: http://localhost:8080/api)
npm run dev
```

Runs at `http://localhost:3001`

### 4. Mobile App (Flutter)

```bash
cd mobile
flutter pub get
# Update lib/constants.dart kBaseUrl with your machine IP
flutter run
```

For physical device testing, use your local network IP (e.g. `http://10.55.111.76:8080/api`).

## API Endpoints

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/api/auth/login` | Public | Login, returns JWT |
| GET | `/api/categories` | Public | List fine categories |
| GET | `/api/fines/{referenceNo}` | Public | Lookup fine by reference |
| POST | `/api/fines` | OFFICER | Issue a new fine |
| POST | `/api/payments` | Public | Process payment + SMS |
| GET | `/api/admin/summary` | ADMIN | Overall statistics |
| GET | `/api/admin/collections/district` | ADMIN | Collections by district |
| GET | `/api/admin/collections/category` | ADMIN | Collections by category |

All responses use the `ApiResponse<T>` wrapper:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { }
}
```

## Environment Variables

### backend - `application.properties`

```properties
spring.datasource.url=jdbc:postgresql://[host]:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=[password]
jwt.secret=[256-bit-secret]
notify.lk.user-id=[user-id]
notify.lk.api-key=[api-key]
notify.lk.notify-id=NotifyDEMO
```

### web-payment / web-admin - `.env`

```
VITE_API_URL=http://localhost:8080/api
```

### mobile - `lib/constants.dart`

```dart
static const String kBaseUrl = 'http://[your-ip]:8080/api';
```

## Team Contributions

| Member | Role | Contribution |
|---|---|---|
| [Member 1 Name] | Backend Developer | Spring Boot API, JWT auth, SMS integration |
| [Member 2 Name] | Frontend Developer | Web payment portal |
| [Member 3 Name] | Frontend Developer | Admin portal & analytics |
| [Member 4 Name] | Mobile Developer | Flutter Android app |

## Screenshots

> Placeholder - add screenshots of each module here:
>
> - Web Payment: Home, Fine Details, Payment, Success
> - Web Admin: Login, Dashboard, District Chart, Category Chart
> - Mobile: Login, Home, Fine Details, Payment, Success

## Postman

Import `postman_collection.json` into Postman. Run **Login (Officer)** first, then **List Categories** to get a `categoryId`, then **Issue Fine** to create a test fine.

## License

Internal use - Sri Lanka Police Department.
