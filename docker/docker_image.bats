#!/usr/bin/env bats

@test "cowsay" {
  run cowsay シェル芸
  [ $status -eq 0 ]
  [ "${lines[1]}" = '< シェル芸 >' ]
}

@test "ojichat" {
  run ojichat --version
  [ $status -eq 0 ]
  [[ "${lines[0]}" =~ 'Ojisan Nanchatte (ojichat) command' ]]
}
