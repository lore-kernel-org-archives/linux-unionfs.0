From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Mon, 15 Jun 2015 08:57:41 -0400
Message-ID: <557ECBC5.7000705@tycho.nsa.gov>
References: <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <8813.1434123054@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
List-Id: linux-unionfs@vger.kernel.org

On 06/12/2015 11:30 AM, David Howells wrote:
> Hi Stephen,
> 
> David Howells <dhowells@redhat.com> wrote:
> 
>> Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>>> Also, would be good to create a common helper for use here, by
>>> selinux_dentry_init_security(), selinux_inode_init_security(), and
>>> may_create().  Already some seeming potential for inconsistencies there.
>>
>> selinux_dentry_init_security() and selinux_inode_init_security() do
>> something different depending on SECURITY_FS_USE_MNTPOINT.  Is the dentry
>> variant wrong?  Shouldn't it be using the mountpoint label if that flag _is_
>> set?
> 
> Any answer to that?

It looks like commit 415103f9932d45f7927f4b17e3a9a13834cdb9a1 changed
selinux_inode_init_security()'s handling of SECURITY_FS_USE_MNTPOINT,
and this change was never propagated to selinux_dentry_init_security().
 However, that commit also did not update
security/selinux/hooks.c:may_create()'s logic for computing the new file
label when checking CREATE permission, and therefore introduced a
potential inconsistency between the label used for the permission check
and the label assigned to the inode.

That's why I suggested that we need a common helper for all three to
ensure consistency there.



