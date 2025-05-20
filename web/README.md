# sv

Everything you need to build a Svelte project, powered by [`sv`](https://github.com/sveltejs/cli).

## Creating a project

If you're seeing this, you've probably already done this step. Congrats!

```bash
# create a new project in the current directory
npx sv create

# create a new project in my-app
npx sv create my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.

## Debugging

To debug the svelte server, run dev in debug mode.

[Jetbrains Webstorm instructions](https://www.jetbrains.com/help/webstorm/svelte.html#ws_svelte_debug).

## First time setup

- Assuming you have
- `npm i`
- `npm run dev`

### Connecting to the backend server

You will also need to connect to the API to use and test the app.
By default, I've configured the dev buid to point at a local rails server, and the deployed prod build to point at a deployed backend url. This is through VITE_API_URL in the .env files.

See the rails readme for instructions on running the rails server locally. Otherwise you will need to point to the deployed rails app.
