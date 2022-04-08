from pymongo import MongoClient
import uuid

def create_database():
    client = MongoClient(port=27017)
    db = client.backlog_db

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



    db.epics.insert_many([epic_A, epic_B, epic_C, epic_D, epic_E])
    db.tasks.insert_many([task_A1, task_A2, task_B1, task_B2])
    db.bugs.insert_many([bug_B1, bug_E1])


if __name__ == "__main__":
    dbname = create_database()
