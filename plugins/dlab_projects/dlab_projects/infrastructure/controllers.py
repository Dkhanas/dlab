from dlab_core.domain.entities import STATUS_BAD_REQUEST, STATUS_PROCESSED
from dlab_core.infrastructure.controllers import BaseAPIController
from dlab_core.infrastructure.schema_validator import validate_schema
from dlab_projects.infrastructure.schemas import CREATE_PROJECT_SCHEMA

START = 'start'
STOP = 'stop'


class APIProjectsController(BaseAPIController):
    allowed_actions = [START, STOP]

    @classmethod
    def create_project(cls, data):
        is_valid = validate_schema(data, CREATE_PROJECT_SCHEMA)
        if is_valid:
            return {'code': is_valid}, STATUS_PROCESSED

        return {"code": is_valid, "message": "string"}, STATUS_BAD_REQUEST

    @classmethod
    def get_project(cls, name):
        return {"status": "running", "error_message": "string"}

    @classmethod
    def update_project(cls, name, **kwargs):
        action = kwargs.get('action')
        if action not in cls.allowed_actions:
            return {"code": 0, "message": "string"}, STATUS_BAD_REQUEST

        # TODO: handle not found
        # if not found:
        #     return {"code": 0, "message": "string"}, 404

        status = cls.do_action(action)
        return {'status': status}, STATUS_PROCESSED

    @classmethod
    def delete_project(cls, name):
        # TODO: handle not found
        # if not found:
        #     return {"code": 0, "message": "string"}, 404
        return {}, STATUS_PROCESSED

    @classmethod
    def do_action(cls, action):
        status = 1
        if action == START:
            pass
        if action == STOP:
            pass
        return status
