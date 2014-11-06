From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 6/7] SELinux: The copy-up operation must have read permission
 on the lower file
Date: Thu, 06 Nov 2014 08:39:00 -0500
Message-ID: <545B79F4.7030606@tycho.nsa.gov>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154318.2555.7052.stgit@warthog.procyon.org.uk> <545A53A9.4060009@tycho.nsa.gov> <545A6464.5070702@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:57983 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaKFNm3 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 6 Nov 2014 08:42:29 -0500
In-Reply-To: <545A6464.5070702@tycho.nsa.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/05/2014 12:54 PM, Stephen Smalley wrote:
> On 11/05/2014 11:43 AM, Stephen Smalley wrote:
>> On 11/05/2014 10:43 AM, David Howells wrote:
>>> The copy-up operation must have read permission on the lower file for the task
>>> that caused the copy-up.  This helps prevent overlayfs from being used to
>>> access something it shouldn't.
>>>
>>> Signed-off-by: David Howells <dhowells@redhat.com>
>>> ---
>>>
>>>  security/selinux/hooks.c |    3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>> index f43f07fdc028..57f9c641779f 100644
>>> --- a/security/selinux/hooks.c
>>> +++ b/security/selinux/hooks.c
>>> @@ -3144,7 +3144,8 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
>>>  
>>>  static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
>>>  {
>>> -	return 0;
>>> +	const struct cred *cred = current_cred();
>>> +	return dentry_has_perm(cred, src, FILE__OPEN | FILE__READ);
>>>  }
>>
>> Won't this get checked anyway when overlayfs calls vfs helpers to open
>> the source and those vfs helpers call the security hooks and apply the
>> usual checks?
>>
>> Or, if not, where do you check permissions for the destination?
> 
> BTW, a quick look at overlayfs suggests further problems with regard to
> permission checking, e.g. ovl_copy_up_one() does:
>         /*
>          * CAP_SYS_ADMIN for copying up extended attributes
>          * CAP_DAC_OVERRIDE for create
>          * CAP_FOWNER for chmod, timestamp update
>          * CAP_FSETID for chmod
>          * CAP_CHOWN for chown
>          * CAP_MKNOD for mknod
>          */
>         cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
>         cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
>         cap_raise(override_cred->cap_effective, CAP_FOWNER);
>         cap_raise(override_cred->cap_effective, CAP_FSETID);
>         cap_raise(override_cred->cap_effective, CAP_CHOWN);
>         cap_raise(override_cred->cap_effective, CAP_MKNOD);
>         old_cred = override_creds(override_cred);
> 
> This means that it expects to trigger those capability checks as part of
> its subsequent actions.  Raising those capabilities temporarily in its
> credentials will pass the capability module checks but won't address the
> corresponding SELinux checks (both capability and file-based), so you'll
> end up triggering an entire set of checks against the current process'
> credentials.  This same pattern is repeated elsewhere in overlayfs.

So I guess the question is what, if any, permission checks performed by
the vfs helpers are appropriate and desired when called by overlayfs,
and which ones should be always-allowed/skipped.  Normally in this kind
of situation we'd either switch to a special credential set up to allow
the desired set of permissions or we'd use vfs helpers that skip the
usual permission checks.  For the former, we not only need to change
cap_effective but also the SELinux context/SID in order to both allow
the desired capabilities and to allow the desired file accesses without
needing to directly allow them to the current process' context/SID.  At
which point you would need to replicate in overlayfs whichever checks
should be performed on the original credentials.

