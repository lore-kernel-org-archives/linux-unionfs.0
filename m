From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 0/5] Security: Provide unioned file support
Date: Wed, 30 Sep 2015 10:41:01 -0400
Message-ID: <560BF47D.5020506@tycho.nsa.gov>
References: <20150928200018.8141.2982.stgit@warthog.procyon.org.uk>
 <560AFCA6.3020001@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:54223 "EHLO
	emvm-gh1-uea09.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbI3Olr (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 30 Sep 2015 10:41:47 -0400
In-Reply-To: <560AFCA6.3020001@tycho.nsa.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: linux-fsdevel@vger.kernel.org, mjg59@srcf.ucam.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, eparis@redhat.com, Daniel J Walsh <dwalsh@redhat.com>

On 09/29/2015 05:03 PM, Stephen Smalley wrote:
> On 09/28/2015 04:00 PM, David Howells wrote:
>>
>> The attached patches provide security support for unioned files where the
>> security involves an object-label-based LSM (such as SELinux) rather
>> than a
>> path-based LSM.
>>
>> [Note that a number of the bits that were in the original patch set
>> are now
>> upstream and I've rebased on Casey's changes to the security hook system]
>>
>> The patches can be broken down into two sets:
>>
>>   (1) A patch to add LSM hooks to handle copy up of a file, including
>> label
>>       determination/setting and xattr filtration and a patch to have
>>       overlayfs call the hooks during the copy-up procedure.
>>
>>   (2) My SELinux implementations of these hooks.  I do three things:
>>
>>       (a) Don't copy up SELinux xattrs from the lower file to the upper
>>            file.  It is assumed that the upper file will be created
>> with the
>>            attrs we want or the selinux_inode_copy_up() hook will set it
>>            appropriately.
>>
>>      The reason there are two separate hooks here is that
>>      selinux_inode_copy_up_xattr() might not ever be called if there
>>      aren't actually any xattrs on the lower inode.
>>
>>       (b) I try to derive a label to be used by file operations by, in
>> order
>>            of preference: using the label on the union inode if there
>> is one
>>            (the normal overlayfs case); using the override label set
>> on the
>>            superblock, if provided; or trying to derive a new label by
>> sid
>>            transition operation.
>>
>>       (c) Using the label obtained in (b) in file_has_perm() rather than
>>            using the label on the lower inode.
>>
>> Now the steps I have outlined in (b) and (c) seem to be at odds with what
>> Dan Walsh and Stephen Smalley want - but I'm not sure I follow what that
>> is, let alone how to do it:
>>
>>     Wanted to bring back the original proposal.  Stephen suggested that
>>     we could change back to the MLS way of handling labels.
>>
>>     In MCS we base the MCS label of content created by a process on the
>>     containing directory.  Which means that if a process running as
>>     s0:c1,c2 creates content in a directory labeled s0, it will get
>>     created as s0.
>>
>>     In MLS if a process running as s0:c1,c2 creates content in a
>>     directory it labels it s0:c1,c2.  No matter what the label of the
>>     directory is.  (Well actually if the directory is not ranged the
>>     process will not be able to create the content.)
>>
>>     We changed the default for MCS in Rawhide for about a week, when I
>>     realized this was a huge problem for containers sharing content.
>>     Currently if you want two containers to share the same volume
>>     mount, we label the content as svirt_sandbox_file_t:s0 If one
>>     process running as s0:c1,c2 creates content it gets created as s0,
>>     if the second container process is running as s0:c3,c4, it can
>>     still read/write the content.  If we changed the default the object
>>     would get created as s0:c1,c2 and process runing as s0:c3,c4 would
>>     be blocked.
>>
>>     So I had it reverted back to the standard MCS Mode.
>>
>>     If we could get the default to be MLS mode on COW file systems and
>>     MCS on Volumes, we would get the best of both worlds.
>
> How are you testing this?
> I tried as follows:
>
> # Make sure we have a policy that is using xattrs to label overlay inodes.
> $ seinfo --fs_use | grep overlay
>     fs_use_xattr overlay system_u:object_r:fs_t:s0
>
> # Define some types for the different directories involved.
> $ cat overlay.te
> policy_module(overlay, 1.0)
>
> type lower_t;
> files_type(lower_t)
>
> type upper_t;
> files_type(upper_t)
>
> type work_t;
> files_type(work_t)
>
> type merged_t;
> files_type(merged_t)
>
> $ make -f /usr/share/selinux/devel/Makefile overlay.pp
> $ sudo semodule -i overlay.pp
>
> # Create and label the different directories involved.
> $ mkdir lower upper work merged
> $ chcon -t lower_t lower
> $ chcon -t upper_t upper
> $ chcon -t work_t work
> $ chcon -t merged_t merged
>
> # Populate lower
> $ echo "lower" > lower/a
> $ mkdir lower/b
>
> # Mount overlay
> $ sudo mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work
> merged
>
> # Look at the merged dir and labels.
> $ ls -Z merged
> unconfined_u:object_r:lower_t:s0 a
> unconfined_u:object_r:lower_t:s0 b
>
> # Write/create some files/directories.
> $ echo "foo" >> merged/a
> $ mkdir merged/b/c
> $ mkdir merged/c
>
> # Look again.
> $ ls -ZR merged
> merged:
> unconfined_u:object_r:lower_t:s0 a  unconfined_u:object_r:upper_t:s0 c
> unconfined_u:object_r:lower_t:s0 b
>
> merged/b:
> unconfined_u:object_r:work_t:s0 c
>
> merged/b/c:
>
> $ ls -ZR upper
> upper:
>   unconfined_u:object_r:work_t:s0 a  unconfined_u:object_r:upper_t:s0 c
>   unconfined_u:object_r:work_t:s0 b
>
> upper/b:
> unconfined_u:object_r:work_t:s0 c
>
> upper/b/c:
>
> Note that the copied-up file (a) and directory (b) are labeled lower_t
> in the overlay, but work_t in the upper dir, and neither of those is
> really what we want IIUC.
>
> And that's just the labeling question.  Then there is the question of
> what permission checks were applied during those copy-up operations and
> whether the current process ends up needing write permissions to them all.

Also, the labels on the overlay inodes change if you umount and then 
mount it again:

$ sudo umount merged
$ sudo mount -t overlay overlay -o 
lowerdir=lower,upperdir=upper,workdir=work merged
$ ls -ZR merged
merged:
  unconfined_u:object_r:work_t:s0 a  unconfined_u:object_r:upper_t:s0 c
  unconfined_u:object_r:work_t:s0 b

merged/b:
unconfined_u:object_r:work_t:s0 c

merged/b/c:

merged/c:

It seems to me that either the copied-up files should be labeled upper_t 
(i.e. from upperdir) or merged_t (i.e. from the overlay).  But certainly 
not lower_t (which is supposed to be read-only to the container) or 
work_t (which isn't supposed to be directly accessed by processes in the 
first place).
