# Repository Guidelines

## Project Structure & Module Organization
This repo is a small second-hand trading platform split across services and a Vue client.

- `Server/` 每 main Spring Boot API (`controller`, `service`, `dao`, `model`, `vo`) plus MyBatis XML in `src/main/resources/mapper/`.
- `WebApp/` 每 Vue 2 frontend. Pages live in `src/components/page/`, shared UI in `src/components/common/`, HTTP helpers in `src/api/` and `src/utils/`.
- `eureka-server/` 每 Eureka registry on port `8761`.
- `zuul/` 每 Zuul gateway on port `8040`.
- `second_hand_trading.sql` 每 bootstrap schema/data for local MySQL.
- `images/README/` 每 screenshots used by the root `README.md`.

## Build, Test, and Development Commands
Run commands from the repo root unless noted.

- `mvn -f Server/pom.xml spring-boot:run` 每 start the main backend on `localhost:8080`.
- `mvn -f Server/pom.xml test` 每 run backend JUnit tests.
- `mvn -f eureka-server/pom.xml spring-boot:run` 每 start service discovery.
- `mvn -f zuul/pom.xml spring-boot:run` 每 start the gateway.
- `cd WebApp && npm install` 每 install frontend dependencies.
- `cd WebApp && npm run dev` 每 start the Vue dev server on port `8081`.
- `cd WebApp && npm run build` 每 create the production bundle in `WebApp/dist/`.

## Coding Style & Naming Conventions
Use 4-space indentation in Java and Vue/JS. Keep Java packages lowercase under `com.second.hand.trading...`; use `*Controller`, `*ServiceImpl`, `*Dao.xml`, and singular model names. Vue components in `components/common/` use PascalCase (`AppHeader.vue`); route pages follow the existing kebab-case pattern such as `idle-details.vue`. Frontend formatting follows `WebApp/.prettierrc` (single quotes, no trailing commas, print width 140).

## Testing Guidelines
Backend tests use Spring Boot + JUnit 5 under `Server/src/test/java/`. Add tests beside the package you change and name them `*Tests.java`. There is currently only a smoke test, so new service, controller, or mapper changes should include at least one focused regression test. The frontend has no automated test suite yet; document manual verification steps in the PR.

## Commit & Pull Request Guidelines
Recent history favors short, imperative Chinese commit messages, sometimes with a scope prefix such as `(fix)`. Keep commits focused: one logical change per commit. PRs should include a brief summary, affected modules (`Server`, `WebApp`, `zuul`, etc.), database/config changes, linked issues, and screenshots for UI updates.

## Security & Configuration Tips
Do not commit real credentials. `Server/src/main/resources/application.properties` contains local MySQL defaults; override them per environment. Keep API base URLs aligned: the frontend targets `http://localhost:8080`, while the Vue dev server runs on `8081`.
