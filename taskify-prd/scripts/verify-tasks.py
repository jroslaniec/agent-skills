#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "pydantic>=2.0",
# ]
# ///
"""Verify prd.json structure and content."""

import json
import sys
from pathlib import Path

from pydantic import BaseModel, Field, field_validator


class UserStory(BaseModel):
    """A single user story / task."""

    id: str = Field(description="Story ID, e.g., US-001")
    title: str = Field(description="Short task title")
    description: str = Field(description="As a... I want... so that...")
    acceptanceCriteria: list[str] = Field(  # noqa: N815
        description="List of verifiable criteria", min_length=1
    )
    priority: int = Field(description="Execution order", ge=1)
    passes: bool = Field(description="Whether task is complete", default=False)
    notes: str = Field(description="Optional notes", default="")

    @field_validator("id")
    @classmethod
    def validate_id(cls, v: str) -> str:
        if not v.startswith("US-"):
            raise ValueError(f"ID must start with 'US-', got: {v}")
        return v

    @field_validator("acceptanceCriteria")
    @classmethod
    def validate_criteria(cls, v: list[str]) -> list[str]:
        vague_terms = ["works correctly", "good ux", "handles edge cases", "easily"]
        for criterion in v:
            lower = criterion.lower()
            for term in vague_terms:
                if term in lower:
                    raise ValueError(
                        f"Criterion too vague (contains '{term}'): {criterion}"
                    )
        return v


class TasksFile(BaseModel):
    """The prd.json structure."""

    prd: str = Field(description="Source PRD name (without .md)")
    branchName: str = Field(description="Git branch name for this feature")  # noqa: N815
    description: str = Field(description="Feature description")
    userStories: list[UserStory] = Field(  # noqa: N815
        description="List of tasks", min_length=1
    )

    @field_validator("branchName")
    @classmethod
    def validate_branch_name(cls, v: str) -> str:
        if " " in v:
            raise ValueError(f"Branch name cannot contain spaces: {v}")
        if not v.islower() and "-" not in v and "_" not in v:
            raise ValueError(f"Branch name should be kebab-case: {v}")
        return v

    @field_validator("userStories")
    @classmethod
    def validate_story_order(cls, v: list[UserStory]) -> list[UserStory]:
        priorities = [s.priority for s in v]
        if priorities != sorted(priorities):
            raise ValueError(
                f"Stories must be ordered by priority. Got: {priorities}"
            )

        ids = [s.id for s in v]
        if len(ids) != len(set(ids)):
            raise ValueError(f"Duplicate story IDs found: {ids}")

        return v


def verify_tasks(file_path: Path) -> bool:
    """Verify a prd.json file."""
    if not file_path.exists():
        print(f"Error: File not found: {file_path}")
        return False

    try:
        with open(file_path) as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON: {e}")
        return False

    try:
        tasks = TasksFile(**data)
    except Exception as e:
        print(f"Error: Validation failed: {e}")
        return False

    # Summary
    print(f"PRD: {tasks.prd}")
    print(f"Branch: {tasks.branchName}")
    print(f"Stories: {len(tasks.userStories)}")
    print()

    for story in tasks.userStories:
        status = "PASS" if story.passes else "PENDING"
        print(f"  [{status}] {story.id}: {story.title}")
        print(f"           Criteria: {len(story.acceptanceCriteria)}")

    print()
    print("Validation passed!")
    return True


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path-to-prd.json>")
        sys.exit(1)

    file_path = Path(sys.argv[1])
    success = verify_tasks(file_path)
    sys.exit(0 if success else 1)
