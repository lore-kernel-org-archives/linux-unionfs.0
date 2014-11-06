From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 06 Nov 2014 08:13:02 -0500
Message-ID: <545B73DE.6090101@tycho.nsa.gov>
References: <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <11463.1415275413@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <11463.1415275413@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 11/06/2014 07:03 AM, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
>> How do we know that this union_isid will bear any relation to the actual
>> SID assigned to the union inode when it is created?
> 
> Note that overlayfs *will* have a union inode at this point, but will just not
> use it for non-directories - so in this case we just use the first branch of
> the if-statement:
> 
> 	+	if (inode) {
> 	+		isec = inode->i_security;
> 	+		fsec->union_isid = isec->sid;
> 	+	} ...
> 
> in which case, I think that we can be fairly sure that we will have the right
> label.

Yes, that case is fine.

> The other two cases are in case there isn't an inode - unionmount, for
> example.  The second case is used (if I understand the flag correctly) if the
> superblock imposes a single label over all its inodes - so no problem there:
> 
> 	+	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
> 	+		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> 	+		fsec->union_isid = sbsec->mntpoint_sid;
> 	+	} ...

Likewise.

> The third case is the tricky one because we have to try and derive a label.
> I've copied the code from the inode creation - so unless the policy changes or
> the parent directory inode changes, I would've thought we'd be okay.

Only if the filesystem ultimately calls security_inode_init_security()
on the new inode.  Originally we had the vfs call post_create() hooks to
do this, but that was racy and unsafe, so we had to take the
initialization down into the filesystem code and replicate it in each
filesystem that supports labeling.  So whether or not that label will in
fact be assigned to the inode depends on the filesystem in question.
Currently called by btrfs, ext[234], f2fs, gfs2, hfsplus, jffs2, jfs,
ocsfs2, xfs.  Not sure what filesystems you have in mind for the
unionmount scenario.

>> If the union inode does not already exist, when/where does it get created?
> 
> For overlayfs, union inodes *have* to exist because it's a filesystem and are
> created at the normal times and in the normal way.  They need to exist because
> otherwise the dentry at that point in the overlay fs would be negative and the
> VFS wouldn't call into the filesystem.
> 
>> Also, would be good to create a common helper for use here, by
>> selinux_dentry_init_security(), selinux_inode_init_security(), and
>> may_create().  Already some seeming potential for inconsistencies there.
> 
> Okay, I'll have a look at that.

Thanks.

>>> +	return inode_has_perm(cred, file_inode(file), fsec->union_isid, &ad);
>>
>> Something is seriously wrong here; you are passing fsec->union_isid
>> where we expect a permissions bitmap / access vector.
> 
> Good point.  I need to call avc_has_perm() directly.  I don't necessarily have
> an sclass, though, hmmm...

Looks like you can get it from the other inode, as long as they are
guaranteed to have the same class (which in turn will be true as long as
they have the same file type value from the mode).

