FROM centos:centos7

RUN yum install -y epel-release
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
RUN yum -y update
RUN yum install -y fuse s3fs-fuse proftpd proftpd-utils proftpd-ldap openssh
RUN groupadd -g 993 nginx
RUN useradd  -u 996 -g nginx nginx
RUN mkdir -p /cluster/cloud
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN touch /etc/passwd-s3fs && chmod 600 /etc/passwd-s3fs

ADD entrypoint.sh /usr/local/sbin/entrypoint.sh
RUN chmod 700 /usr/local/sbin/entrypoint.sh

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
