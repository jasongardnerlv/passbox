#!/usr/bin/env bats

load test_helper

@test "get: Gets a formatted entry from the passbox file" {
    local db_password="password 12345"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get \"Entry 2\""

    assert_line 0 "Name:     Entry 2"
    assert_line 1 "Username: entry2@test.com"
    assert_line 2 "Password: 1234pass"
}

@test "get: Displays an error message if no 'entry name' argument is specified" {
    run ./passbox get

    assert_output "Error: Please specify the name of an entry to get"
}

@test "get: Displays an error message if an entry cannot be found" {
    local db_password="password 12345"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get \"Entry 3\""

    assert_line 0 "Error: No entries found"
}
