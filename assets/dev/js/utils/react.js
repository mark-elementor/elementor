import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { createRoot } from 'react-dom/client';

/**
 * Support conditional rendering of a React App to the DOM, based on the React version.
 * We use `createRoot` when available, but fallback to `ReactDOM.render` for older versions.
 *
 * @param {React.ReactElement} app - The app to render.
 * @param {HTMLElement} domElement - The DOM element to render the app into.
 *
 * @return {{root: ReactDOM.Root | null, renderResult: any}} The root object, if it was created, `null` otherwise; and the render result.
 */
function render( app, domElement ) {
	let root = null;
	let renderResult;

	try {
		root = createRoot( domElement );

		renderResult = root.render( app );
	} catch ( e ) {
		renderResult = ReactDOM.render( app, domElement );
	}

	return {
		root,
		renderResult,
	};
}

/**
 * Unmounts a React app from the DOM.
 *
 * @param {ReactDOM.Root | null} root - The root object of the app.
 * @param {HTMLElement} domElement - The DOM element where the app is rendered.
 */
function unmount( root, domElement ) {
	try {
		if ( root ) {
			root.unmount();
		}
	} catch ( e ) {
		// eslint-disable-next-line react/no-deprecated
		ReactDOM.unmountComponentAtNode( domElement );
	}
}

export default {
	render,
	unmount,
};
