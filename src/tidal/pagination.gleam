/// Pagination component — renders page navigation using DaisyUI `join` buttons.
///
/// ```gleam
/// import tidal/pagination
///
/// pagination.new()
/// |> pagination.current_page(to: 3)
/// |> pagination.total_pages(to: 10)
/// |> pagination.show_prev
/// |> pagination.show_next
/// |> pagination.on_page(UserChangedPage)
/// |> pagination.build
/// ```
///
/// For large page counts, use `window` to limit how many page buttons are shown:
///
/// ```gleam
/// pagination.new()
/// |> pagination.current_page(to: 5)
/// |> pagination.total_pages(to: 50)
/// |> pagination.window(size: 5)
/// |> pagination.show_prev
/// |> pagination.show_next
/// |> pagination.on_page(UserChangedPage)
/// |> pagination.build
/// ```
///
/// See also:
/// - DaisyUI pagination docs: https://daisyui.com/components/pagination/
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

/// Creates a new `Pagination` builder with defaults (page 1 of 1, window 7).
///
/// Chain builder functions to configure the pagination, then call `build`:
///
/// ```gleam
/// import tidal/pagination
///
/// pagination.new()
/// |> pagination.current_page(to: model.page)
/// |> pagination.total_pages(to: model.total_pages)
/// |> pagination.show_prev
/// |> pagination.show_next
/// |> pagination.on_page(UserChangedPage)
/// |> pagination.build
/// ```
///
/// See also:
/// - DaisyUI pagination docs: https://daisyui.com/components/pagination/
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
pub fn current_page(
  pagination: Pagination(msg),
  to page: Int,
) -> Pagination(msg) {
  Pagination(..pagination, current: page)
}

/// Sets the total number of pages.
pub fn total_pages(
  pagination: Pagination(msg),
  to total: Int,
) -> Pagination(msg) {
  Pagination(..pagination, total: total)
}

/// Sets the maximum number of page buttons shown (default 7). Surrounding pages
/// are collapsed when the total exceeds this.
pub fn window(pagination: Pagination(msg), size size: Int) -> Pagination(msg) {
  Pagination(..pagination, window: size)
}

/// Includes a "«" previous button.
pub fn show_prev(pagination: Pagination(msg)) -> Pagination(msg) {
  Pagination(..pagination, show_prev: True)
}

/// Includes a "»" next button.
pub fn show_next(pagination: Pagination(msg)) -> Pagination(msg) {
  Pagination(..pagination, show_next: True)
}

/// Sets the size of all page buttons.
pub fn size(pagination: Pagination(msg), size size: Size) -> Pagination(msg) {
  Pagination(..pagination, size: Some(size))
}

/// Registers a callback receiving the selected page number.
pub fn on_page(
  pagination: Pagination(msg),
  handler handler: fn(Int) -> msg,
) -> Pagination(msg) {
  Pagination(..pagination, on_page: Some(handler))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(
  pagination: Pagination(msg),
  styles styles: List(Style),
) -> Pagination(msg) {
  Pagination(..pagination, styles: list.append(pagination.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  pagination: Pagination(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Pagination(msg) {
  Pagination(..pagination, attrs: list.append(pagination.attrs, attributes))
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

pub fn build(pagination: Pagination(msg)) -> Element(msg) {
  let cls = case style.to_class_string(pagination.styles) {
    "" -> "join"
    s -> "join " <> s
  }

  let pages =
    visible_pages(pagination.current, pagination.total, pagination.window)
  let first_page = case pages {
    [f, ..] -> f
    [] -> 1
  }
  let last_page = case list.last(pages) {
    Ok(l) -> l
    Error(_) -> pagination.total
  }

  let prev_btn = case pagination.show_prev {
    False -> []
    True -> [
      page_btn(
        "«",
        int.max(1, pagination.current - 1),
        False,
        pagination.current == 1,
        pagination.on_page,
        pagination.size,
      ),
    ]
  }

  let leading_ellipsis = case first_page > 1 {
    False -> []
    True ->
      list.flatten([
        [page_btn("1", 1, False, False, pagination.on_page, pagination.size)],
        case first_page > 2 {
          True -> [ellipsis(pagination.size)]
          False -> []
        },
      ])
  }

  let page_btns =
    list.map(pages, fn(n) {
      page_btn(
        int.to_string(n),
        n,
        n == pagination.current,
        False,
        pagination.on_page,
        pagination.size,
      )
    })

  let trailing_ellipsis = case last_page < pagination.total {
    False -> []
    True ->
      list.flatten([
        case last_page < pagination.total - 1 {
          True -> [ellipsis(pagination.size)]
          False -> []
        },
        [
          page_btn(
            int.to_string(pagination.total),
            pagination.total,
            False,
            False,
            pagination.on_page,
            pagination.size,
          ),
        ],
      ])
  }

  let next_btn = case pagination.show_next {
    False -> []
    True -> [
      page_btn(
        "»",
        int.min(pagination.total, pagination.current + 1),
        False,
        pagination.current == pagination.total,
        pagination.on_page,
        pagination.size,
      ),
    ]
  }

  html.div(
    [attribute.class(cls), ..pagination.attrs],
    list.flatten([
      prev_btn,
      leading_ellipsis,
      page_btns,
      trailing_ellipsis,
      next_btn,
    ]),
  )
}
