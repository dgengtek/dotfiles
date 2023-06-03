# command for executing external commands in a list of directories
def run-in-dir [directories: list, command: string] {
  $directories | wrap dir | each { |d|
    let dir = ($d.dir | path dirname)
    cd $dir
    {"dir": $dir, "command": (run-external --redirect-combine $command | complete)}
  }
}
