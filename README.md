# Karate Automation Testing Framework

## Project Goal

The primary goal of this project is to **explore**, **understand**, and **gain hands-on experience** with the **Karate
testing framework**.

> The **focus is _not_ on what is being tested**, but on **_how_ Karate can be used** to perform different types of
> testing using a single, unified tool.

This repository serves as a **learning and experimentation platform** showcasing what Karate offers across:

* API testing
* SOAP API testing
* UI testing
* Smoke and Sanity testing
* Performance testing
* CI/CD integration

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

* https://docs.karatelabs.io/extensions/ui-testing/#shared-features


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

### CI/CD

* Tagged test execution (`@smoke`, `@sanity`)
* CI pipeline using **GitHub Actions**

<br/>

## Project Structure

```
.
├── src/test/java
│   ├── hooks                               # Global Karate runtime hooks (before/after scenario logging, cross-cutting concerns)
│   │   └── ScenarioLoggerHook.java
│   └── runners                             # JUnit runners that selects tags, features, and execution scope
│       ├── ApiTestRunner.java
│       ├── SoapTestRunner.java
│       └── UiTestRunner.java
├── src/test/resources
│   ├── api
│   │   ├── auth
│   │   │   ├── auth.feature                # High-level authertication test flows
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
│   │   └── auth-ui.feature                 # UI Auth tests
│   ├── karate-config.js                    # Global configuration, environment setup
│   └── logback-test.xml                    # Logging configuration for Karate execution
├── pom.xml
└── README.md
```

<br/>

## Test Tagged Strategy

| Tag            | Purpose                            |
|:---------------|:-----------------------------------|
| `@api`         | API-level tests                    |
| `@soap`        | SOAP service tests                 |
| `@ui`          | UI/browser tests                   |
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




