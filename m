From: nicolas@belouin.fr
Subject: Re: [kernel-hardening] [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 21:04:48 +0200
Message-ID: <201710211904.v9LJ4o1X046943__42256.4563145444$1508612908$gmane$org@smtp5.infomaniak.ch>
References: <20171021134558.21195-1-nicolas@belouin.fr> <d3e1c911-138d-082a-b941-651217d0faf8@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:36744 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932159AbdJUTIL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 21 Oct 2017 15:08:11 -0400
In-Reply-To: <d3e1c911-138d-082a-b941-651217d0faf8@schaufler-ca.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James.Morris@smtp5.inf

<james.l.morris@oracle.com>,linux-ext4@vger.kernel.org,linux-kernel@vger.kernel.org,linux-f2fs-devel@lists.sourceforge.net,linux-fsdevel@vger.kernel.org,linux-mtd@lists.infradead.org,jfs-discussion@lists.sourceforge.net,ocfs2-devel@oss.oracle.com,linux-unionfs@vger.kernel.org,reiserfs-devel@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@tycho.nsa.gov,linux-api@vger.kernel.org,kernel-hardening@lists.openwall.com
From: Nicolas Belouin <nicolas@belouin.fr>
Message-ID: <E5A1BDA4-A309-4118-84D5-72780F619EBA@belouin.fr>



On October 21, 2017 7:25:21 PM GMT+02:00, Casey Schaufler <casey@schaufler-ca.com> wrote:
>On 10/21/2017 6:45 AM, Nicolas Belouin wrote:
>> with CAP_SYS_ADMIN being bloated, the usefulness of using it to
>> flag a process to be entrusted for e.g reading and writing trusted
>> xattr is near zero.
>> CAP_TRUSTED aims to provide userland with a way to mark a process as
>> entrusted to do specific (not specially admin-centered) actions. It
>> would for example allow a process to red/write the trusted xattrs.
>
>Please explain how this is different from CAP_MAC_ADMIN in
>any existing use case. If it is significantly different, how
>would the two interact?

>From my point of view, CAP_MAC_ADMIN allows one to read/write security xattrs, those are meant to describe security policies. As far as I know of, trusted xattrs are intended for a privileged process to read or write arbitrary data. I don't have any real world example in mind that use trusted xattrs, but I'll try to find one.

>
>> Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
>> ---
>>  include/uapi/linux/capability.h     | 6 +++++-
>>  security/selinux/include/classmap.h | 5 +++--
>>  2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/capability.h
>b/include/uapi/linux/capability.h
>> index ce230aa6d928..27e457b93c84 100644
>> --- a/include/uapi/linux/capability.h
>> +++ b/include/uapi/linux/capability.h
>> @@ -369,7 +369,11 @@ struct vfs_ns_cap_data {
>>  
>>  #define CAP_SYS_MOUNT		38
>>  
>> -#define CAP_LAST_CAP         CAP_SYS_MOUNT
>> +/* Allow read/write trusted xattr */
>> +
>> +#define CAP_TRUSTED		39
>> +
>> +#define CAP_LAST_CAP         CAP_TRUSTED
>>  
>>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>>  
>> diff --git a/security/selinux/include/classmap.h
>b/security/selinux/include/classmap.h
>> index a873dce97fd5..f5dc8e109f5a 100644
>> --- a/security/selinux/include/classmap.h
>> +++ b/security/selinux/include/classmap.h
>> @@ -24,9 +24,10 @@
>>  	    "audit_control", "setfcap"
>>  
>>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
>> -		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
>> +		"wake_alarm", "block_suspend", "audit_read", "sys_mount", \
>> +		"trusted"
>>  
>> -#if CAP_LAST_CAP > CAP_SYS_MOUNT
>> +#if CAP_LAST_CAP > CAP_TRUSTED
>>  #error New capability defined, please update COMMON_CAP2_PERMS.
>>  #endif
>>  

Nicolas
