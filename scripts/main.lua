function __G__TRACEBACK__(message)
    print("-------------------------------------------")
    print('Error: '..toString(message)..'\n')
    print(debug.traceback("", 2))
    print("-------------------------------------------")
end

require("app.App").new():run()
