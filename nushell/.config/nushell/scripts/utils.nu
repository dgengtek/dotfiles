# command for executing external commands in a list of directories
def run-external-dir [command: string, --disable-capture, --sync, ...args] {
  let directories = $in
  let directories_type = ($directories | describe)
  let $directories = if $directories_type == "list<string>" {
    $directories
  } else if $directories_type == "string" {
    [$directories]
  } else {
    error make {msg: "this command requires a list<string> as input"}
  }

  let run_external_dir = { |d|
    let dir = (__get_valid_directory $d)
    if ($dir | is-empty) {
      use std
      std log info $"Input: '($dir)' does not exist"
      return
    }
    cd $dir
    let result = if $disable_capture {
      run-external $command ...$args
      $command
    } else {
      run-external $command ...$args | complete
    }
    {"dir": $dir, "command": $result}
  }
  if $sync {
    $directories | each $run_external_dir
  } else {
    $directories | par-each $run_external_dir
  }
}


def __get_valid_directory [directory: string] {
    let type = ($directory | path type)
    let dir = if $type == "dir" {
      $directory
    } else if $type == "file" {
      ($directory | path dirname)
    } else {
      return
    }
    if ($dir | path type | is-empty) or (not ($dir | path exists)) {
      return
    }
    $dir
}
