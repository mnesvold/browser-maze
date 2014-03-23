define [], () ->
    task_queue = []
    
    window.addEventListener 'message', (event) ->
        if event.origin != window.location.origin
            return
        task = task_queue.pop[0]
#        console.log task
        if not task?
            return
        task()
    
    queueTask = (func) ->
        task_queue.push func
        window.postMessage 'task-queue', '*'

#    return queueTask

    fakeQueueTask = (func) ->
        func()

