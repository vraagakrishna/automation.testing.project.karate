# Karate Test Automation Framework

## Table of Contents

- [Highlights](#highlights)
- [Project Goal](#project-goal)
- [Pre-requisites / Requirements](#pre-requisites--requirements)
- [What This Project Demonstrates](#what-this-project-demonstrates)
- [Project Structure](#project-structure)
- [Test Tagged Strategy](#test-tagged-strategy)
- [Setup / Installation](#setup--installation)
- [Running Tests Locally](#running-tests-locally)
- [CI/CD Pipelines](#cicd-pipelines)

<br/>

## Highlights

* Unified testing for API, UI, SOAP, performance
* Layered test strategy: smoke -> full -> performance
* Parallel test execution for performance validations
* CI/CD integration with clear pass/fail logic
* Merged HTML test reports with screenshots and artifacts

<br/>

## Project Goal

The primary goal of this project is to **demonstrate practical proficiency** with the **Karate testing framework**
through hands-on implementation.

> The **focus is _not_ on what is being tested**, but on **_how_ Karate can be applied** to support multiple types of
> testing using a single, unified tool.

This repository serves as a **capability showcase** highlighting how Karate can be used across:

* API testing
* SOAP API testing
* UI testing
* Smoke and Sanity testing
* Performance testing
* CI/CD integration

<br/>

## Pre-requisites / Requirements

* Java 21
* Maven 2.x
* Chrome browser for UI tests

<br/>

## What This Project Demonstrates

### API Testing

* REST API testing driven by Swagger/OpenAPI documentation
* JSON request and response contract validation
* Positive and negative test scenarios
* End-to-end authentication flow testing (Register -> Login -> Authenticated APIs)
* JWT-based authentication handling
    * Valid tokens
    * Invalid tokens
    * Expired tokens
* Centralised test data factories for dynamic user generation
* Reusable feature files for common API operations
* Shared JavaScript utilities (JWT decoding, validation, token manipulation)
* Conditional assertions based on response outcomes

Useful resources:

* https://medium.com/@sachinifonseka08/api-testing-with-karate-framework-53b5d5d47776

### SOAP API Testing

* SOAP service testing using Karate's built-in XML support
* External SOAP XML templates with dynamic parameter injection
* XPath-based assertions with namespace-safe expressions
* Centralized and reusable SOAP response validators
* Numeric and precision-aware response validation
* HTTP error and server fault handling (400 / 500 scenarios)
* Separation of request construction and assertion logic
* Demonstrates testing **REST and SOAP APIs within the same framework**

Implemented Examples:

* SOAP request body construction using external XML files
* Dynamic request data substitution via placeholders
* SOAP response validation using XPath
* Business rule validation for arithmetic operations
* Graceful handling of invalid inputs and server errors
* Reusable assertion helpers for SOAP responses

### UI Testing

* UI automation using **Karate UI (Playwright engine)**
* End-to-end browser testing without Selenium
* Covers **login and registration validation flows**
* Extensive **negative and edge-case validation testing**
* Clean separate of API and UI tests using tags (`@api`, `@ui`)
* Demonstrates **API and UI testing in the same framework**

Useful resources:

* https://docs.karatelabs.io/extensions/ui-testing

### Performance Testing

* Lightweight performance validation using Karate, aimed at early detection of slow responses rather than full-scale
  load benchmarking.
* Goal is to **validate performance expectations during development and CI**, not to replicate dedicated load-testing
  tools
* Smoke-level performance checks integrated into automated tests
* Ensures critical flows respond within acceptable time limits
* Designed for fast feedback in CI pipelines
* Not intended for stress, soak or capacity testing

#### Performance coverage

| Type            | What it measures                     | Tools                      | 
|:----------------|:-------------------------------------|:---------------------------| 
| API performance | Endpoint response time and stability | Karate API (parallel runs) | 
| UI performance  | End-to-end user flow responsiveness  | Karate UI (Playwright)     | 

#### Notes

* API performance tests run in parallel to simulate concurrent requests
* UI performance tests run sequentially to avoid browser-level interference
* Thresholds are enforced at rest-runner level for clear pass/fail criteria

### Smoke and Sanity Testing

This project follows a layered test strategy to ensure fast feedback and stability.

#### Smoke Tests

Smoke tests answer the question:
> "Is the application stable enough to continue testing?"

Characteristics:

* Small and fast test suites
* To verify the system is up and usable
* Covers critical functionality only
* Executed on every CI build

Examples:

* Currently implemented for Auth endpoints and Auth UI pages

### Sanity Testing

Sanity tests answer the question:
> "Did the recent change break related functionality?"

Characteristics:

* Focused and deeper than smoke tests
* Executed after bug fixes or minor changes
* Validates end-to-end flows
* Short-lived and scoped to impacted areas only
* Promoted to regression tests once stability is confirmed

Examples:

* Not yet implemented - planned for future changes

### Logging Strategy

* Reduced default Karate verbosity
* Clean and readable CI logs
* Log output focused on failures and debugging needs
* Uses Logback configuration for fine-grained control

### CI/CD

* Tagged test execution (`@smoke`, `@sanity`)
* CI pipeline using **GitHub Actions**

<br/>

## Project Structure

The project follows a modular structure to separate test types, configurations, and reusable components.

```
.
├── src/test/java
│   ├── hooks                               # Global Karate runtime hooks (before/after scenario logging, cross-cutting concerns)
│   │   └── ScenarioLoggerHook.java
│   └── runners                             # JUnit runners that selects tags, features, and execution scope
│       ├── ApiTestRunner.java
│       ├── FullTestRunner.java
│       ├── KarateReportRunner.java
│       ├── PerformanceTestRunner.java
│       ├── SanityTestRunner.java
│       ├── SmokeTestRunner.java
│       ├── SoapTestRunner.java
│       └── UiTestRunner.java
├── src/test/resources
│   ├── api
│   │   ├── auth
│   │   │   ├── auth.feature                # High-level authertication test flows
│   │   │   ├── auth-performance.feature    # Auth performance tests
│   │   │   ├── login-user.feature          # Reusable feature for user login API 
│   │   │   └── register-user.feature       # Reusable feature for user registration API
│   │   └── bookings
│   │       ├── get-bookings.feature        # Reusable feature for user bookings API
│   │       └── user-bookings.feature       # High-level booking test flows
│   ├── common
│   │   ├── jwt-utils.js                    # JWT decoding and validation helpers
│   │   └── user-factory.js                 # Test data generators for users
│   ├── soap
│   │   ├── common 
│   │   │   └── soap-validators.js          # Reusable SOAP assertions
│   │   ├── requests                        # SOAP request templates
│   │   │   ├── add-integer.xml 
│   │   │   └── divide-integer.xml
│   │   └── integer-calculations.feature    # Arithmetic SOAP scenarios
│   ├── ui
│   │   ├── auth-ui.feature                 # UI Auth tests
│   │   └── smoke-ui.feature                # UI Smoke tests
│   ├── karate-config.js                    # Global configuration, environment setup
│   └── logback-test.xml                    # Logging configuration for Karate execution
├── pom.xml
└── README.md
```

<br/>

## Test Tagged Strategy

| Tag       | Purpose                            |
|:----------|:-----------------------------------|
| `@api`    | API-level tests                    |
| `@soap`   | SOAP service tests                 |
| `@ui`     | UI/browser tests                   |
| `@perf`   | Load & performance scenarios       |
| `@smoke`  | Build validation & critical checks |
| `@sanity` | Targeted validation after changes  |

<br/>

## Setup / Installation

1. Clone the repository:

```bash
git clone https://github.com/vraagakrishna/automation.testing.project.karate.git 
cd automation.testing.project.karate
```

2. Build the project

```bash
mvn clean install
```

<br/>

## Running Tests Locally

This project uses **Maven profiles** to control which test suites are executed.

### 1. Run Smoke Tests

Smoke tests are **fast, critical checks** to make sure the system is stable.
They should always be run first.

```bash
mvn test -Psmoke
```

**What it does:**

* Executed the smoke test runner (`SmokeTestRunner.java`)
* Intended as a gatekeeper before running longer test suites.

### 2. Run Full Test Suite

The full suite includes **API**, **UI**, and **integration tests**.

```bash
mvn test -Pfull
```

**What it does:**

* Executes full test runner (`FullTestRunner.java`)
* Should only be run **after smoke tests pass**

### 3. Run Performance Tests

Performance tests validate system behaviour under load.

```bash
mvn test -Pperf
```

**What this does:**

* Executes the performance test runner (`PerformanceTestRunner.java`)
* Should only be run after smoke tests pass

### 4. Generate Consolidated Test Report

Generates a **single merged HTML report** using results from all test runs.

```bash
mvn test -Preport
```

**What this does:**

* Executes the report generator (`KarateReportRunner.java`)
* Merged all `karate-reports*` folders into one report
* Includes screenshots and embedded evidence
* Can be run even if some tests fail

### Notes:

* Smoke tests act as a **gatekeeper**.
* If smoke tests fail, it is recommended **not** to run full or performance tests
* Reports can always be generated independently to inspect failures

<br/>

## CI/CD Pipelines

This repository includes a GitHub Actions workflow that:

1. Runs smoke tests on every push
2. Blocks full and performance tests when smoke fails
3. Generates consolidated HTML reports regardless fo test outcomes
4. Upload artifacts for review and traceability

<br/>
