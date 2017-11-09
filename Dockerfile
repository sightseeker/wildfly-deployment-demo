# ベースとなるイメージ
FROM jboss/wildfly:11.0.0.Final

# 環境変数
ENV JBOSS_HOME=/opt/jboss/wildfly

USER root
RUN yum install -y net-tools
# WildFly を設定する CLIスクリプトを配置
COPY assets/setup-wildfly.cli /tmp
# MySQL JConnector をダウンロード
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar /tmp
RUN chown jboss:jboss /tmp/setup-wildfly.cli /tmp/mysql-connector-java-5.1.34.jar


# ------------------------------
# WildFlyの設定
# ------------------------------
USER jboss
# CLI スクリプトを実行して、JConnector や コネクションプール の設定などをする
RUN /opt/jboss/wildfly/bin/jboss-cli.sh --file=/tmp/setup-wildfly.cli
# WildFly の管理ユーザを作成
RUN /opt/jboss/wildfly/bin/add-user.sh admin password --silent
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-full.xml"]
