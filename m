From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Tue, 16 Jun 2015 13:20:42 -0400
Message-ID: <55805AEA.3050407@tycho.nsa.gov>
References: <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <7332.1434473388@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/16/2015 12:49 PM, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
>> It looks like commit 415103f9932d45f7927f4b17e3a9a13834cdb9a1 changed
>> selinux_inode_init_security()'s handling of SECURITY_FS_USE_MNTPOINT,
>> and this change was never propagated to selinux_dentry_init_security().
>>  However, that commit also did not update
>> security/selinux/hooks.c:may_create()'s logic for computing the new file
>> label when checking CREATE permission, and therefore introduced a
>> potential inconsistency between the label used for the permission check
>> and the label assigned to the inode.
>>
>> That's why I suggested that we need a common helper for all three to
>> ensure consistency there.
> 
> I think a common helper is harder than it seems.  We need the parent dir in
> one of the cases the helper has to consider, but finding it is done in three
> different ways, depending on the caller:
> 
>  (1) dentry_init can just use ->d_parent as there's a lock held that prevents
>      it changing (I think).  This could use (2) instead, however.
> 
>  (2) file_open has to use dget_parent().
> 
>  (3) inode_init doesn't have any dentries, but rather has the object and
>      parent inodes.
> 
> If we don't mind file_open() always calling dget_parent(), then the common
> helper can take the dir inode.
> 
> Also, thinking ahead to the possibility of bringing unionmount into the kernel
> at some point: union non-dir dentries that are not yet copied up have no inode
> attached, but rather fall through to the underlying lower inode in the VFS.
> This, however, gives us nowhere to hang the inode label.  How expensive is the
> security_transition_sid() call?

Why are you talking about file_open()?  It is may_create() that has the
duplicated logic, which has the parent dir passed to it by its callers
(selinux_inode_create, selinux_inode_symlink, selinux_inode_mkdir,
selinux_mknod).  selinux_inode_init_security() also gets passed the
parent dir directly.  Only selinux_dentry_init_security() has to use
d_parent, which as you say is safe, so it can just pass the resulting
dir to the helper.

Until a process writes to the file, we just want to use the lower inode
label, right?  At the point a process writes to the file and a copy-up
is produced, we could perform a one-time computation, and then once the
upper inode is created, it should get set accordingly.  So I wouldn't
think we would need to call security_transition_sid() frequently.  If
so, we might want to do what was previously done in the userspace AVC in
libselinux, and start caching security_transition_sid() results in the
AVC itself and add an avc_transition_sid() interface (in the userspace
AVC, this is avc_compute_create()).

