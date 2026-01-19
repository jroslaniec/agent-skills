---
name: pytest-unit
description: Write pytest unit tests for Python code changes. Use when adding tests for new or modified Python code in projects that use pytest.
---

# Pytest Unit Tests

Guidelines for writing pytest unit tests for changed Python code.

## Discovering Project Conventions

Before writing tests, understand the project's testing setup:

### Test Location

Check where existing tests live:

- Separate `tests/` directory mirroring source structure
- Co-located with source files (`foo.py` and `test_foo.py` in same directory)
- Follow the established pattern; if none exists, use a `tests/` directory

### How to Run Tests

Look for test commands in:

- `README.md` - often documents the test command
- `Makefile` - look for `test` or `pytest` targets
- `pyproject.toml` - may have scripts defined
- Common commands: `make test`, `pytest`, `python -m pytest`

### Async Configuration

Check `pyproject.toml` for pytest-asyncio mode:

```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"  # or "strict"
```

- **`asyncio_mode = "auto"`**: No decorator needed on async tests
- **`asyncio_mode = "strict"`** (or not set): Requires `@pytest.mark.asyncio` on each async test

### Existing Fixtures

Review `conftest.py` files for available fixtures. Reuse existing fixtures rather than creating duplicates.

### Linting

Check lint configuration (`pyproject.toml`, `Makefile`, `ruff.toml`, `.flake8`). Tests must pass the same linters as production code.

## Test Data

**Use synthetic/mock data, never real data.**

```python
# Good: synthetic test data
def test_process_user():
    user = {"id": "test-123", "name": "Alice", "email": "alice@test.example"}
    result = process_user(user)
    assert result.processed is True
```

For external APIs or services:

- Mock external calls
- Use synthetic responses matching the expected schema
- Never embed real API keys, tokens, or credentials

## Test Structure

### Flat Functions Over Classes

Prefer flat test functions:

```python
# Preferred
async def test_create_user():
    """Test creating a new user."""
    user = await create_user("alice")
    assert user.name == "alice"


async def test_create_user_duplicate_name():
    """Test that duplicate names raise an error."""
    await create_user("alice")
    with pytest.raises(DuplicateNameError):
        await create_user("alice")
```

Use comments to group related tests if needed:

```python
# Tests for user creation


async def test_create_user():
    ...


async def test_create_user_with_email():
    ...


# Tests for user deletion


async def test_delete_user():
    ...
```

### Naming

Test functions should describe the scenario:

```python
# Good: describes what is being tested
async def test_create_user_with_valid_email():
    ...

async def test_create_user_rejects_invalid_email():
    ...

async def test_delete_user_returns_none_for_missing_user():
    ...
```

### Docstrings

Every test should have a docstring explaining what it tests:

```python
async def test_rate_limiter_blocks_after_threshold():
    """Test that requests are blocked after exceeding the rate limit."""
    limiter = RateLimiter(max_requests=5)
    for _ in range(5):
        assert await limiter.allow()
    assert not await limiter.allow()
```

## Fixtures

### Use Fixtures for Setup/Teardown

```python
@pytest.fixture
def sample_config():
    """Provide sample configuration for tests."""
    return {
        "timeout": 30,
        "retries": 3,
    }


async def test_apply_config(sample_config):
    result = await apply_config(sample_config)
    assert result.timeout == 30
```

### Use `yield` for Cleanup

```python
@pytest.fixture
def temp_file(tmp_path):
    """Create a temporary file that gets cleaned up."""
    file_path = tmp_path / "test.txt"
    file_path.write_text("test content")
    yield file_path
    # Cleanup happens automatically via tmp_path
```

### Async Fixtures

No decorator needed with `asyncio_mode = "auto"`:

```python
@pytest.fixture
async def db_connection():
    """Provide a database connection."""
    conn = await create_connection()
    yield conn
    await conn.close()
```

### Fixture Naming

Name fixtures after what they provide:

```python
@pytest.fixture
def valid_user():
    ...

@pytest.fixture
def expired_token():
    ...

@pytest.fixture
async def populated_database():
    ...
```

## Database Test Isolation

Tests must not read from or write to production databases.

### Environment Variable Override

```python
# conftest.py
@pytest.fixture
def isolated_db(monkeypatch, tmp_path):
    """Provide an isolated database for testing."""
    monkeypatch.setenv("DATA_DIR", str(tmp_path))
    reset_db_engine()
    get_config.cache_clear()
    yield DB()
    reset_db_engine()
    get_config.cache_clear()
```

### Dependency Injection

```python
@pytest.fixture
async def test_db(tmp_path):
    """Provide a test database."""
    db_path = tmp_path / "test.db"
    db = Database(path=db_path)
    await db.initialize()
    yield db
    await db.close()
```

### Singleton Reset Functions

If code uses singletons, provide reset functions for testing:

```python
# In production code
_engine: Engine | None = None

def get_engine() -> Engine:
    global _engine
    if _engine is None:
        _engine = create_engine()
    return _engine

def reset_engine() -> None:
    """Reset engine singleton. For testing only."""
    global _engine
    _engine = None
```

## Helper Functions

### Define Helpers in Test Files

Small helpers used by multiple tests go at the top of the test file:

```python
"""Tests for user management."""

import uuid
import pytest


def random_username() -> str:
    """Generate a unique username for testing."""
    return f"user-{uuid.uuid4().hex[:8]}"


def random_email() -> str:
    """Generate a unique email for testing."""
    return f"{uuid.uuid4().hex[:8]}@test.example"


async def test_create_user():
    user = await create_user(random_username(), random_email())
    assert user is not None
```

### conftest.py Usage

`conftest.py` is auto-loaded by pytest - cannot import from it directly. Put fixtures in `conftest.py`, helper functions in test files or a separate utils module:

```python
# conftest.py - fixtures only
@pytest.fixture
def isolated_db():
    ...

# tests/helpers.py - importable helpers
def random_id() -> str:
    ...

# tests/test_something.py
from tests.helpers import random_id  # Works
from conftest import isolated_db     # Does NOT work
```

## Assertions

### Plain `assert` Statements

pytest provides rich assertion introspection:

```python
assert user.name == "alice"
assert len(results) == 3
assert error is None
```

### Whole Structure Assertions

Prefer asserting entire structures. Use `unittest.mock.ANY` for generated values:

```python
from unittest.mock import ANY


async def test_create_comment():
    comment = await create_comment(content="Hello", author="alice")

    assert comment == {
        "id": ANY,
        "content": "Hello",
        "author": "alice",
        "created_at": ANY,
    }


async def test_create_user():
    user = await create_user(name="alice", email="alice@example.com")

    assert user == User(
        id=ANY,
        name="alice",
        email="alice@example.com",
        created_at=ANY,
    )
```

Benefits:

- Catches unexpected or missing fields
- Makes expected shape explicit
- Easier to read and maintain
- Clear diff output on failure

## Parameterization

Use `@pytest.mark.parametrize` for multiple inputs:

```python
@pytest.mark.parametrize(
    "input,expected",
    [
        ("hello", "HELLO"),
        ("World", "WORLD"),
        ("123", "123"),
        ("", ""),
    ],
)
def test_uppercase(input, expected):
    assert uppercase(input) == expected
```

## Error Testing

Use `pytest.raises` for exceptions:

```python
async def test_delete_missing_user_raises():
    """Test that deleting a non-existent user raises NotFoundError."""
    with pytest.raises(NotFoundError):
        await delete_user("nonexistent-id")


async def test_invalid_email_error_message():
    """Test that invalid email shows helpful error message."""
    with pytest.raises(ValidationError, match="Invalid email format"):
        await create_user(email="not-an-email")
```

## Coverage Target

Aim for close to 100% coverage on the changed code:

- Test happy paths
- Test edge cases and boundary conditions
- Test error conditions
- Test any branching logic

## Running Tests

After writing tests:

1. Run the new tests to verify they pass
1. Run linters to ensure code style compliance
1. Consider running the full test suite to check for regressions
