# command for executing external commands in a list of directories
def run-in-dir [command: string, ...args] {
  let directories = $in
  let directories_type = ($directories | describe)
  let $directories = if $directories_type == "list<string>" {
    $directories
  } else if $directories_type == "string" {
    [$directories]
  } else {
    error make {msg: "this command requires a list<string> as input"}
  }
  $directories | each { |d|
    let type = ($d | path type)
    let dir = if $type == "dir" {
      $d
    } else if $type == "file" {
      ($d | path dirname)
    } else {
      return
    }
    if ($dir | path type | is-empty) or (not ($dir | path exists)) {
      use std
      std log info $"Input: '($dir)' does not exist"
      return
    }
    cd $dir
    {"dir": $dir, "command": (run-external --redirect-combine $command $args | complete)}
  }
}
