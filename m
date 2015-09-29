From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 0/5] Security: Provide unioned file support
Date: Tue, 29 Sep 2015 17:03:34 -0400
Message-ID: <560AFCA6.3020001@tycho.nsa.gov>
References: <20150928200018.8141.2982.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150928200018.8141.2982.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 09/28/2015 04:00 PM, David Howells wrote:
>
> The attached patches provide security support for unioned files where the
> security involves an object-label-based LSM (such as SELinux) rather than a
> path-based LSM.
>
> [Note that a number of the bits that were in the original patch set are now
> upstream and I've rebased on Casey's changes to the security hook system]
>
> The patches can be broken down into two sets:
>
>   (1) A patch to add LSM hooks to handle copy up of a file, including label
>       determination/setting and xattr filtration and a patch to have
>       overlayfs call the hooks during the copy-up procedure.
>
>   (2) My SELinux implementations of these hooks.  I do three things:
>
>       (a) Don't copy up SELinux xattrs from the lower file to the upper
>       	 file.  It is assumed that the upper file will be created with the
>       	 attrs we want or the selinux_inode_copy_up() hook will set it
>       	 appropriately.
>
> 	 The reason there are two separate hooks here is that
> 	 selinux_inode_copy_up_xattr() might not ever be called if there
> 	 aren't actually any xattrs on the lower inode.
>
>       (b) I try to derive a label to be used by file operations by, in order
>       	 of preference: using the label on the union inode if there is one
>       	 (the normal overlayfs case); using the override label set on the
>       	 superblock, if provided; or trying to derive a new label by sid
>       	 transition operation.
>
>       (c) Using the label obtained in (b) in file_has_perm() rather than
>       	 using the label on the lower inode.
>
> Now the steps I have outlined in (b) and (c) seem to be at odds with what
> Dan Walsh and Stephen Smalley want - but I'm not sure I follow what that
> is, let alone how to do it:
>
> 	Wanted to bring back the original proposal.  Stephen suggested that
> 	we could change back to the MLS way of handling labels.
>
> 	In MCS we base the MCS label of content created by a process on the
> 	containing directory.  Which means that if a process running as
> 	s0:c1,c2 creates content in a directory labeled s0, it will get
> 	created as s0.
>
> 	In MLS if a process running as s0:c1,c2 creates content in a
> 	directory it labels it s0:c1,c2.  No matter what the label of the
> 	directory is.  (Well actually if the directory is not ranged the
> 	process will not be able to create the content.)
>
> 	We changed the default for MCS in Rawhide for about a week, when I
> 	realized this was a huge problem for containers sharing content.
> 	Currently if you want two containers to share the same volume
> 	mount, we label the content as svirt_sandbox_file_t:s0 If one
> 	process running as s0:c1,c2 creates content it gets created as s0,
> 	if the second container process is running as s0:c3,c4, it can
> 	still read/write the content.  If we changed the default the object
> 	would get created as s0:c1,c2 and process runing as s0:c3,c4 would
> 	be blocked.
>
> 	So I had it reverted back to the standard MCS Mode.
>
> 	If we could get the default to be MLS mode on COW file systems and
> 	MCS on Volumes, we would get the best of both worlds.

How are you testing this?
I tried as follows:

# Make sure we have a policy that is using xattrs to label overlay inodes.
$ seinfo --fs_use | grep overlay
    fs_use_xattr overlay system_u:object_r:fs_t:s0

# Define some types for the different directories involved.
$ cat overlay.te
policy_module(overlay, 1.0)

type lower_t;
files_type(lower_t)

type upper_t;
files_type(upper_t)

type work_t;
files_type(work_t)

type merged_t;
files_type(merged_t)

$ make -f /usr/share/selinux/devel/Makefile overlay.pp
$ sudo semodule -i overlay.pp

# Create and label the different directories involved.
$ mkdir lower upper work merged
$ chcon -t lower_t lower
$ chcon -t upper_t upper
$ chcon -t work_t work
$ chcon -t merged_t merged

# Populate lower
$ echo "lower" > lower/a
$ mkdir lower/b

# Mount overlay
$ sudo mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work merged

# Look at the merged dir and labels.
$ ls -Z merged
unconfined_u:object_r:lower_t:s0 a
unconfined_u:object_r:lower_t:s0 b

# Write/create some files/directories.
$ echo "foo" >> merged/a
$ mkdir merged/b/c
$ mkdir merged/c

# Look again.
$ ls -ZR merged
merged:
unconfined_u:object_r:lower_t:s0 a  unconfined_u:object_r:upper_t:s0 c
unconfined_u:object_r:lower_t:s0 b

merged/b:
unconfined_u:object_r:work_t:s0 c

merged/b/c:

$ ls -ZR upper
upper:
  unconfined_u:object_r:work_t:s0 a  unconfined_u:object_r:upper_t:s0 c
  unconfined_u:object_r:work_t:s0 b

upper/b:
unconfined_u:object_r:work_t:s0 c

upper/b/c:

Note that the copied-up file (a) and directory (b) are labeled lower_t 
in the overlay, but work_t in the upper dir, and neither of those is 
really what we want IIUC.

And that's just the labeling question.  Then there is the question of 
what permission checks were applied during those copy-up operations and 
whether the current process ends up needing write permissions to them all.

>
>
> The patches can be found here on top of some fix patches:
>
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=overlayfs
>
> David
> ---
> David Howells (5):
>        Security: Provide copy-up security hooks for unioned files
>        Overlayfs: Use copy-up security hooks
>        SELinux: Stub in copy-up handling
>        SELinux: Handle opening of a unioned file
>        SELinux: Check against union label for file operations
>
>
>   fs/overlayfs/copy_up.c            |   12 ++++
>   include/linux/lsm_hooks.h         |   23 ++++++++
>   include/linux/security.h          |   14 +++++
>   security/security.c               |   17 ++++++
>   security/selinux/hooks.c          |  101 ++++++++++++++++++++++++++++++++++++-
>   security/selinux/include/objsec.h |    1
>   6 files changed, 166 insertions(+), 2 deletions(-)
>
> _______________________________________________
> Selinux mailing list
> Selinux@tycho.nsa.gov
> To unsubscribe, send email to Selinux-leave@tycho.nsa.gov.
> To get help, send an email containing "help" to Selinux-request@tycho.nsa.gov.
>
