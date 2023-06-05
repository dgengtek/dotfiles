# get environment variables as records from sh variable or export lines
def env-from-raw [] {
  parse -r '(export[ ]+)?(?P<k>.+?)=(?P<v>.+)' | reduce -f {} {|x, acc| $acc | upsert $x.k $x.v}
}

# output shell environment variables from env records
def env-to-raw [
  --export (-e): bool  # prefix variables with export
] {
  let out = (
    $in | items {|k, v|
      if $export {
        echo $"export ($k)=($v)"
      } else {
        echo $"($k)=($v)"
      }
    }
  )
  $out | str join "\n"
}
