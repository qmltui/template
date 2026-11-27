/** @param {Runner} app */
function main(app) {
    const panel = app.item("mainPanel");
    panel.expectText("QmlTui Starter Application");
    panel.expectText("Status: Ready");

    // Increment via keyboard activation on the focused button.
    app.press("Enter");
    panel.expectText("Status: Clicked 1 time(s)");

    // Increment again by clicking rendered button text.
    app.clickText("Increment (+1)");
    panel.expectText("Status: Clicked 2 time(s)");

    // Reset via global shortcut.
    app.press("r", ["Ctrl"]);
    panel.expectText("Status: Ready");

    // Ensure layout stays clean across compact and wide viewports.
    app.resize(60, 18);
    app.item("mainPanel").expectText("Status: Ready");

    app.resize(120, 36);
    app.item("mainPanel").expectText("Status: Ready");

    const stats = app.frameStats();
    if (stats.dirtyDuringPaintTotal !== 0) {
        throw new Error("Expected dirtyDuringPaintTotal === 0, got " + stats.dirtyDuringPaintTotal);
    }
}
