# Backlog tracking tool

## User stories :
- To organize the workload, we use a backlog of work. A backlog contains a list of Epics that can be
in a different states.
- Managers want to visualize the current status of Epics, as well as blocking Bugs and ongoing
Tasks.
- Developers and Testers should mark Tasks and Bugs as such once implemented/fixed.
Specs ;
- Epics may contain Tasks, Bugs and other Epics.
- Bugs and Tasks do not contain any other sub-elements.
- An Epic is "Work in progress" if it contains any task or if any of its linked epics is "Work in
progress",
- An Epic is "Pending validation" if all task are done (removed), but some Bugs are still pending fix
or if any of its linked epics is "Pending validation" (and none of them are "Work in progress"),
- An Epic is "Completed" if there is no remaining tasks and bugs, and if all its linked epics are
"Completed" too.
We provide a full backlog as a dictionary as follows:

`
{
"EpicA":
{
"Tasks": ["TaskA1", "TaskA2"],
"Bugs": [],
"Epics": ["EpicB"]
},
"EpicB":
{
"Tasks": ["TaskB1", "TaskB2"],
"Bugs": ["BugB1"],
"Epics": [""]
},
"EpicC":
{
"Tasks": [],
"Bugs": [],
"Epics": []
},
"EpicD":
{
"Tasks": [],
"Bugs": [],
"Epics": ["EpicC"]
},
"EpicE":
{
"Tasks": [],
"Bugs": ["BugE1"],
"Epics": []
}
}
`

###In this example:
- EpicC is "Completed" and validated: No task is pending, no bugs are reported and it depends on no
other epic.
- EpicD is "Completed" too: no task, no bug, and EpicC is done.
- EpicB and Epic A are "Work in progress": pending tasks, as well as a bugs.
- EpicE is "Pending validation". No more tasks means implementation is done, but some remaining
bugs means it's not ready yet.

### Exercise :
Write a minimalist web interface that should expose:
- An endpoint to parse a backlog, formatted as shown before. If any existing backlog is already in
use, those should be merged together.
- An endpoint to list all epics in the current backlog and their status:
- An endpoint to list all blocked Epics from a Bug name. This should highlight the "highest"
blocked Epics (i.e. the highest Epics in a tree view) - in case of multiple highest, highlight them all.
- An endpoint to list all Bugs from an Epic. This list should contain the selected Bugs as well as the
Bugs from the linked Epics.
- An endpoint to add a new Task or a new Bug in a given Epic. This should return the updated
backlog with new status for Epics.
- An endpoint to delete a Task or a Bug. This should return the updated backlog with new status for
Epics.
- An endpoint to export the current backlog in the dictionary format shown before.
Constraints :
- You can deliver the result as an archive or as a GitHub project.
- Explain design, architecture and implementation choice in a separate README file.
- Use any tool or technology you judge appropriate, make sure to justify such choices.
- Please respect Python coding conventions ; make sure your code is readable and include
comments when necessary.
- Explain how you developed and tested your code, including tools and methods used.
- Provide a valid dockerfile and instructions to run your code using containers, as we expect to be
able to run it on our current Kubernetes/Docker stack.
- The code must run, as we will test your code ourselves.

As it is just an exercise, we do not expect the result to be perfect. Discuss briefly why you made the
choices you made, what are the issues of the current implementation and how they should be
addressed in further development if this was a true product.


## HOW TO RUN: 

### Execute first the server.

In the README.md directory: 

`
docker build -t server .
`

`
docker run -p 8000:8000 server
`

or

`
docker-compose up
`

## TODOS: 
Format/comment code 

--------

tests

--------

espacer widgets dans main?


--------

Retourner "ok"/afficher checks verts (dynamique) 

--------

Compléter README.md

--------


Debug "bug mystique" 