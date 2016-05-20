#! /bin/sh

### BEGIN INIT INFO
# Provides:             firewall
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Default-Start:        2 3 4 5
# Default-Stop:         
# Short-Description:    Script para inicializacao de regras de firewall
### END INIT INFO

#inicio regras
case $1 in
start)
##################################LIMPANDO REGRAS#######################################################
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

##################################DEFININDO POLITICAS PADROES###########################################

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

####################################DESBLOQUEANDO TRAFEGO LOOPBACK#######################################

iptables -A INPUT -i lo -j ACCEPT

##################################|HABILITANDO LOG|#######################################################

#iptables -A INPUT -j LOG

##################################DEFININDO DESBLOQUEIO##################################################

#liberar http/https de outros servidores (atualizacao de sistema e wordpress)
iptables -A INPUT -p tcp --sport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -j ACCEPT

#liberar http do proprio servidor 
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

#liberar ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#liberar dns (consultas externas em outros servers)
iptables -A INPUT -p udp --sport 53 -j ACCEPT

#liberar icmp
#iptables -A INPUT -p icmp -j ACCEPT

;;
stop)
iptables -P INPUT ACCEPT
iptables -P OUTPUT  ACCEPT
##################################LIMPANDO REGRAS#######################################################
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
esac
