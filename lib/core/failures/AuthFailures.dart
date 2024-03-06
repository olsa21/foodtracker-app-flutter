abstract class AuthFailure {}

class ServerFailure extends AuthFailure{}
class EmailAlreadyInUseFailure extends AuthFailure{}
class DisabledUserFailure extends AuthFailure{}
class WrongPasswordFailure extends AuthFailure{}
class UserNotFoundFailure extends AuthFailure{}
class PasswortResetedMessageFailure extends AuthFailure{}