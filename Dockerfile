# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM jenkinsci/slave

MAINTAINER Nicolas De Loof <nicolas.deloof@gmail.com>

COPY jenkins-slave /usr/local/bin/jenkins-slave

USER root

RUN apt-get update -y

RUN apt-get install -y python \
  python-dev \
  python-openssl \
  libssl-dev \
  python-pip \
  gcc \
  libxml2-dev \
  libxslt1-dev \
  python-dev \
  libffi6 \
  libffi-dev

RUN pip install --upgrade pip cffi Scrapy pyopenssl

# install gcloud sdk
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-130.0.0-linux-x86_64.tar.gz -o /tmp/google-cloud-sdk.tar.gz \
  && tar -zxvf /tmp/google-cloud-sdk.tar.gz \
  && ls -lart && ls -lart /tmp \
  && /home/jenkins/google-cloud-sdk/install.sh -q 

# The build process should generate accounts.json with the GCP creds
ADD ./accounts.json /home/jenkins/.gcp/accounts.json

RUN CLOUDSDK_PYTHON_SITEPACKAGES=1 /home/jenkins/google-cloud-sdk/bin/gcloud auth activate-service-account "jenkins@JENKINS_SVC_ACCOUNT" --key-file /home/jenkins/.gcp/accounts.json

RUN chown -R jenkins: /home/jenkins

USER jenkins

ENTRYPOINT ["jenkins-slave"]
