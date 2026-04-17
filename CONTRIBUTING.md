# Contributing to Tidal

Thanks for your interest. Contributions are welcome — bug fixes, new utilities, improved docs, and example apps alike.

---

## Getting started

```sh
git clone https://github.com/p424p424/tidal
cd tidal
gleam deps download
gleam build
```

Run the tests:

```sh
gleam test
```

Run the example app:

```sh
cd examples/example_app_todos
gleam deps download
npm install
gleam run -m lustre/dev start
```

---

## How the codebase is organised

```
src/tidal/          # Components and layout primitives
priv/tidal.js       # Tailwind safelist (auto-scanned by Tailwind)
examples/           # Example applications
```

**Every component follows the same pattern:**

```gleam
pub opaque type MyComponent(msg) {
  MyComponent(
    // fields
  )
}

pub fn new() -> MyComponent(msg)      // sensible defaults; always takes no args
pub fn some_modifier(component: MyComponent(msg), value value: ValueType) -> MyComponent(msg)
pub fn style(component: MyComponent(msg), styles styles: List(Style)) -> MyComponent(msg)  // always APPENDs
pub fn attrs(component: MyComponent(msg), attributes attributes: List(Attribute(msg))) -> MyComponent(msg)  // always APPENDs
pub fn build(component: MyComponent(msg)) -> Element(msg)
```

The `style()` and `attrs()` functions must always **append** to the existing list, never replace it. This is what lets users call `style()` multiple times and have all calls accumulate.

**Labeled arguments:** All public functions beyond the piped component itself must use Gleam's labeled argument syntax (`label internal: Type`). For example:

```gleam
pub fn label(btn: Button(msg), text text: String) -> Button(msg)
pub fn size(btn: Button(msg), size size: Size) -> Button(msg)
pub fn on_click(btn: Button(msg), handler handler: msg) -> Button(msg)
pub fn style(btn: Button(msg), styles styles: List(Style)) -> Button(msg)
pub fn attrs(btn: Button(msg), attributes attributes: List(Attribute(msg))) -> Button(msg)
```

This lets callers write `button.label(text: "Save")` and `button.size(size: size.Sm)`, which reads clearly in documentation and editor hover tooltips.

**Descriptive parameter names:** Never use single-letter parameter names (`a`, `b`, `s`, `t`, `c`, etc.) in public functions. Use the full descriptive name that matches the label.

**`new()` doc comments:** Every `new()` function must have a doc comment that explains what it creates, shows a full builder chain example, and links to the relevant DaisyUI/Lustre docs.

---

## Adding a style utility

1. Find the right module under `src/tidal/style/`.
2. Add a `pub fn` that calls `make("tailwind-class-name")`.
3. Add the class name (or a representative set of values for parameterised utilities) to `priv/tidal.js` so Tailwind includes it in the output.
4. Follow the naming convention of the surrounding functions.

For parameterised utilities (e.g. `p(n: Int)`), the safelist in `priv/tidal.js` should cover the common scale values (0–16 at minimum, up to 96 where the spacing scale goes).

---

## Adding a component

1. Create `src/tidal/ComponentName.gleam`.
2. Follow the opaque builder pattern above.
3. Export `new`, all modifiers, `style`, `attrs`, and `build` as `pub fn`.
4. If the component emits events, add named event functions (`on_click`, `on_input`, etc.) rather than requiring users to pass raw attributes.
5. Add the module to the component table in `README.md`.

---

## Submitting changes

- Open an issue first for anything beyond a straightforward bug fix or missing utility, so we can align on the approach before you write code.
- Keep commits focused — one logical change per commit.
- `gleam build` and `gleam test` must pass with zero warnings.
- For new components or style modules, include a usage example in the module doc comment.

---

## Code style

Tidal follows standard `gleam format` output. Run `gleam format` before committing. No other style conventions beyond what the formatter enforces.
