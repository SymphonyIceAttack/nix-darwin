return {
    entry = function()
        local output = Command("git"):arg("status"):stderr(Command.PIPED):output()
        if output.stderr ~= "" then
            ya.notify({
                title = "lazyjj",
                content = "Not in a git directory\nError: " .. output.stderr,
                level = "warn",
                timeout = 5,
            })
        else
            permit = ya.hide()
            local output, err_code = Command("lazyjj"):stderr(Command.PIPED):output()
            if err_code ~= nil then
                ya.notify({
                    title = "Failed to run lazyjj command",
                    content = "Status: " .. err_code,
                    level = "error",
                    timeout = 5,
                })
        end
    end,
}
