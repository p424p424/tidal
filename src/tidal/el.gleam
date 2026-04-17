/// Generic container element — renders as a `<div>`.
///
/// Use `el` when you need a plain block container without any built-in layout
/// behaviour. For flex layouts use `row` or `column` instead.
///
/// ```gleam
/// import tidal/el
/// import tidal/styling as s
///
/// el.new()
/// |> el.style(styles: [s.p(4)])
/// |> el.children(elements: [...])
/// |> el.build
/// ```
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type El(msg) {
  El(
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Creates a new `El` builder — a plain `<div>` with no default styles.
///
/// Chain builder functions to configure the element, then call `build`:
///
/// ```gleam
/// import tidal/el
/// import tidal/styling as s
///
/// el.new()
/// |> el.style(styles: [s.flex(), s.flex_col(), s.gap(4)])
/// |> el.children(elements: [header_el, body_el])
/// |> el.build
/// ```
///
/// See also:
/// - Tailwind utility classes: https://tailwindcss.com/docs/utility-first
/// - Lustre element docs: https://hexdocs.pm/lustre/lustre/element/html.html
pub fn new() -> El(msg) {
  El(styles: [], attrs: [], children: [])
}

/// Appends presentation styles. May be called multiple times.
pub fn style(el: El(msg), styles styles: List(Style)) -> El(msg) {
  El(..el, styles: list.append(el.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
///
/// Use this as an escape hatch for attributes not covered by the builder
/// (e.g. `attribute.id("main")`, `event.on_click(msg)`).
pub fn attrs(
  el: El(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> El(msg) {
  El(..el, attrs: list.append(el.attrs, attributes))
}

/// Sets the child elements. May be called multiple times — children accumulate.
pub fn children(el: El(msg), elements elements: List(Element(msg))) -> El(msg) {
  El(..el, children: list.append(el.children, elements))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(el: El(msg)) -> Element(msg) {
  html.div(
    [attribute.class(style.to_class_string(el.styles)), ..el.attrs],
    el.children,
  )
}
