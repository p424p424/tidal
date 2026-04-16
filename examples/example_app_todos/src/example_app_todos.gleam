import gleam/list
import gleam/string
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import lustre/event
import tidal/badge
import tidal/button
import tidal/checkbox
import tidal/column
import tidal/el
import tidal/input
import tidal/row
import tidal/size
import tidal/spacer







import tidal/text
import tidal/variant
import tidal/styling as s

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
  |> el.style([
    s.min_h_screen(),
    s.flex(),
    s.flex_col(),
    s.items_start(),
    s.justify_start(),
    s.sm(s.items_center()),
    s.sm(s.justify_center()),
  ])
  |> el.attrs([attribute.class("bg-base-200")])
  |> el.children([
    el.new()
    |> el.style([
      s.w_full(),
      s.sm(s.max_w_md()),
      s.flex(),
      s.flex_col(),
      s.sm(s.rounded_xl()),
      s.sm(s.overflow_hidden()),
    ])
    |> el.attrs([attribute.class("bg-base-100 shadow-xl")])
    |> el.children([
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
  |> el.style([s.p(6), s.pb(4)])
  |> el.attrs([attribute.class("bg-primary")])
  |> el.children([
    text.new("My Todos")
      |> text.style([s.text_2xl(), s.font_bold()])
      |> text.attrs([attribute.class("text-primary-content")])
      |> text.build,
    row.new()
      |> row.style([s.mt(1), s.gap(2)])
      |> row.children([
        badge.new(count_label(active_count) <> " left")
          |> badge.attrs([attribute.class("badge-ghost opacity-80")])
          |> badge.build,
        case done_count > 0 {
          True ->
            badge.new(count_label(done_count) <> " done")
            |> badge.attrs([attribute.class("badge-ghost opacity-60")])
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
  |> row.style([s.p(4), s.gap(2), s.items_center()])
  |> row.attrs([attribute.class("border-b border-base-200")])
  |> row.children([
    input.new()
      |> input.placeholder("Add a todo…")
      |> input.value(current)
      |> input.style([s.w_full()])
      |> input.on_input(UserTyped)
      |> input.on_keydown(fn(key) {
        case key {
          "Enter" -> UserSubmitted
          _ -> UserTyped(current)
        }
      })
      |> input.build,
    button.new("Add")
      |> button.variant(variant.Primary)
      |> button.on_click(UserSubmitted)
      |> button.build,
  ])
  |> row.build
}

fn view_filter_bar(current: Filter) -> Element(Message) {
  row.new()
  |> row.style([s.px(4), s.py(2), s.gap(2)])
  |> row.attrs([attribute.class("border-b border-base-200")])
  |> row.children([
    filter_tab("All", All, current),
    filter_tab("Active", Active, current),
    filter_tab("Done", Done, current),
  ])
  |> row.build
}

fn filter_tab(label: String, f: Filter, current: Filter) -> Element(Message) {
  let is_active = f == current
  button.new(label)
  |> button.size(size.Sm)
  |> button.variant(case is_active {
    True -> variant.Primary
    False -> variant.Ghost
  })
  |> button.on_click(UserSetFilter(f))
  |> button.build
}

fn view_todo_list(todos: List(Todo)) -> Element(Message) {
  case todos {
    [] -> view_empty_state()
    _ ->
      column.new()
      |> column.style([s.w_full()])
      |> column.children(list.map(todos, view_todo_item))
      |> column.build
  }
}

fn view_empty_state() -> Element(Message) {
  el.new()
  |> el.style([
    s.py(12),
    s.flex(),
    s.flex_col(),
    s.items_center(),
    s.justify_center(),
    s.gap(2),
  ])
  |> el.children([
    text.new("Nothing here")
      |> text.style([s.text_lg(), s.font_medium()])
      |> text.attrs([attribute.class("text-base-content/40")])
      |> text.build,
    text.new("Add something above to get started")
      |> text.style([s.text_sm()])
      |> text.attrs([attribute.class("text-base-content/30")])
      |> text.build,
  ])
  |> el.build
}

fn view_todo_item(item: Todo) -> Element(Message) {
  let toggle = case item.done {
    True -> checkbox.checked
    False -> fn(c) { c }
  }

  row.new()
  |> row.style([
    s.px(4),
    s.py(3),
    s.items_center(),
    s.gap(3),
  ])
  |> row.attrs([attribute.class("border-b border-base-200 last:border-0")])
  |> row.children([
    checkbox.new()
      |> checkbox.variant(variant.Primary)
      |> toggle
      |> checkbox.on_check(fn(v) { UserToggledTodo(item.id, v) })
      |> checkbox.build,
    text.new(item.label)
      |> text.style([
        s.text_base(),
        s.sm(s.text_lg()),
        case item.done {
          True -> s.line_through()
          False -> s.font_normal()
        },
      ])
      |> text.attrs([
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
      |> row.style([s.p(4), s.justify_end()])
      |> row.attrs([attribute.class("border-t border-base-200")])
      |> row.children([
        button.new("Clear completed")
        |> button.size(size.Sm)
        |> button.variant(variant.Ghost)
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
