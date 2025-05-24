# BumbleBeans 🐝 Frontend

Welcome to the BumbleBeans frontend!!!

## First time setup

- Assuming you have run -
- `npm i`
- `npm i -D`
- `npm run dev`

### Connecting to the backend server

You will also need to connect to the API to use and test the app.
By default, I've configured the dev buid to point at a local rails server, and the deployed prod build to point at a deployed backend url. This is through VITE_API_URL in the .env files.

See the rails readme for instructions on running the rails server locally. Otherwise you will need to point to the deployed rails app.

## Developing

Once you've downloaded the project and installed dependencies with `npm install` (or `pnpm install` or `yarn`) and the `devDependencies` with `npm i -D`, start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

### Formatting

Ensure that you've installed the `devDependencies` for the project using `npm install --save-dev` or `npm i -D`. The `devDependencies` includes `prettier`, `husky` and `lint-staged` which will help ensure consistent code formatting for the project across developers.

You can also install the `editorconfig` [plugin](https://editorconfig.org/#download) to enable your editor of choice to read the `.editorconfig` file and adhere to defined styles.

## Building

To create a production version of BumbleBeans:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.

## Debugging

To debug the svelte server, run dev in debug mode.

[Jetbrains Webstorm instructions](https://www.jetbrains.com/help/webstorm/svelte.html#ws_svelte_debug).
