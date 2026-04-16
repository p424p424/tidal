/// Flex wrap behaviour — maps to Tailwind `flex-wrap`, `flex-nowrap`, `flex-wrap-reverse`.
/// Used by flex container components (`row`, `column`).
pub type Wrap {
  Wrap
  Nowrap
  WrapReverse
}

pub fn to_class(w: Wrap) -> String {
  case w {
    Wrap -> "flex-wrap"
    Nowrap -> "flex-nowrap"
    WrapReverse -> "flex-wrap-reverse"
  }
}
