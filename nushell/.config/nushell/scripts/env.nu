# reduce a 2 column table to key value records
def reduce_kv_to_record [] {
    rename k v | reduce -f {} {|it, acc| $acc | upsert $it.k $it.v}
}

# get environment variables as records from sh variable or export lines passed as input
def env-from-raw [] {
  parse -r '(export[ ]+)?(?P<k>.+?)=(?P<v>.+)' | reduce -f {} {|x, acc| $acc | upsert $x.k $x.v}
}

# output shell environment variables from env records or 2 column table
def env-to-raw [
  --export (-e) # prefix variables with export
] {
  let vars = $in
  let vars = (if ($vars | describe) =~ "table.*" {
    $vars | reduce_kv_to_record
  }
  else {
    $vars
  })
  let out = (
    $vars | items {|k, v|
      if $export {
        echo $"export ($k)=($v)"
      } else {
        echo $"($k)=($v)"
      }
    }
  )
  $out | str join "\n"
}
