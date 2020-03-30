#!/usr/bin/env python3

import asyncio
import iterm2

LIGHT_THEME = "LuciusLightHighContrast"
DARK_THEME = "Unicon"


async def maybe_update_theme(connection, theme):
    # Themes have space-delimited attributes, one of which will be light or dark.
    parts = theme.split(" ")
    preset_name = LIGHT_THEME if "light" in parts else DARK_THEME
    preset = await iterm2.ColorPreset.async_get(connection, preset_name)

    # Update the list of all profiles and iterate over them.
    profiles = await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        # Fetch the full profile and then set the color preset in it.
        profile = await partial.async_get_full_profile()
        await profile.async_set_color_preset(preset)


async def main(connection):
    # check theme on startup
    app = await iterm2.async_get_app(connection)
    theme = await app.async_get_variable("effectiveTheme")
    await maybe_update_theme(connection, theme)

    # check theme whenever it changes
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, "effectiveTheme", None) as mon:
        while True:
            # Block until theme changes
            theme = await mon.async_get()

            await maybe_update_theme(connection, theme)

iterm2.run_forever(main)

