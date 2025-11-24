from django.db import models

class Usuario(models.Model):
    TIPOS_USUARIO = [
        ('ong', 'ONG'),
        ('voluntario','Voluntário'),
        ('admin','Administrador'),
    ]

    nome = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    senha = models.CharField(max_length=128)
    tipo_usuario = models.CharField(
        max_length=20,
        choices=TIPOS_USUARIO,
        default='voluntario'
    )
    data_criacao = models.DateTimeField(auto_now_add=True)
    
    # Adicionado para corrigir o erro do login()
    # O Django precisa desse campo para registrar quando o usuário entrou
    last_login = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.nome} ({self.get_tipo_usuario_display()})"