#!/bin/bash

major_version=
os=
host=

get_hostname ()
{
  echo "Getting the hostname of this machine..."

  host=`hostname -f 2>/dev/null`
  if [ "$host" = "" ]; then
    host=`hostname 2>/dev/null`
    if [ "$host" = "" ]; then
      host=$HOSTNAME
    fi
  fi

  if [ "$host" = "" ]; then
    echo "Unable to determine the hostname of your system!"
    echo
    echo "Please consult the documentation for your system. The files you need "
    echo "to modify to do this vary between Linux distribution and version."
    echo
    exit 1
  fi

  echo "Found hostname: ${host}"
}

curl_check ()
{
  echo "Checking for curl..."
  which curl > /dev/null

  if [ $? -gt 0 ]; then
    echo "Installing curl..."
    yum install -d0 -e0 -y curl
  else
    echo "Detected curl..."
  fi
}

unknown_os ()
{
  echo "Unfortunately, your operating system distribution and version are not supported by this script."
  echo "Please email support@packagecloud.io and we will be happy to help."
  exit 1
}

if [ -e /etc/os-release ]; then
  . /etc/os-release
  major_version=`echo ${VERSION_ID} | awk -F '.' '{ print $1 }'`
  os=${ID}

elif [ `which lsb_release 2>/dev/null` ]; then
  # get major version (e.g. '5' or '6')
  major_version=`lsb_release -r | cut -f2 | awk -F '.' '{ print $1 }'`

  # get os (e.g. 'centos', 'redhatenterpriseserver', etc)
  os=`lsb_release -i | cut -f2 | awk '{ print tolower($1) }'`

elif [ -e /etc/oracle-release ]; then
  major_version=`cut -f5 --delimiter=' ' /etc/oracle-release | awk -F '.' '{ print $1 }'`
  os='ol'

elif [ -e /etc/fedora-release ]; then
  major_version=`cut -f3 --delimiter=' ' /etc/fedora-release`
  os='fedora'

elif [ -e /etc/redhat-release ]; then
  os_hint=`cat /etc/redhat-release  | awk '{ print tolower($1) }'`
  if [ "${os_hint}" = "centos" ]; then
    major_version=`cat /etc/redhat-release | awk '{ print $3 }' | awk -F '.' '{ print $1 }'`
    os='centos'
  elif [ "${os_hint}" = "scientific" ]; then
    major_version=`cat /etc/redhat-release | awk '{ print $4 }' | awk -F '.' '{ print $1 }'`
    os='scientific'
  else
    major_version=`cat /etc/redhat-release  | awk '{ print tolower($7) }' | cut -f1 --delimiter='.'`
    os='redhatenterpriseserver'
  fi

else
  aws=`grep Amazon /etc/issue 2>&1 >/dev/null`
  if [ "$?" = "0" ]; then
    major_version='6'
    os='aws'
  else
    unknown_os
  fi
fi

if [[ ( -z "${os}" ) || ( -z "${major_version}" ) || ( "${os}" = "opensuse" ) ]]; then
  unknown_os
fi

echo "Detected ${os} version ${major_version}... "

curl_check

get_hostname

echo "Downloading repository file: https://packagecloud.io/install/repositories/haf/oss/config_file.repo?os=${os}&dist=${major_version}&name=${host}"

curl -f "https://packagecloud.io/install/repositories/haf/oss/config_file.repo?os=${os}&dist=${major_version}&name=${host}" > /etc/yum.repos.d/haf_oss.repo

if [ "$?" != "0" ]; then
  unknown_os
fi

echo "Installing pygpgme to verify GPG signatures..."
yum install -y pygpgme --disablerepo='haf_oss'
pypgpme_check=`rpm -qa | grep -qw pygpgme`
if [ "$?" != "0" ]; then
  echo
  echo "WARNING: "
  echo "The pygpgme package could not be installed. This means GPG verification is not possible for any RPM installed on your system. "
  echo "To fix this, add a repository with pygpgme. Usualy, the EPEL repository for your system will have this. "
  echo "More information: https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F"
  echo

  # set the repo_gpgcheck option to 0
  sed -i'' 's/repo_gpgcheck=1/repo_gpgcheck=0/' /etc/yum.repos.d/haf_oss.repo
fi

echo "Generating yum cache for haf_oss..."
yum -q makecache -y --disablerepo='*' --enablerepo='haf_oss'

