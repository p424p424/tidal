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
import tidal/dock
import tidal/el
import tidal/indicator
import tidal/input
import tidal/row
import tidal/size
import tidal/styling as s
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
      Todo(id: 1, label: "Design the new app layout", done: True),
      Todo(id: 2, label: "Review pull requests", done: False),
      Todo(id: 3, label: "Update the documentation", done: False),
      Todo(id: 4, label: "Write unit tests", done: False),
    ],
    input: "",
    next_id: 5,
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

  let total_count = list.length(model.todos)
  let active_count = list.length(list.filter(model.todos, fn(t) { !t.done }))
  let done_count = list.length(list.filter(model.todos, fn(t) { t.done }))

  el.new()
  |> el.attrs(attributes: [
    attribute.attribute("data-theme", "tasks"),
    attribute.class("min-h-screen bg-base-100"),
  ])
  |> el.children(elements: [
    view_navbar(model.input, total_count),
    view_content(filtered, model.filter, done_count),
    view_dock(model.filter, total_count, active_count, done_count),
  ])
  |> el.build
}

// ---------------------------------------------------------------------------
// Navbar
// ---------------------------------------------------------------------------

fn view_navbar(current: String, total: Int) -> Element(Message) {
  el.new()
  |> el.attrs(attributes: [
    attribute.class(
      "tasks-glass fixed top-0 inset-x-0 z-50 border-b border-white/5",
    ),
  ])
  |> el.children(elements: [
    el.new()
    |> el.style(styles: [s.px(5), s.pt(5), s.pb(4)])
    |> el.children(elements: [
      // App title row
      row.new()
        |> row.style(styles: [s.items_center(), s.justify_between(), s.mb(4)])
        |> row.children(elements: [
          el.new()
            |> el.children(elements: [
              html.h1(
                [
                  attribute.class(
                    "text-2xl font-black tracking-tight tasks-gradient-text leading-none",
                  ),
                ],
                [html.text("Tasks")],
              ),
              html.p(
                [
                  attribute.class(
                    "text-xs text-base-content/40 mt-0.5 font-medium",
                  ),
                ],
                [html.text("Stay on top of your day")],
              ),
            ])
            |> el.build,
          // Task count pill
          html.span(
            [
              attribute.class(
                "text-xs font-semibold px-2.5 py-1 rounded-full bg-primary/15 text-primary tabular-nums",
              ),
            ],
            [html.text(count_label(total) <> " tasks")],
          ),
        ])
        |> row.build,
      // Input row
      row.new()
        |> row.style(styles: [s.gap(2), s.items_center()])
        |> row.children(elements: [
          el.new()
            |> el.attrs(attributes: [attribute.class("flex-1 relative")])
            |> el.children(elements: [
              html.span(
                [
                  attribute.class(
                    "absolute left-3 top-1/2 -translate-y-1/2 text-base-content/30 pointer-events-none",
                  ),
                ],
                [icon_search()],
              ),
              input.new()
                |> input.placeholder(text: "Add a new task…")
                |> input.value(to: current)
                |> input.attrs(attributes: [
                  attribute.class(
                    "input w-full bg-base-200/70 border-transparent focus:border-primary/50 focus:bg-base-200 pl-9 transition-all duration-200 text-sm",
                  ),
                ])
                |> input.on_input(handler: UserTyped)
                |> input.on_keydown(handler: fn(key) {
                  case key {
                    "Enter" -> UserSubmitted
                    _ -> UserTyped(current)
                  }
                })
                |> input.build,
            ])
            |> el.build,
          html.button(
            [
              attribute.class(
                "btn btn-primary btn-square shrink-0 shadow-lg shadow-primary/20",
              ),
              event.on_click(UserSubmitted),
            ],
            [icon_plus()],
          ),
        ])
        |> row.build,
    ])
    |> el.build,
  ])
  |> el.build
}

// ---------------------------------------------------------------------------
// Main content
// ---------------------------------------------------------------------------

fn view_content(
  todos: List(Todo),
  current_filter: Filter,
  done_count: Int,
) -> Element(Message) {
  el.new()
  |> el.attrs(attributes: [
    attribute.class("pt-36 pb-24 px-4 min-h-screen"),
  ])
  |> el.children(elements: [
    case todos {
      [] -> view_empty_state(current_filter)
      _ ->
        column.new()
        |> column.style(styles: [s.gap(2), s.pb(4)])
        |> column.children(
          elements: list.append(list.map(todos, view_todo_item), [
            case current_filter == Done && done_count > 0 {
              True -> view_clear_done_btn()
              False -> element.none()
            },
          ]),
        )
        |> column.build
    },
  ])
  |> el.build
}

fn view_todo_item(item: Todo) -> Element(Message) {
  let card_class = case item.done {
    True ->
      "todo-item flex items-center gap-3 px-4 py-3.5 rounded-2xl bg-base-200/40 border border-white/3"
    False ->
      "todo-item flex items-center gap-3 px-4 py-3.5 rounded-2xl bg-base-200 border border-white/5 shadow-sm shadow-black/20"
  }

  html.div([attribute.class(card_class)], [
    // Checkbox
    checkbox.new()
      |> checkbox.primary
      |> checkbox.checked(to: item.done)
      |> checkbox.on_check(handler: fn(v) { UserToggledTodo(item.id, v) })
      |> checkbox.build,
    // Label
    html.span(
      [
        attribute.class(case item.done {
          True ->
            "flex-1 text-sm font-medium line-through text-base-content/30 select-none"
          False -> "flex-1 text-sm font-medium text-base-content select-none"
        }),
      ],
      [html.text(item.label)],
    ),
    // Delete button
    html.button(
      [
        attribute.class(
          "btn btn-ghost btn-xs btn-square text-base-content/20 hover:text-error hover:bg-error/10 transition-all duration-150",
        ),
        event.on_click(UserDeletedTodo(item.id)),
      ],
      [icon_x()],
    ),
  ])
}

fn view_empty_state(filter: Filter) -> Element(Message) {
  let message = case filter {
    All -> #("No tasks yet", "Add something above to get started")
    Active -> #("All caught up!", "Nothing left to do — nice work")
    Done -> #("Nothing completed yet", "Check off some tasks to see them here")
  }

  el.new()
  |> el.style(styles: [
    s.flex(),
    s.flex_col(),
    s.items_center(),
    s.justify_center(),
    s.gap(3),
    s.py(16),
  ])
  |> el.children(elements: [
    html.div(
      [
        attribute.class(
          "size-16 rounded-3xl bg-primary/10 flex items-center justify-center mb-2",
        ),
      ],
      [
        html.span([attribute.class("text-primary/60 size-8")], [
          icon_empty(filter),
        ]),
      ],
    ),
    text.new(message.0)
      |> text.attrs(attributes: [
        attribute.class("text-base font-semibold text-base-content/50"),
      ])
      |> text.build,
    text.new(message.1)
      |> text.attrs(attributes: [
        attribute.class("text-sm text-base-content/30 text-center max-w-xs"),
      ])
      |> text.build,
  ])
  |> el.build
}

fn view_clear_done_btn() -> Element(Message) {
  el.new()
  |> el.style(styles: [s.flex(), s.justify_center(), s.pt(4)])
  |> el.children(elements: [
    button.new()
    |> button.label(text: "Clear completed")
    |> button.size(size: size.Sm)
    |> button.ghost
    |> button.attrs(attributes: [
      attribute.class("text-base-content/40 hover:text-error"),
    ])
    |> button.on_click(UserClearedDone)
    |> button.build,
  ])
  |> el.build
}

// ---------------------------------------------------------------------------
// Dock
// ---------------------------------------------------------------------------

fn view_dock(
  current: Filter,
  total: Int,
  active: Int,
  done: Int,
) -> Element(Message) {
  dock.new()
  |> dock.attrs(attributes: [
    attribute.class(
      "tasks-glass fixed bottom-0 inset-x-0 z-50 border-t border-white/5",
    ),
  ])
  |> dock.items(entries: [
    dock_filter_item(
      icon_list(),
      total,
      "All",
      UserSetFilter(All),
      current == All,
    ),
    dock_filter_item(
      icon_circle_dot(),
      active,
      "Active",
      UserSetFilter(Active),
      current == Active,
    ),
    dock_filter_item(
      icon_check_circle(),
      done,
      "Done",
      UserSetFilter(Done),
      current == Done,
    ),
  ])
  |> dock.build
}

fn dock_filter_item(
  icon: Element(Message),
  count: Int,
  label: String,
  msg: Message,
  is_active: Bool,
) {
  let icon_el = case count {
    0 -> icon
    _ ->
      indicator.new()
      |> indicator.child(element: icon)
      |> indicator.badge(
        element: badge.new()
        |> badge.label(text: count_label(count))
        |> badge.primary
        |> badge.size(size: size.Xs)
        |> badge.build,
      )
      |> indicator.build
  }

  let item = dock.dock_item(icon_el, label, msg)
  case is_active {
    True -> dock.dock_active(item)
    False -> item
  }
}

// ---------------------------------------------------------------------------
// Icons  (24×24 Heroicons — stroke style)
// ---------------------------------------------------------------------------

fn icon_plus() -> Element(msg) {
  html.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2.5"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.class("size-5"),
    ],
    [
      svg.path([attribute.attribute("d", "M12 4.5v15m7.5-7.5h-15")]),
    ],
  )
}

fn icon_x() -> Element(msg) {
  html.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.class("size-4"),
    ],
    [
      svg.path([attribute.attribute("d", "M6 18L18 6M6 6l12 12")]),
    ],
  )
}

fn icon_search() -> Element(msg) {
  html.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.class("size-4"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607z",
        ),
      ]),
    ],
  )
}

fn icon_list() -> Element(msg) {
  html.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.class("size-6"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M8.25 6.75h12M8.25 12h12m-12 5.25h12M3.75 6.75h.007v.008H3.75V6.75zm.375 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0zM3.75 12h.007v.008H3.75V12zm.375 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0zm-.375 5.25h.007v.008H3.75v-.008zm.375 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0z",
        ),
      ]),
    ],
  )
}

fn icon_circle_dot() -> Element(msg) {
  html.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.class("size-6"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0z",
        ),
      ]),
    ],
  )
}

fn icon_check_circle() -> Element(msg) {
  html.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.class("size-6"),
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M9 12.75L11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z",
        ),
      ]),
    ],
  )
}

fn icon_empty(filter: Filter) -> Element(msg) {
  case filter {
    All ->
      html.svg(
        [
          attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
          attribute.attribute("viewBox", "0 0 24 24"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
          attribute.attribute("stroke-width", "1.5"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-linejoin", "round"),
          attribute.class("size-8"),
        ],
        [
          svg.path([
            attribute.attribute(
              "d",
              "M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2",
            ),
          ]),
        ],
      )
    Active ->
      html.svg(
        [
          attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
          attribute.attribute("viewBox", "0 0 24 24"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
          attribute.attribute("stroke-width", "1.5"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-linejoin", "round"),
          attribute.class("size-8"),
        ],
        [
          svg.path([
            attribute.attribute(
              "d",
              "M9 12.75L11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z",
            ),
          ]),
        ],
      )
    Done ->
      html.svg(
        [
          attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
          attribute.attribute("viewBox", "0 0 24 24"),
          attribute.attribute("fill", "none"),
          attribute.attribute("stroke", "currentColor"),
          attribute.attribute("stroke-width", "1.5"),
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-linejoin", "round"),
          attribute.class("size-8"),
        ],
        [
          svg.path([
            attribute.attribute(
              "d",
              "M21 11.25v8.25a1.5 1.5 0 0 1-1.5 1.5H5.25a1.5 1.5 0 0 1-1.5-1.5V4.875C3.75 3.839 4.589 3 5.625 3h9.75a1.875 1.875 0 0 1 0 3.75H5.625M9 13.5l2.25 2.25L15.75 9",
            ),
          ]),
        ],
      )
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
