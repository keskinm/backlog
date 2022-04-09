import uuid

from pymongo import MongoClient

work_in_progress = "Work in progress"
pending_validation = "Pending validation"
complete = "Complete"


class Queries:
    def __init__(self):
        self.client = MongoClient(port=27017)
        self.db = self.client.backlog_db
        self.epics_collection = self.db.epics
        self.bugs_collection = self.db.bugs
        self.tasks_collection = self.db.tasks

    def get_collection(self, collection_name):
        return getattr(self, collection_name+'_collection', Exception(f"{collection_name} doesn't exist"))

    def add_document(self, query):
        document = query['document']
        document['_id'] = str(uuid.uuid4())
        self.get_collection(query["collection_name"]).insert_one(document)
        self.epics_collection.update_one({'_id': query['epic_id']}, {'$push': {f"{query['collection_name']}": document}})

    def delete_document(self, query):
        delete_query = query['delete_query']
        collection_name = query['collection_name']
        self.get_collection(collection_name).delete_one(delete_query)

        to_pull_epics = self.epics_collection.find({f"{collection_name}.name": delete_query["name"]})
        for epic in to_pull_epics:
            check_function = lambda x: ("name" not in x) or x["name"] != delete_query["name"]
            n = [v for v in epic[collection_name] if check_function(v)]
            epic[collection_name] = n
            self.epics_collection.replace_one({'_id': epic["_id"]}, epic)

            """
            Why this doesn't work? :
            epic.update({'$pull': {f"{query['collection_name']}": {'$elemMatch': delete_query}}})
            """

    @staticmethod
    def get_self_status(epic):
        if epic["tasks"]:
            res = work_in_progress
        elif epic["bugs"]:
            res = pending_validation
        else:
            res = complete
        return res

    def get_rec_epics_status(self, epic, status):
        status.append(self.get_self_status(epic))

        for in_epic in epic["epics"]:
            status = self.get_rec_epics_status(in_epic, status)

        return status

    def get_epic_status(self, epic):
        status = self.get_rec_epics_status(epic, [])
        if work_in_progress in status:
            res = work_in_progress
        elif pending_validation in status:
            res = pending_validation
        else:
            res = complete
        return res

    def get_backlog(self):
        res = []

        cursor = self.epics_collection.find({})
        for document in cursor:
            document["status"] = self.get_epic_status(document)
            res.append(document)

        return res

    @staticmethod
    def dict_format_document(document):
        formatted_document = {
            document["name"]: {
                "Tasks": [task["name"] for task in document["tasks"]],
                "Bugs": [bug["name"] for bug in document["bugs"]],
                "Epics": [epic["name"] for epic in document["epics"]]
            }
        }

        return formatted_document

    def dict_format_documents(self):
        res = {}
        cursor = self.epics_collection.find({})
        for document in cursor:
            res.update(self.dict_format_document(document))
        return res

    def documents_format_dict(self, backlog_dict):
        documents = []
        for epic_name, epic in backlog_dict.items():
            if self.epics_collection.find_one({'name': epic_name}):
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

    def link_to_merge_documents(self, partial_document_backlog):
        for document in partial_document_backlog:
            self.link_id(document, "epics", self.epics_collection)
            self.link_id(document, "tasks", self.tasks_collection)
            self.link_id(document, "bugs", self.bugs_collection)

    @staticmethod
    def link_id(document, collection_name, collection):
        for sub in document[collection_name]:
            find_epic = collection.find_one({'name': sub['name']})
            if find_epic:
                sub["_id"] = find_epic["_id"]
            else:
                sub["_id"] = str(uuid.uuid4())

    def update_backlog(self, backlog):
        backlog = self.documents_format_dict(backlog)
        self.link_to_merge_documents(backlog)
        self.epics_collection.insert_many(backlog)

    def get_linked_bugs(self, epic, linked_bugs):
        for bug in epic["bugs"]:
            if bug not in linked_bugs:
                linked_bugs.append(bug["name"])

        for in_epic in epic["epics"]:
            linked_bugs += self.get_linked_bugs(in_epic, linked_bugs)

        return linked_bugs

    def get_epics_bugs(self):
        r = []
        cursor = self.epics_collection.find({})
        for document in cursor:
            document["bugs"] = ', '.join([bug["name"] for bug in document["bugs"]])

            linked_bugs = []
            for epic in document["epics"]:
                linked_bugs += self.get_linked_bugs(epic, linked_bugs)
            # @todo mystical bug here
            linked_bugs = list(set(linked_bugs))
            document["linked_bugs"] = ', '.join(linked_bugs)

            r.append(document)
        return r

    def get_bug_epics(self, bug):
        blocked_epics_non_higher = []
        blocked_epics_higher = []

        blocked_epics = self.epics_collection.find({'bugs.name': {'$all': [bug["name"]]}})
        for blocked_epic in blocked_epics:
            if not list(self.epics_collection.find({'epics': {'$all': [blocked_epic["name"]]}})):
                blocked_epics_higher.append(blocked_epic["name"])
            else:
                blocked_epics_non_higher.append(blocked_epic["name"])

        blocked_epics_higher = ', '.join(blocked_epics_higher)
        blocked_epics_non_higher = ', '.join(blocked_epics_non_higher)

        res = {'blocked_epics_higher': blocked_epics_higher, 'blocked_epics_non_higher': blocked_epics_non_higher}

        return res

    def get_bugs_epics(self):
        res = []
        cursor = self.bugs_collection.find({})
        for document in cursor:
            document["blocked_epics"] = self.get_bug_epics(document)
            res.append(document)
        return res

    def reinitialize_database(self):
        self.db.command("dropDatabase")

        task_A1 = {'_id': str(uuid.uuid4()), 'description': 'task A1 description', 'name': 'task A1'}
        task_A2 = {'_id': str(uuid.uuid4()), 'description': 'task A2 description', 'name': 'task A2'}
        task_B1 = {'_id': str(uuid.uuid4()), 'description': 'task B1 description', 'name': 'task B1'}
        task_B2 = {'_id': str(uuid.uuid4()), 'description': 'task B2 description', 'name': 'task B2'}

        bug_B1 = {'_id': str(uuid.uuid4()), 'description': 'bug B1 description', 'name': 'bug B1'}
        bug_E1 = {'_id': str(uuid.uuid4()), 'description': 'bug B1 description', 'name': 'bug E1'}

        epic_B = {'_id': str(uuid.uuid4()),
                  'name': 'B',
                  'description': 'Epic B description',
                  'epics': [],
                  'tasks': [task_B1, task_B2],
                  'bugs': [bug_B1]}

        epic_A = {'_id': str(uuid.uuid4()),
                  'name': 'A',
                  'description': 'Epic A description',
                  'epics': [epic_B],
                  'tasks': [task_A1, task_A2],
                  'bugs': []}

        epic_C = {'_id': str(uuid.uuid4()),
                  'name': 'C',
                  'description': 'Epic C description',
                  'epics': [],
                  'tasks': [],
                  'bugs': []}

        epic_D = {'_id': str(uuid.uuid4()),
                  'name': 'D',
                  'description': 'Epic D description',
                  'epics': [epic_C],
                  'tasks': [],
                  'bugs': []}

        epic_E = {'_id': str(uuid.uuid4()),
                  'name': 'E',
                  'description': 'Epic E description',
                  'epics': [],
                  'tasks': [],
                  'bugs': [bug_E1]}

        self.epics_collection.insert_many([epic_A, epic_B, epic_C, epic_D, epic_E])
        self.tasks_collection.insert_many([task_A1, task_A2, task_B1, task_B2])
        self.bugs_collection.insert_many([bug_B1, bug_E1])
