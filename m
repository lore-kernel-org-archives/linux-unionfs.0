From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: overlayfs access checks on underlying layers
Date: Mon, 4 Mar 2019 13:44:43 -0500
Message-ID: <ae2682f2-4a15-39e6-eb49-b9c0e72f10e4@tycho.nsa.gov>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com>
 <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com>
 <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov>
 <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <20181129134943.GA16762@redhat.com>
 <fe78aaed-5fb1-3c51-1330-39de46ae39c5@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fe78aaed-5fb1-3c51-1330-39de46ae39c5@android.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>, LSM <linux-security-module@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On 3/4/19 12:01 PM, Mark Salyzyn wrote:
> On 11/29/2018 05:49 AM, Vivek Goyal wrote:
>> So will override_creds=off solve the NFS issue also where all access will
>> happen with the creds of task now? Though it will stil require more
>> priviliges in task for other operations in overlay to succeed.
> 
> NFS problems seems to have ended the discussion, too many stakeholders? 
> too many outstanding questions?
> 
> Do we accept the limitations of the override_creds patch as is, and then 
> have the folks more familiar with the NFS scenario(s) build on it?
> 
> [TL;DR]
> 
> After looking at all this discussion, it feels like a larger audited 
> rewrite of the security model is in order and override_creds=off may be 
> a disservice (although expediently deals with Android's needs) to a 
> correct general solution. I admit I have little idea where to go from 
> here for a general solution.
> 
> As far as I see it, the model of creator && caller credentials is a 
> problem for any non-overlapping (MAC) privilege models. This patch 
> allows one to drop any creator privilege escalation, re-introducing the 
> "caller" to the lower layers.
> 
> As such I would expect a better model is to _always_ check the caller 
> credentials again in the lower layers, and only check the creator 
> credentials, some without caller credentials, for some special cases? 
> Change an && to an || for some of the checks? What are those special 
> cases? I must admit _none_ of those special cases need attention in the 
> Android usage models though making it difficult for me to do the fight 
> thing for the associated stakeholders.

As I recall, there were multiple problems with using current process' 
creds for the operations on the lower/upper/work directories:

- Some overlayfs operations on the lower/upper/work directories required 
privilege (capabilities) that the current process might lack, e.g. to 
set ownership and the like on upper or work files, to set special xattrs 
used internally by overlayfs for whiteouts or similar purposes, to act 
on files within the work dir which was inaccessible to the current 
process to prevent accessing files in an incomplete state, etc. 
Originally that was handled by temporarily elevating the effective 
capabilities around the privileged operation in the overlayfs code but 
that didn't help with the SELinux or other LSM capability checking that 
was triggered upon the capable calls.  Without some change there you'd 
have to allow all client process domains all of the relevant 
capabilities in policy, greatly increasing their privileges.

- The original logic was checking access to the lower dir/files in the 
context of the current process when performing some operation that 
modifies the file content or metadata, thereby triggering a SELinux/LSM 
write or similar check, even though the actual data or metadata 
modification occurs to the copied-up file instead and does not affect 
the lower dir/files.  That was preventing making the lower dir/file 
labels read-only to the client processes in the policy, which was 
desired for the container use case.

You'd need to solve those problems in some way.

> The lower privileged application access to the directory cache inherited 
> by other callers troubles me (not for Android, but in general) and feels 
> troublesome (flush out the directory cache? how to tag the privileges 
> associated with the current instance of the directory cache?). Some 
> operations (eg: delete a file for incoming, create mknod in upperdir) 
> are special cases requiring the checking of caller credentaisl to 
> function (not a problem for Android as the caller that deletes a file 
> just so happens to have the necessary privileges).
> 
> Also, mount namespaces (in upper, lower, etc), how will they affect this 
> all, is there a need for more attention to this as well?
> 
> -- Mark
