From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 08:48:15 -0400
Message-ID: <5582BE0F.5030703@tycho.nsa.gov>
References: <558187EA.60805@tycho.nsa.gov> <55805AEA.3050407@tycho.nsa.gov> <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk> <16652.1434490473@warthog.procyon.org.uk> <8182.1434622539@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <8182.1434622539@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, eparis@redhat.com
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2015 06:15 AM, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
>>>> Until a process writes to the file, we just want to use the lower inode
>>>> label, right?
>>>
>>> No.
>>>
>>> There are two issues:
>>>
>>>  (1) Non-fd accesses to an overlayfs file use the security label on the
>>>      overlay inode, not the lower inode, even before copy up because they
>>>      go through the inode ops of the overlayfs file first.
>>>
>>>  (2) I'm told that we want the ability to have a different label on the
>>>      upper file to that on the lower file.  This is trivial in overlayfs
>>>      since you always have an overlay inode off which to hang the security
>>>      label, but tricky with unionmount since you may only have a dentry.
>>
>> I recall that being controversial.  I agree that if a process attempts
>> to write to the file and a copy-up is triggered, then we want to be able
>> to label the copy of the file differently.  But until that happens, why
>> wouldn't we simply treat the file as having the lower file label for
>> access control purposes on read operations?
> 
> Actually, for overlayfs, I've made it such that the label off of the overlay
> inode is used for the open file.  This label gets determined when the overlay
> inode is set up and so is cached for the lifetime of the inode struct.  Like
> this in the patch I posted:
> 
> +	if (inode) {
> +		isec = inode->i_security;
> +		fsec->union_isid = isec->sid;
> +	} ...
> 
> where 'inode' is the overlay inode.  The subsequent bits:
> 
> +	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
> +		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> +		fsec->union_isid = sbsec->mntpoint_sid;
> +	} else {
> +		dir = dget_parent(union_path->dentry);
> +		dsec = dir->d_inode->i_security;
> +
> +		rc = security_transition_sid(
> +			tsec->sid, dsec->sid,
> +			inode_mode_to_security_class(file_inode(file)->i_mode),
> +			&union_path->dentry->d_name,
> +			&fsec->union_isid);
> +		dput(dir);
> +		if (rc) {
> +			printk(KERN_WARNING "%s:  "
> +			       "security_transition_sid failed, rc=%d (name=%pD)\n",
> +			       __func__, -rc, file);
> +			return rc;
> +		}
> +	}
> 
> are for future unionmount support where there isn't an inode in the union
> layer but only an inode in a lower layer.
> 
> In patch 7/7, if fsec->union_isid is non-zero in file_has_perm() then that is
> used directly with avc_has_perm() in preference to calling inode_has_perm() on
> the overlay or lower inodes.
> 
> Btw, is it correct that file operations must follow the label currently on the
> inode rather than caching it in file_security_struct?

Yes.  The inode label is cached (in the fsec->isid field) at open time
by selinux_file_open() so that selinux_file_permission() can skip
rechecking access if there has been no change to the opening task SID
(cached in fsec->sid), the inode SID (cached in fsec->isid), or the
policy (policy sequence number cached in fsec->pseqno).  The cached
inode SID is never used for permission checking however.

>>>  (2) I'm told that we want the ability to have a different label on the
>>>      upper file to that on the lower file.  This is trivial in overlayfs
>>>      since you always have an overlay inode off which to hang the security
>>>      label, but tricky with unionmount since you may only have a dentry.
>>
>> I recall that being controversial.  I agree that if a process attempts
>> to write to the file and a copy-up is triggered, then we want to be able
>> to label the copy of the file differently.  But until that happens, why
>> wouldn't we simply treat the file as having the lower file label for
>> access control purposes on read operations?
> 
> I'm hoping Eric Paris might address this.  As I understand it, we don't want
> to give the container access to the lower layer labels, but would rather
> consistently use the overlay labels.

I've seen issues with that approach for e.g. ecryptfs in the past, which
similarly has a notion of layers or stacking.  There are currently two
different ways of handling ecryptfs:

1. Assign the ecryptfs inodes a fixed label via genfscon in policy or
context= mount, with no connection to the underlying inode labels.
Potential advantage:  Policy could potentially distinguish access to the
plaintext vs encrypted inodes as they will have different labels (except
that, in practice, I don't believe this is true because ecryptfs calls
vfs helpers that trigger the permission checks on the lower inodes with
the current process' context, so this potential advantage is not being
realized today).  Disadvantage:  We lose per-file granularity on the
ecryptfs inodes, so policy cannot distinguish one file from another.
And we can't tell from policy alone how a given file is being protected,
as the file can be effectively accessed under two labels.

2. Have encryptfs pass through the underlying inode labels (i.e. use
fs_use_xattr for ecryptfs in policy).  Advantage:  We retain per-file
granularity and access control to both representations of the file
content is consistent.  Disadvantage:  No possibility of distinguishing
access to the encrypted vs plaintext versions of the file in policy,
even if we fixed ecryptfs internals to avoid the permission checks when
it internally accesses the lower files.

Almost want to be able to compute a transition label for the ecryptfs
inodes from the lower inode label so that it can be derived from but
potentially different from the lower inode label.  That way policy could
maintain per-file distinctions within an ecryptfs mount and distinguish
between access to the encrypted vs plaintext representations.

Let's make sure that we provide suitable flexibility for overlayfs and
don't lock ourselves into the same problems as with ecryptfs.
