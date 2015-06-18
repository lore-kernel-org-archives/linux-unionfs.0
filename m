From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 7/8] SELinux: Create a common helper to determine an inode
 label
Date: Thu, 18 Jun 2015 11:20:46 -0400
Message-ID: <5582E1CE.2010301@tycho.nsa.gov>
References: <5582DC0F.7090800@tycho.nsa.gov> <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133310.12722.16624.stgit@warthog.procyon.org.uk> <17513.1434640431@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17513.1434640431@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2015 11:13 AM, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
>>> +	if ((sbsec->flags & SE_SBINITIALIZED) &&
>>> +		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
>>> +		*_new_isid = sbsec->mntpoint_sid;
>>> +	} else if (tsec->create_sid) {
>>
>> This doesn't quite match the logic in inode_init_security today, see its
>> checking of SBLABEL_MNT.
> 
> Fair point.  What does SBLABEL_MNT mean precisely?  It seems to indicate one
> of an odd mix of behaviours.  I presume it means that we *have* to calculate a
> label and can't get one from the underlying fs if it is not set.

It means the filesystem supports per-file labeling and you can use
setxattr(..."security.selinux") and setfscreatecon() for files on it.
You can see whether it is set on a filesystem by looking for the
seclabel option in cat /proc/mounts.  If it is not set, then we ignore
tsec->create_sid.  It is arguable as to whether it is correct to always
call security_transition_sid() there either, but that's another topic.

> 
> Also, in:
> 
> 	sbsec->flags |= SE_SBINITIALIZED;
> 	if (selinux_is_sblabel_mnt(sb))
> 		sbsec->flags |= SBLABEL_MNT;
> 
> should SE_SBINITIALIZED be set after SBLABEL_MNT?  And should there be a
> memory barrier in here somewhere before the setting of SE_SBINITIALIZED?

I believe that's all under sbsec->lock held by the caller, but that code
has changed a lot and been refactored significantly by others.
