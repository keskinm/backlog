import uuid

from pymongo import MongoClient

work_in_progress = "Work in progress"
pending_validation = "Pending validation"
complete = "Complete"


def get_self_status(epic):
    if epic["tasks"]:
        res = work_in_progress
    elif epic["bugs"]:
        res = pending_validation
    else:
        res = complete
    return res


def get_rec_epics_status(epic, status):
    status.append(get_self_status(epic))

    for in_epic in epic["epics"]:
        status = get_rec_epics_status(in_epic, status)

    return status


def get_epic_status(epic):
    status = get_rec_epics_status(epic, [])
    if work_in_progress in status:
        res = work_in_progress
    elif pending_validation in status:
        res = pending_validation
    else:
        res = complete
    return res


def get_status():
    client = MongoClient(port=27017)
    db = client.backlog_db
    res = {}
    epics_collection = db.epics
    cursor = epics_collection.find({})
    for document in cursor:
        res.update({document["_id"]: get_epic_status(document)})
    return res


def dict_format_document(document):
    formatted_document = {
        document["name"]: {
            "Tasks": [task["name"] for task in document["tasks"]],
            "Bugs": [bug["name"] for bug in document["bugs"]],
            "Epics": [epic["name"] for epic in document["epics"]]
        }
    }

    return formatted_document


def dict_format_documents():
    client = MongoClient(port=27017)
    db = client.backlog_db
    res = {}
    epics_collection = db.epics
    cursor = epics_collection.find({})
    for document in cursor:
        res.update(dict_format_document(document))
    return res


def documents_format_dict(backlog_dict):
    documents = []
    for epic_name, epic in backlog_dict.items():
        client = MongoClient(port=27017)
        db = client.backlog_db
        epics_collection = db.epics

        if epics_collection.find_one({'name': epic_name}):
            print("epic already exists in data base")

        else:
            tasks, bugs, epics = [], [], []
            for task_name in epic["Tasks"]:
                tasks.append({'name': task_name, 'description': ''})

            for bug_name in epic["Bugs"]:
                bugs.append({'name': bug_name, 'description': ''})

            for sub_epic_name in epic["Epics"]:
                epics.append({'name': sub_epic_name, 'description': ''})

            doc_epic = {
                '_id': str(uuid.uuid4()),
                'name': epic_name,
                'tasks': tasks,
                'bugs': bugs,
                'epics': epics,
                'description': '',
            }
            documents.append(doc_epic)
    return documents


def link_to_merge_documents(partial_document_backlog):
    client = MongoClient(port=27017)
    db = client.backlog_db
    epics_collection = db.epics
    tasks_collection = db.tasks
    bugs_collection = db.bugs

    for document in partial_document_backlog:
        link_id(document, "epics", epics_collection)
        link_id(document, "tasks", tasks_collection)
        link_id(document, "bugs", bugs_collection)


def link_id(document, collection_name, collection):
    for sub in document[collection_name]:
        find_epic = collection.find_one({'name': sub['name']})
        if find_epic:
            sub["_id"] = find_epic["_id"]
        else:
            sub["_id"] = str(uuid.uuid4())


def update_backlog(backlog):
    client = MongoClient(port=27017)
    db = client.backlog_db
    epics_collection = db.epics

    backlog = documents_format_dict(backlog)
    link_to_merge_documents(backlog)
    epics_collection.insert_many(backlog)


def get_sub_tasks(epic, sub_tasks):
    for task in epic["tasks"]:
        sub_tasks.append(task["name"])

    for epic in epic["epics"]:
        sub_tasks += get_sub_tasks(epic, sub_tasks)
    return sub_tasks
