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
/// |> avatar.rounded
/// |> avatar.build
///
/// // Placeholder avatar with initials
/// avatar.new()
/// |> avatar.placeholder
/// |> avatar.initials("JD")
/// |> avatar.size(16)
/// |> avatar.rounded
/// |> avatar.ring_primary
/// |> avatar.build
/// ```
///
/// Group multiple avatars:
/// ```gleam
/// avatar.group_new()
/// |> avatar.avatars([
///   avatar.new() |> avatar.src("/a.jpg") |> avatar.size(8) |> avatar.rounded |> avatar.build,
///   avatar.new() |> avatar.src("/b.jpg") |> avatar.size(8) |> avatar.rounded |> avatar.build,
/// ])
/// |> avatar.group_build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Avatar(msg) {
  Avatar(
    src: Option(String),
    alt: String,
    is_placeholder: Bool,
    initials: Option(String),
    size: Int,
    rounded: Option(String),
    ring_color: Option(String),
    status: Option(String),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

pub opaque type AvatarGroup(msg) {
  AvatarGroup(
    avatars: List(Element(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Create a new avatar. Use `src(url)` for an image or `placeholder` + `initials(t)` for text.
pub fn new() -> Avatar(msg) {
  Avatar(
    src: None,
    alt: "",
    is_placeholder: False,
    initials: None,
    size: 12,
    rounded: None,
    ring_color: None,
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

/// Marks as a placeholder avatar — adds `avatar-placeholder` class.
pub fn placeholder(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, is_placeholder: True)
}

/// Sets the initials/text shown inside a placeholder avatar.
pub fn initials(a: Avatar(msg), text: String) -> Avatar(msg) {
  Avatar(..a, initials: Some(text))
}

/// Sets the avatar size using a Tailwind spacing scale value (e.g. `12` → `w-12 h-12`).
pub fn size(a: Avatar(msg), n: Int) -> Avatar(msg) {
  Avatar(..a, size: n)
}

/// Applies `rounded-full` to make the avatar circular.
pub fn rounded(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, rounded: Some("rounded-full"))
}

/// Applies `rounded-xl` for a squircle-ish shape.
pub fn rounded_box(a: Avatar(msg)) -> Avatar(msg) {
  Avatar(..a, rounded: Some("rounded-xl"))
}

/// Shows a green online indicator dot — `avatar-online`.
pub fn online(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, status: Some("avatar-online")) }
/// Shows a gray offline indicator dot — `avatar-offline`.
pub fn offline(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, status: Some("avatar-offline")) }

/// Ring in the primary colour.
pub fn ring_primary(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-primary")) }
/// Ring in the secondary colour.
pub fn ring_secondary(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-secondary")) }
/// Ring in the accent colour.
pub fn ring_accent(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-accent")) }
/// Ring in the neutral colour.
pub fn ring_neutral(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-neutral")) }
/// Ring in the info colour.
pub fn ring_info(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-info")) }
/// Ring in the success colour.
pub fn ring_success(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-success")) }
/// Ring in the warning colour.
pub fn ring_warning(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-warning")) }
/// Ring in the error colour.
pub fn ring_error(a: Avatar(msg)) -> Avatar(msg) { Avatar(..a, ring_color: Some("ring-error")) }

/// Appends presentation styles applied to the outer wrapper.
pub fn style(a: Avatar(msg), s: List(Style)) -> Avatar(msg) {
  Avatar(..a, styles: list.append(a.styles, s))
}

/// Appends HTML attributes to the outer wrapper.
pub fn attrs(a: Avatar(msg), at: List(attribute.Attribute(msg))) -> Avatar(msg) {
  Avatar(..a, attrs: list.append(a.attrs, at))
}

pub fn build(a: Avatar(msg)) -> Element(msg) {
  let size_str = string.inspect(a.size)
  let ring_classes = case a.ring_color {
    None -> None
    Some(c) -> Some("ring " <> c <> " ring-offset-base-100 ring-offset-2")
  }
  let inner_classes =
    [
      Some("w-" <> size_str),
      a.rounded,
      ring_classes,
    ]
    |> option.values
    |> string.join(" ")

  let inner_content = case a.src, a.initials {
    Some(url), _ ->
      html.img([attribute.src(url), attribute.alt(a.alt), attribute.class("")])
    None, Some(text) -> html.span([], [element.text(text)])
    None, None -> element.text("")
  }

  let inner = html.div([attribute.class(inner_classes)], [inner_content])

  let outer_classes =
    [
      Some("avatar"),
      case a.is_placeholder { True -> Some("avatar-placeholder") False -> None },
      a.status,
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

// ---------------------------------------------------------------------------
// AvatarGroup
// ---------------------------------------------------------------------------

/// Create a new avatar group — `<div class="avatar-group">`.
pub fn group_new() -> AvatarGroup(msg) {
  AvatarGroup(avatars: [], styles: [], attrs: [])
}

/// Appends avatar elements (built with `build`).
pub fn avatars(g: AvatarGroup(msg), els: List(Element(msg))) -> AvatarGroup(msg) {
  AvatarGroup(..g, avatars: list.append(g.avatars, els))
}

/// Appends presentation styles.
pub fn group_style(g: AvatarGroup(msg), s: List(Style)) -> AvatarGroup(msg) {
  AvatarGroup(..g, styles: list.append(g.styles, s))
}

/// Appends HTML attributes.
pub fn group_attrs(g: AvatarGroup(msg), a: List(attribute.Attribute(msg))) -> AvatarGroup(msg) {
  AvatarGroup(..g, attrs: list.append(g.attrs, a))
}

pub fn group_build(g: AvatarGroup(msg)) -> Element(msg) {
  let cls = case style.to_class_string(g.styles) {
    "" -> "avatar-group"
    s -> "avatar-group " <> s
  }
  html.div([attribute.class(cls), ..g.attrs], g.avatars)
}
