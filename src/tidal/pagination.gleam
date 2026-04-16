/// Pagination component — renders page navigation using DaisyUI `join` buttons.
///
/// ```gleam
/// import tidal/pagination
///
/// pagination.new()
/// |> pagination.current_page(3)
/// |> pagination.total_pages(10)
/// |> pagination.show_prev
/// |> pagination.show_next
/// |> pagination.on_page(UserChangedPage)
/// |> pagination.build
/// ```
///
/// For large page counts, use `window/2` to limit how many page buttons are shown:
///
/// ```gleam
/// pagination.new()
/// |> pagination.current_page(5)
/// |> pagination.total_pages(50)
/// |> pagination.window(5)
/// |> pagination.show_prev
/// |> pagination.show_next
/// |> pagination.on_page(UserChangedPage)
/// |> pagination.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Pagination(msg) {
  Pagination(
    current: Int,
    total: Int,
    window: Int,
    show_prev: Bool,
    show_next: Bool,
    size: Option(Size),
    on_page: Option(fn(Int) -> msg),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Pagination(msg) {
  Pagination(
    current: 1,
    total: 1,
    window: 7,
    show_prev: False,
    show_next: False,
    size: None,
    on_page: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the currently active page (1-based).
pub fn current_page(p: Pagination(msg), n: Int) -> Pagination(msg) {
  Pagination(..p, current: n)
}

/// Sets the total number of pages.
pub fn total_pages(p: Pagination(msg), n: Int) -> Pagination(msg) {
  Pagination(..p, total: n)
}

/// Sets the maximum number of page buttons shown (default 7). Surrounding pages
/// are collapsed when the total exceeds this.
pub fn window(p: Pagination(msg), n: Int) -> Pagination(msg) {
  Pagination(..p, window: n)
}

/// Includes a "«" previous button.
pub fn show_prev(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, show_prev: True)
}

/// Includes a "»" next button.
pub fn show_next(p: Pagination(msg)) -> Pagination(msg) {
  Pagination(..p, show_next: True)
}

/// Sets the size of all page buttons.
pub fn size(p: Pagination(msg), s: Size) -> Pagination(msg) {
  Pagination(..p, size: Some(s))
}

/// Registers a callback receiving the selected page number.
pub fn on_page(p: Pagination(msg), msg: fn(Int) -> msg) -> Pagination(msg) {
  Pagination(..p, on_page: Some(msg))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(p: Pagination(msg), s: List(Style)) -> Pagination(msg) {
  Pagination(..p, styles: list.append(p.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  p: Pagination(msg),
  a: List(attribute.Attribute(msg)),
) -> Pagination(msg) {
  Pagination(..p, attrs: list.append(p.attrs, a))
}

// ---------------------------------------------------------------------------
// Build helpers
// ---------------------------------------------------------------------------

fn size_class(s: Option(Size)) -> String {
  case s {
    None -> ""
    Some(size.Xs) -> " btn-xs"
    Some(size.Sm) -> " btn-sm"
    Some(size.Md) -> ""
    Some(size.Lg) -> " btn-lg"
    Some(size.Xl) -> " btn-xl"
  }
}

fn page_btn(
  label: String,
  page: Int,
  active: Bool,
  disabled: Bool,
  handler: Option(fn(Int) -> msg),
  sz: Option(Size),
) -> Element(msg) {
  let sz_cls = size_class(sz)
  let cls = case active {
    True -> "join-item btn btn-active" <> sz_cls
    False -> "join-item btn" <> sz_cls
  }
  let click_attrs = case disabled, handler {
    True, _ -> [attribute.disabled(True)]
    False, Some(h) -> [event.on_click(h(page))]
    False, None -> []
  }
  html.button([attribute.class(cls), ..click_attrs], [element.text(label)])
}

fn ellipsis(sz: Option(Size)) -> Element(msg) {
  let sz_cls = size_class(sz)
  html.button([attribute.class("join-item btn btn-disabled" <> sz_cls)], [
    element.text("…"),
  ])
}

/// Computes visible page numbers around the current page within the window.
fn int_range(from: Int, to: Int) -> List(Int) {
  case from > to {
    True -> []
    False -> [from, ..int_range(from + 1, to)]
  }
}

fn visible_pages(current: Int, total: Int, win: Int) -> List(Int) {
  let half = win / 2
  let start = int.max(1, current - half)
  let last = int.min(total, start + win - 1)
  let start = int.max(1, last - win + 1)
  int_range(start, last)
}

pub fn build(p: Pagination(msg)) -> Element(msg) {
  let cls = case style.to_class_string(p.styles) {
    "" -> "join"
    s -> "join " <> s
  }

  let pages = visible_pages(p.current, p.total, p.window)
  let first_page = case pages {
    [f, ..] -> f
    [] -> 1
  }
  let last_page = case list.last(pages) {
    Ok(l) -> l
    Error(_) -> p.total
  }

  let prev_btn = case p.show_prev {
    False -> []
    True -> [page_btn("«", int.max(1, p.current - 1), False, p.current == 1, p.on_page, p.size)]
  }

  let leading_ellipsis = case first_page > 1 {
    False -> []
    True ->
      list.flatten([
        [page_btn("1", 1, False, False, p.on_page, p.size)],
        case first_page > 2 { True -> [ellipsis(p.size)] False -> [] },
      ])
  }

  let page_btns =
    list.map(pages, fn(n) {
      page_btn(int.to_string(n), n, n == p.current, False, p.on_page, p.size)
    })

  let trailing_ellipsis = case last_page < p.total {
    False -> []
    True ->
      list.flatten([
        case last_page < p.total - 1 { True -> [ellipsis(p.size)] False -> [] },
        [page_btn(int.to_string(p.total), p.total, False, False, p.on_page, p.size)],
      ])
  }

  let next_btn = case p.show_next {
    False -> []
    True -> [
      page_btn("»", int.min(p.total, p.current + 1), False, p.current == p.total, p.on_page, p.size),
    ]
  }

  html.div(
    [attribute.class(cls), ..p.attrs],
    list.flatten([prev_btn, leading_ellipsis, page_btns, trailing_ellipsis, next_btn]),
  )
}
