th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red"):bold()

th.git = th.git or {}
th.git.modified_sign = "M"
th.git.deleted_sign = "D"

require("git"):setup()
require("full-border"):setup()
