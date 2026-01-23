# Karate Automation Testing Framework

## Project Goal

The primary goal of this project is to **explore**, **understand**, and **gain hands-on experience** with the **Karate
testing framework**.

> The **focus is _not_ on what is being tested**, but on **_how_ Karate can be used** to perform different types of
> testing using a single, unified tool.

This repository serves as a **learning and experimentation platform** showcasing what Karate offers across:

* API testing
* UI testing
* Authentication handling (JWT)
* Smoke and Sanity testing strategies
* Performance testing
* CI/CD integration
* Logging and code quality best practices

<br/>

## What This Project Demonstrates

### API Testing

* REST API testing based on Swagger documentation
* JSON request/response validation
* Positive and negative test scenarios
* JWT-based authentication handling
* Reusable feature files and shared test data

### SOAP API Testing

* SOAP service testing using Karate's built-in XML support
* WSDL-based request construction
* XML request and response validation
* XPath assertions for SOAP responses
* Demonstrates testing **REST and SOAP APIs within the same framework**

Examples include:

* SOAP request body construction
* Header and envelope validation
* Fault response handling

### UI Testing

* UI automation using **Karate UI (Playwright engine)**
* Login and registration flows
* Authenticated UI interactions
* Demonstrates API + UI testing using the **same framework**

### Smoke Testing

Smoke tests answer the question:
> "Is the application stable enough to continue testing?"

Characteristics:

* Small and fast test suites
* Covers critical functionality only
* Executed on every CI build

Examples:

* API health checks
* User registration
* Login
* Authenticated API access

### Sanity Testing

Sanity tests answer the question:
> "Did the recent change break related functionality?"

Characteristics:

* Focused and deeper than smoke tests
* Executed after bug fixes or minor changes
* Validates end-to-end flows

Examples:

* Login -> Get Profile -> Update Profile
* Authenticated testimonial operations

### Performance Testing

* Lightweight performance and load testing using Karate
* Focus on **understanding Karate's performance capabilities**, not benchmarking
* Suitable for smoke-level performance validation

### Logging Strategy

* Reduced default Karate verbosity
* Clean and readable CI logs
* Log output focused on failures and debugging needs
* Uses Logback configuration for fine-grained control

### Code Quality & CI/CD

* Java code quality checks (Checkstyle, SpotBugs)
* Tagged test execution (`@smoke`, `@sanity`)
* CI pipeline using **GitHub Actions**
* Automated quality gates to block failing builds

<br/>

## Project Structure

```
.
├── src/test/java
│   ├── hooks                           # Global Karate runtime hooks (before/after scenario logging, cross-cutting concerns)
│   │   └── ScenarioLoggerHook.java
│   └── runners                         # JUnit runners that selects tags, features, and execution scope
│       └── ApiTestRunner.java
├── src/test/resources
│   ├── api
│   │   ├── auth
│   │   │   ├── auth.feature            # High-level authertication test flows
│   │   │   ├── login-user.feature      # Reusable feature for user login API 
│   │   │   └── register-user.feature   # Reusable feature for user registration API
│   │   └── common
│   │       ├── jwt-utils.js            # JWT decoding and validation helpers
│   │       └── user-factory.js         # Test data generators for users
│   ├── karate-config.js                # Global configuration, environment setup
│   └── logback-test.xml                # Logging configuration for Karate execution
├── pom.xml
└── README.md
```

<br/>

## Authentication

* JWT-based authentication
* Token generation handled centrally
* Tokens reused across API and UI tests
* No hard-coded credentials or tokens

<br/>

## Test Tagged Strategy

| Tag            | Purpose                            |
|:---------------|:-----------------------------------|
| `@api`         | API-level tests                    |
| `@ui`          | UI/browser tests                   |
| `@soap`        | SOAP service tests                 |
| `@smoke`       | Build validation & critical checks |
| `@sanity`      | Targeted validation after changes  | 
| `@regression`  | Full test suite                    | 
| `@performance` | Load & performance scenarios       |

<br/>

## Running Tests Locally

TBC

<br/>

## CI/CD Pipelines

The CI pipeline automatically:

1. Runs smoke tests on every push
2. Runs sanity tests on pull requests
3. Fails the build on test or quality issues

<br/>




