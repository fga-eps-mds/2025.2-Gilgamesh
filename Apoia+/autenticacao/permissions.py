from rest_framework.permissions import BasePermission

class IsONG(BasePermission):
    """
    Permissão: apenas ONGs (tipo_usuario = 'ong')  criar/editar.
    Outros usuarios podem apenas ler (list, retrieve).
    """
    def has_permission(self, request, view):
        # Permite acesso de leitura para todos
        if request.method in ('GET', 'HEAD', 'OPTIONS'):
            return True
        
        # Para os metodos de escrita: permitir apenas ONGs
        return (
            request.user.is_authenticated and 
            hasattr(request.user, 'tipo_usuario') and
            request.user.tipo_usuario == 'ong'
        )
