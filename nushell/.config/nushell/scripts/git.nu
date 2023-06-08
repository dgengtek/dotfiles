# get git state for the given path
def get-git-state [dir: path] {
  if not ($dir | path exists) {
    error make {msg: $"($dir): path does not exist"}
  }
  let dir = if ($dir | path type) == "dir" {
    $dir
  } else {
    $dir | path dirname
  }
  cd $dir
  git_state.py | from json
}


# cd to git top level
def cdgittop [] {
  cd (git rev-parse --show-toplevel | str trim)
}
