/// Border radius scale — maps to Tailwind `rounded-*` classes.
pub type BorderRadius {
  None
  Sm
  Md
  Lg
  Xl
  Xl2
  Xl3
  Full
}

pub fn to_class(r: BorderRadius) -> String {
  case r {
    None -> "rounded-none"
    Sm -> "rounded-sm"
    Md -> "rounded-md"
    Lg -> "rounded-lg"
    Xl -> "rounded-xl"
    Xl2 -> "rounded-2xl"
    Xl3 -> "rounded-3xl"
    Full -> "rounded-full"
  }
}
