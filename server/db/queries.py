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


def format_document(document):
    formatted_document = {
        document["name"]: {
            "Tasks": [task["name"] for task in document["tasks"]],
            "Bugs": [bug["name"] for bug in document["bugs"]],
            "Epics": [epic["name"] for epic in document["epics"]]
        }
    }

    return formatted_document


def format_documents():
    client = MongoClient(port=27017)
    db = client.backlog_db
    res = {}
    epics_collection = db.epics
    cursor = epics_collection.find({})
    for document in cursor:
        res.update(format_document(document))
    return res
