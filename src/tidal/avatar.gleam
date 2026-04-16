/// Avatar component — renders a DaisyUI `avatar` with image or text placeholder.
///
/// ```gleam
/// import tidal/avatar
///
/// // Image avatar
/// avatar.new()
/// |> avatar.src("/images/user.jpg")
/// |> avatar.alt("Jane Doe")
/// |> avatar.size(16)
/// |> avatar.rounded()
/// |> avatar.build
///
/// // Placeholder avatar (initials)
/// avatar.new()
/// |> avatar.placeholder("JD")
/// |> avatar.size(16)
/// |> avatar.rounded()
/// |> avatar.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type Status {
  Online
  Offline
}

pub opaque type Avatar(msg) {
  Avatar(
    src: Option(String),
    alt: String,
    placeholder: Option(String),
    size: Int,
    rounded: Bool,
    ring: Option(Variant),
    status: Option(Status),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Avatar(msg) {
  Avatar(
    src: None,
    alt: "",
    placeholder: None,
    size: 12,
    rounded: False,
    ring: None,
    status: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the image source URL.
pub fn src(a: Avatar(msg), url: String) -> Avatar(msg) {
  Avatar(..a, src: Some(url))
}

/// Sets the `alt` text for the image.
pub fn alt(a: Avatar(msg), text: String) -> Avatar(msg) {
  Avatar(..a, alt: text)
}

/// Shows a text placeholder (e.g. initials) instead of an image.
pub fn placeholder(a: Avatar(msg), text: String) -> Avatar(msg) {
  Avatar(..a, placeholder: Some(text))
}

/// Sets the avatar size using a Tailwind spacing scale value (e.g. `12` → `w-12 h-12`).
pub fn size(a: Avatar(msg), n: Int) -> Avatar(msg) {
  Avatar(..a, size: n)
}

/// Applies `rounded-full` to make the avatar circular.
pub fn rounded(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, rounded: True)
}

/// Adds a ring outline in the given variant colour.
pub fn ring(a: Avatar(msg), v: Variant) -> Avatar(msg) {
  Avatar(..a, ring: Some(v))
}

/// Adds an `Online` or `Offline` status indicator.
pub fn status(a: Avatar(msg), s: Status) -> Avatar(msg) {
  Avatar(..a, status: Some(s))
}

/// Appends presentation styles applied to the outer wrapper. May be called multiple times.
pub fn style(a: Avatar(msg), s: List(Style)) -> Avatar(msg) {
  Avatar(..a, styles: list.append(a.styles, s))
}

/// Appends HTML attributes to the outer wrapper. May be called multiple times.
pub fn attrs(a: Avatar(msg), at: List(attribute.Attribute(msg))) -> Avatar(msg) {
  Avatar(..a, attrs: list.append(a.attrs, at))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn ring_class(v: Variant) -> String {
  case v {
    variant.Primary -> "ring ring-primary ring-offset-base-100 ring-offset-2"
    variant.Secondary ->
      "ring ring-secondary ring-offset-base-100 ring-offset-2"
    variant.Accent -> "ring ring-accent ring-offset-base-100 ring-offset-2"
    _ -> "ring ring-offset-base-100 ring-offset-2"
  }
}

fn status_class(s: Status) -> String {
  case s {
    Online -> "avatar-online"
    Offline -> "avatar-offline"
  }
}

pub fn build(a: Avatar(msg)) -> Element(msg) {
  let size_str = string.inspect(a.size)
  let inner_classes =
    [
      Some("w-" <> size_str),
      case a.rounded { True -> Some("rounded-full") False -> None },
      option.map(a.ring, ring_class),
    ]
    |> option.values
    |> string.join(" ")

  let inner_content = case a.src, a.placeholder {
    Some(url), _ ->
      html.img([attribute.src(url), attribute.alt(a.alt), attribute.class("")])
    None, Some(text) -> html.span([], [element.text(text)])
    None, None -> element.text("")
  }

  let inner = html.div([attribute.class(inner_classes)], [inner_content])

  let outer_classes =
    [
      Some("avatar"),
      case a.placeholder {
        Some(_) -> Some("avatar-placeholder")
        None -> None
      },
      option.map(a.status, status_class),
      case style.to_class_string(a.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.div([attribute.class(outer_classes), ..a.attrs], [inner])
}
