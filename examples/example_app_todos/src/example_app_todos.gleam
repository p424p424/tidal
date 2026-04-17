import gleam/list
import gleam/string
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import lustre/event
import tidal/align
import tidal/badge
import tidal/button
import tidal/checkbox
import tidal/column
import tidal/el
import tidal/input
import tidal/row
import tidal/size
import tidal/spacer

import tidal/styling as style
import tidal/text

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

type Filter {
  All
  Active
  Done
}

type Todo {
  Todo(id: Int, label: String, done: Bool)
}

type Model {
  Model(todos: List(Todo), input: String, next_id: Int, filter: Filter)
}

fn init(_) -> Model {
  Model(
    todos: [
      Todo(id: 1, label: "Buy groceries", done: True),
      Todo(id: 2, label: "Walk the dog", done: False),
      Todo(id: 3, label: "Read a book", done: False),
    ],
    input: "",
    next_id: 4,
    filter: All,
  )
}

// ---------------------------------------------------------------------------
// Update
// ---------------------------------------------------------------------------

type Message {
  UserTyped(String)
  UserSubmitted
  UserToggledTodo(Int, Bool)
  UserDeletedTodo(Int)
  UserSetFilter(Filter)
  UserClearedDone
}

fn update(model: Model, message: Message) -> Model {
  case message {
    UserTyped(v) -> Model(..model, input: v)

    UserSubmitted -> {
      let trimmed = string.trim(model.input)
      case trimmed {
        "" -> model
        _ ->
          Model(
            ..model,
            todos: list.append(model.todos, [
              Todo(id: model.next_id, label: trimmed, done: False),
            ]),
            input: "",
            next_id: model.next_id + 1,
          )
      }
    }

    UserToggledTodo(id, done) ->
      Model(
        ..model,
        todos: list.map(model.todos, fn(t) {
          case t.id == id {
            True -> Todo(..t, done: done)
            False -> t
          }
        }),
      )

    UserDeletedTodo(id) ->
      Model(..model, todos: list.filter(model.todos, fn(t) { t.id != id }))

    UserSetFilter(f) -> Model(..model, filter: f)

    UserClearedDone ->
      Model(..model, todos: list.filter(model.todos, fn(t) { !t.done }))
  }
}

// ---------------------------------------------------------------------------
// View
// ---------------------------------------------------------------------------

fn view(model: Model) -> Element(Message) {
  let filtered = case model.filter {
    All -> model.todos
    Active -> list.filter(model.todos, fn(t) { !t.done })
    Done -> list.filter(model.todos, fn(t) { t.done })
  }

  let active_count = list.length(list.filter(model.todos, fn(t) { !t.done }))
  let done_count = list.length(list.filter(model.todos, fn(t) { t.done }))

  el.new()
  |> el.style(styles: [
    style.min_h_screen(),
    style.flex(),
    style.flex_col(),
    style.items_start(),
    style.justify_start(),
    style.sm(style.items_center()),
    style.sm(style.justify_center()),
  ])
  |> el.attrs(attributes: [attribute.class("bg-base-200")])
  |> el.children(elements: [
    el.new()
    |> el.style(styles: [
      style.w_full(),
      style.sm(style.max_w_md()),
      style.flex(),
      style.flex_col(),
      style.sm(style.rounded_xl()),
      style.sm(style.overflow_hidden()),
    ])
    |> el.attrs(attributes: [attribute.class("bg-base-100 shadow-xl")])
    |> el.children(elements: [
      view_header(active_count, done_count),
      view_input(model.input),
      view_filter_bar(model.filter),
      view_todo_list(filtered),
      view_footer(done_count),
    ])
    |> el.build,
  ])
  |> el.build
}

fn view_header(active_count: Int, done_count: Int) -> Element(Message) {
  el.new()
  |> el.style(styles: [style.p(6), style.pb(4)])
  |> el.attrs(attributes: [attribute.class("bg-primary")])
  |> el.children(elements: [
    text.new("My Todos")
      |> text.style(styles: [style.text_2xl(), style.font_bold()])
      |> text.attrs(attributes: [attribute.class("text-primary-content")])
      |> text.build,
    row.new()
      |> row.style(styles: [style.mt(1), style.gap(2)])
      |> row.children(elements: [
        badge.new()
          |> badge.label(text: count_label(active_count) <> " left")
          |> badge.attrs(attributes: [attribute.class("badge-ghost opacity-80")])
          |> badge.build,
        case done_count > 0 {
          True ->
            badge.new()
            |> badge.label(text: count_label(done_count) <> " done")
            |> badge.attrs(attributes: [
              attribute.class("badge-ghost opacity-60"),
            ])
            |> badge.build
          False -> element.none()
        },
      ])
      |> row.build,
  ])
  |> el.build
}

fn view_input(current: String) -> Element(Message) {
  row.new()
  |> row.style(styles: [style.p(4), style.gap(2), style.items_center()])
  |> row.attrs(attributes: [attribute.class("border-b border-base-200")])
  |> row.children(elements: [
    input.new()
      |> input.placeholder(text: "Add a todo…")
      |> input.value(to: current)
      |> input.style(styles: [style.w_full()])
      |> input.on_input(handler: UserTyped)
      |> input.on_keydown(handler: fn(key) {
        case key {
          "Enter" -> UserSubmitted
          _ -> UserTyped(current)
        }
      })
      |> input.build,
    button.new()
      |> button.label(text: "Add")
      |> button.primary
      |> button.on_click(UserSubmitted)
      |> button.build,
  ])
  |> row.build
}

fn view_filter_bar(current: Filter) -> Element(Message) {
  row.new()
  |> row.style(styles: [style.px(4), style.py(2), style.gap(2)])
  |> row.attrs(attributes: [attribute.class("border-b border-base-200")])
  |> row.children(elements: [
    filter_tab("All", All, current),
    filter_tab("Active", Active, current),
    filter_tab("Done", Done, current),
  ])
  |> row.build
}

fn filter_tab(label: String, f: Filter, current: Filter) -> Element(Message) {
  let is_active = f == current
  let b =
    button.new()
    |> button.label(text: label)
    |> button.size(size: size.Sm)
    |> button.on_click(UserSetFilter(f))
  case is_active {
    True -> b |> button.primary
    False -> b |> button.ghost
  }
  |> button.build
}

fn view_todo_list(todos: List(Todo)) -> Element(Message) {
  case todos {
    [] -> view_empty_state()
    _ ->
      column.new()
      |> column.style(styles: [style.w_full()])
      |> column.children(elements: list.map(todos, view_todo_item))
      |> column.build
  }
}

fn view_empty_state() -> Element(Message) {
  el.new()
  |> el.style(styles: [
    style.py(12),
    style.flex(),
    style.flex_col(),
    style.items_center(),
    style.justify_center(),
    style.gap(2),
  ])
  |> el.children(elements: [
    text.new("Nothing here")
      |> text.style(styles: [style.text_lg(), style.font_medium()])
      |> text.attrs(attributes: [attribute.class("text-base-content/40")])
      |> text.build,
    text.new("Add something above to get started")
      |> text.style(styles: [style.text_sm()])
      |> text.attrs(attributes: [attribute.class("text-base-content/30")])
      |> text.build,
  ])
  |> el.build
}

fn view_todo_item(item: Todo) -> Element(Message) {
  row.new()
  |> row.style(styles: [
    style.px(4),
    style.py(3),
    style.items_center(),
    style.gap(3),
  ])
  |> row.attrs(attributes: [
    attribute.class("border-b border-base-200 last:border-0"),
  ])
  |> row.children(elements: [
    checkbox.new()
      |> checkbox.primary
      |> checkbox.checked(to: item.done)
      |> checkbox.on_check(handler: fn(v) { UserToggledTodo(item.id, v) })
      |> checkbox.build,
    text.new(item.label)
      |> text.style(styles: [
        style.text_base(),
        style.sm(style.text_lg()),
        case item.done {
          True -> style.line_through()
          False -> style.font_normal()
        },
      ])
      |> text.attrs(attributes: [
        attribute.class(case item.done {
          True -> "text-base-content/40"
          False -> "text-base-content"
        }),
      ])
      |> text.build,
    spacer.spacer(),
    html.button(
      [
        attribute.class(
          "btn btn-ghost btn-sm btn-square opacity-40 hover:opacity-100",
        ),
        event.on_click(UserDeletedTodo(item.id)),
      ],
      [
        html.svg(
          [
            attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
            attribute.attribute("viewBox", "0 0 20 20"),
            attribute.attribute("fill", "currentColor"),
            attribute.class("w-4 h-4"),
          ],
          [
            svg.path([
              attribute.attribute("fill-rule", "evenodd"),
              attribute.attribute(
                "d",
                "M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z",
              ),
              attribute.attribute("clip-rule", "evenodd"),
            ]),
          ],
        ),
      ],
    ),
  ])
  |> row.build
}

fn view_footer(done_count: Int) -> Element(Message) {
  case done_count > 0 {
    False -> element.none()
    True ->
      row.new()
      |> row.style(styles: [style.p(4), style.justify_end()])
      |> row.attrs(attributes: [attribute.class("border-t border-base-200")])
      |> row.children(elements: [
        button.new()
        |> button.label(text: "Clear completed")
        |> button.size(size: size.Sm)
        |> button.ghost
        |> button.on_click(UserClearedDone)
        |> button.build,
      ])
      |> row.build
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn count_label(n: Int) -> String {
  case n {
    0 -> "0"
    1 -> "1"
    2 -> "2"
    3 -> "3"
    4 -> "4"
    5 -> "5"
    6 -> "6"
    7 -> "7"
    8 -> "8"
    9 -> "9"
    _ -> "9+"
  }
}
