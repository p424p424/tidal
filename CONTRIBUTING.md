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
gleam run -m lustre/dev_tools serve
```

---

## How the codebase is organised

```
src/tidal/          # Components and layout primitives
src/tidal/style/    # Tailwind utility wrappers
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

pub fn new(...) -> MyComponent(msg)      // sensible defaults
pub fn some_modifier(...) -> MyComponent(msg)
pub fn style(c: MyComponent(msg), s: List(Style)) -> MyComponent(msg)  // always APPENDs
pub fn attrs(c: MyComponent(msg), a: List(Attribute(msg))) -> MyComponent(msg)  // always APPENDs
pub fn build(c: MyComponent(msg)) -> Element(msg)
```

The `style()` and `attrs()` functions must always **append** to the existing list, never replace it. This is what lets users call `style()` multiple times and have all calls accumulate.

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
