/// Avatar component — renders a DaisyUI `avatar` with image or text placeholder.
///
/// ```gleam
/// import tidal/avatar
///
/// // Image avatar
/// avatar.new()
/// |> avatar.src(url: "/images/user.jpg")
/// |> avatar.alt(text: "Jane Doe")
/// |> avatar.size(units: 16)
/// |> avatar.rounded
/// |> avatar.build
///
/// // Placeholder avatar with initials
/// avatar.new()
/// |> avatar.placeholder
/// |> avatar.initials(text: "JD")
/// |> avatar.size(units: 16)
/// |> avatar.rounded
/// |> avatar.ring_primary
/// |> avatar.build
/// ```
///
/// Group multiple avatars:
/// ```gleam
/// avatar.group_new()
/// |> avatar.avatars(elements: [
///   avatar.new() |> avatar.src(url: "/a.jpg") |> avatar.size(units: 8) |> avatar.rounded |> avatar.build,
///   avatar.new() |> avatar.src(url: "/b.jpg") |> avatar.size(units: 8) |> avatar.rounded |> avatar.build,
/// ])
/// |> avatar.group_build
/// ```
///
/// See also:
/// - DaisyUI avatar docs: https://daisyui.com/components/avatar/
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

/// Creates a new `Avatar` builder. Use `src(url:)` for an image or `placeholder` + `initials(text:)` for text.
///
/// Chain builder functions to configure the avatar, then call `build`:
///
/// ```gleam
/// import tidal/avatar
///
/// avatar.new()
/// |> avatar.src(url: "/images/user.jpg")
/// |> avatar.alt(text: "Jane Doe")
/// |> avatar.size(units: 12)
/// |> avatar.rounded
/// |> avatar.build
/// ```
///
/// See also:
/// - DaisyUI avatar docs: https://daisyui.com/components/avatar/
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
pub fn src(avatar: Avatar(msg), url url: String) -> Avatar(msg) {
  Avatar(..avatar, src: Some(url))
}

/// Sets the `alt` text for the image.
pub fn alt(avatar: Avatar(msg), text text: String) -> Avatar(msg) {
  Avatar(..avatar, alt: text)
}

/// Marks as a placeholder avatar — adds `avatar-placeholder` class.
pub fn placeholder(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, is_placeholder: True)
}

/// Sets the initials/text shown inside a placeholder avatar.
pub fn initials(avatar: Avatar(msg), text text: String) -> Avatar(msg) {
  Avatar(..avatar, initials: Some(text))
}

/// Sets the avatar size using a Tailwind spacing scale value (e.g. `12` → `w-12 h-12`).
pub fn size(avatar: Avatar(msg), units units: Int) -> Avatar(msg) {
  Avatar(..avatar, size: units)
}

/// Applies `rounded-full` to make the avatar circular.
pub fn rounded(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, rounded: Some("rounded-full"))
}

/// Applies `rounded-xl` for a squircle-ish shape.
pub fn rounded_box(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, rounded: Some("rounded-xl"))
}

/// Shows a green online indicator dot — `avatar-online`.
pub fn online(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, status: Some("avatar-online"))
}

/// Shows a gray offline indicator dot — `avatar-offline`.
pub fn offline(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, status: Some("avatar-offline"))
}

/// Ring in the primary colour.
pub fn ring_primary(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-primary"))
}

/// Ring in the secondary colour.
pub fn ring_secondary(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-secondary"))
}

/// Ring in the accent colour.
pub fn ring_accent(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-accent"))
}

/// Ring in the neutral colour.
pub fn ring_neutral(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-neutral"))
}

/// Ring in the info colour.
pub fn ring_info(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-info"))
}

/// Ring in the success colour.
pub fn ring_success(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-success"))
}

/// Ring in the warning colour.
pub fn ring_warning(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-warning"))
}

/// Ring in the error colour.
pub fn ring_error(avatar: Avatar(msg)) -> Avatar(msg) {
  Avatar(..avatar, ring_color: Some("ring-error"))
}

/// Appends presentation styles applied to the outer wrapper.
pub fn style(avatar: Avatar(msg), styles styles: List(Style)) -> Avatar(msg) {
  Avatar(..avatar, styles: list.append(avatar.styles, styles))
}

/// Appends HTML attributes to the outer wrapper.
pub fn attrs(
  avatar: Avatar(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Avatar(msg) {
  Avatar(..avatar, attrs: list.append(avatar.attrs, attributes))
}

pub fn build(avatar: Avatar(msg)) -> Element(msg) {
  let size_str = string.inspect(avatar.size)
  let ring_classes = case avatar.ring_color {
    None -> None
    Some(c) -> Some("ring " <> c <> " ring-offset-base-100 ring-offset-2")
  }
  let inner_classes =
    [
      Some("w-" <> size_str),
      avatar.rounded,
      ring_classes,
    ]
    |> option.values
    |> string.join(" ")

  let inner_content = case avatar.src, avatar.initials {
    Some(url), _ ->
      html.img([
        attribute.src(url),
        attribute.alt(avatar.alt),
        attribute.class(""),
      ])
    None, Some(text) -> html.span([], [element.text(text)])
    None, None -> element.text("")
  }

  let inner = html.div([attribute.class(inner_classes)], [inner_content])

  let outer_classes =
    [
      Some("avatar"),
      case avatar.is_placeholder {
        True -> Some("avatar-placeholder")
        False -> None
      },
      avatar.status,
      case style.to_class_string(avatar.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.div([attribute.class(outer_classes), ..avatar.attrs], [inner])
}

// ---------------------------------------------------------------------------
// AvatarGroup
// ---------------------------------------------------------------------------

/// Creates a new `AvatarGroup` — `<div class="avatar-group">`.
///
/// ```gleam
/// avatar.group_new()
/// |> avatar.avatars(elements: [avatar1, avatar2, avatar3])
/// |> avatar.group_build
/// ```
///
/// See also:
/// - DaisyUI avatar docs: https://daisyui.com/components/avatar/
pub fn group_new() -> AvatarGroup(msg) {
  AvatarGroup(avatars: [], styles: [], attrs: [])
}

/// Appends avatar elements (built with `build`).
pub fn avatars(
  group: AvatarGroup(msg),
  elements elements: List(Element(msg)),
) -> AvatarGroup(msg) {
  AvatarGroup(..group, avatars: list.append(group.avatars, elements))
}

/// Appends presentation styles.
pub fn group_style(
  group: AvatarGroup(msg),
  styles styles: List(Style),
) -> AvatarGroup(msg) {
  AvatarGroup(..group, styles: list.append(group.styles, styles))
}

/// Appends HTML attributes.
pub fn group_attrs(
  group: AvatarGroup(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> AvatarGroup(msg) {
  AvatarGroup(..group, attrs: list.append(group.attrs, attributes))
}

pub fn group_build(group: AvatarGroup(msg)) -> Element(msg) {
  let cls = case style.to_class_string(group.styles) {
    "" -> "avatar-group"
    s -> "avatar-group " <> s
  }
  html.div([attribute.class(cls), ..group.attrs], group.avatars)
}
