from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

# o ideal é herdar de AbstractBaseUser e não de models.Model.

class UsuarioManager(BaseUserManager):
    def create_user(self, email, nome, password=None, **extra_fields):
        if not email:
            raise ValueError('O email é obrigatório')
        email = self.normalize_email(email)
        user = self.model(email=email, nome=nome, **extra_fields)
        user.set_password(password) # Criptografa a senha
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, nome, password=None, **extra_fields):
        # Garante que o superusuário tenha permissões administrativas
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('tipo_usuario', 'admin') # Opcional, já que você tem tipos

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser precisa ter is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser precisa ter is_superuser=True.')

        # Reutiliza o método create_user que você já fez
        return self.create_user(email, nome, password, **extra_fields)

class Usuario(AbstractBaseUser, PermissionsMixin):
    TIPOS_USUARIO = [
        ('ong', 'ONG'),
        ('voluntario','Voluntário'),
        ('admin','Administrador'),
    ]

    nome = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    # A senha já vem embutida no AbstractBaseUser, não precisa declarar
    
    tipo_usuario = models.CharField(
        max_length=20,
        choices=TIPOS_USUARIO,
        default='voluntario'
    )
    
    # CAMPOS ESPECÍFICOS (null=True, blank=True)
    cpf = models.CharField(max_length=14, null=True, blank=True)
    cnpj = models.CharField(max_length=18, null=True, blank=True)
    endereco = models.TextField(null=True, blank=True) # campo comum
    uf = models.CharField(max_length=2)
    descricao = models.TextField(null=True, blank=True)
    
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    data_criacao = models.DateTimeField(auto_now_add=True)

    objects = UsuarioManager()

    USERNAME_FIELD = 'email' # O login será feito com email
    REQUIRED_FIELDS = ['nome']

    def __str__(self):
        return f"{self.nome} ({self.get_tipo_usuario_display()})"
    
