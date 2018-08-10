From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v4] overlayfs: override_creds=off option bypass
 creator_cred
Date: Fri, 10 Aug 2018 09:55:08 -0700
Message-ID: <04154542-d7db-7eab-34fd-337c8ad766ba@android.com>
References: <20180622171605.52989-1-salyzyn@android.com>
 <20180625123800.GA10739@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625123800.GA10739@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Sorry for taking so long to respond, spent a month on holiday and have 
just caught back up to my task list ;-}

Thanks for your comments!

Summary:

1) Add more caveats as discussed here to documentation and possibly to 
Kconfig
2) This option provides the ability to mount a resource, that the 
mounter does not have privileges for, but a third party does.
3) Ask if we should check CAP_SYS_PACCT (b/c it references smb mounts, 
making the caller actually read documentation, however there may be a 
better candidate capability) of the mounter to be able to mount with 
this new option? MAC (sepolicy) checks added (sez that without knowing 
the impact on the code or policy encoding)?

There is some repetition of the points below ...

On 06/25/2018 05:38 AM, Vivek Goyal wrote:
> On Fri, Jun 22, 2018 at 10:16:02AM -0700, Mark Salyzyn wrote:
>> By default, all access to the upper, lower and work directories is the
>> recorded mounter's MAC and DAC credentials.  The incoming accesses are
>> checked against the caller's credentials.
>>
>> If the principles of least privilege are applied, the mounter's
>> credentials might not overlap the credentials of the caller's when
>> accessing the overlayfs filesystem.  For example, a file that a lower
>> DAC privileged caller can execute, is MAC denied to the generally
>> higher DAC privileged mounter, to prevent an attack vector.
> Hi Mark,
>
> I am wondering, what does it mean that caller is privileged enough to do
> mknod and set trusted xattrs but it does not have privileges to do mount.
init has sepolicy privileges to mount, caller accessing the file does 
not have sepolicy privileges to mount. init does not have privileges to 
make devices nodes (hypothetical), ueventd does.
> If caller is privileged, then it can do mount as well?

If we granted it to, but we do not. Only adb (userdebug builds), init 
and vold can do mounts.
> Or, what does it mean that a mounter can mount (hence providing access
> to certain resources on the system) but then mounter itself does not
> have access to those resources. If mounter does not have access to
> those resources, then mounter should not be allowed to do the mount
> and provide access to those resources to a third person?
True pedantically, but that is _exactly_ why we need this option given 
that privileges are not nested and do not overlap, and we want to allow 
this. The option is basically _permission_ to mount, and provide access 
to the resources to a third person with a different privilege profile.

Do you propose we create a new MAC/DAC surrounding being able to apply 
this mount option? Should we check a capability? (eg: CAP_SYS_PACCT 
which permits mount/umount on new smb connections, or CAP_SYS_ADMIN, but 
that could be dangerous privilege in the override_creds=on case ...
> For example, SELinux context= mount option. So here mounter can create
> a mount point with label context=foo, and provide access to underlying
> files/dirs to the caller. Now if mounter itself does not have access
> to resources on which mount is being created, then how it is supposed
> to provide that access to unprivileged caller?
mount has privilege on the resource (because it has system_filesystem 
label at the top), but a file underneath might have a different label?
> Going by your analogy of init being attacked, then one simply have to
> attack init and trick it to mount something with context=foo and gain
> access to resources mounter itself could not access.

All mounters represent an attack surface, so we _limit_ their 
capabilities to absolute minimum needed, and thus why we have 
non-overlapping access credentials between the mounter, and those that 
use the resources underneath the mount. And overlayfs is unique as a big 
gaping security hole if we all anyone other than critical system 
components to mount. More reasons for non-overlapping MAC.

> While my example is fully valid for disks, it is not fully valid for
> overlay as we do two level of checks for many operations. So while overlay
> inode level check will pass due to context=, underlying file system check
> will fail. But this two level of checks does not happen outside overlay.
> SELinux is not aware of stacking of filesystems so it could just do check
> on overlay inode. So if a caller opens a file and passes file descriptor
> to another process who is not supposed to access file, with context= mounts,
> I think SELinux will allow access as second process is allowed to access
> overlay inode.
Alas, in our specific Android case, where we are allowing readonly 
system partitions to be overlayed (as a merged set of contents from two 
system partitions to solve library search issues, or on userdebug 
developer builds where we actually allow workdir to replace contents), 
the _same_ security hole exists with overlay or not when a process (eg, 
via binder or unix doman socket) passes a file descriptor or inode 
reference around. Access to that reference still go through sepolicy 
checking (eg: read or write check MAC for target and source acceptable 
labels and paths).

In the generic case, it concerns me, albeit I must admit not fully 
understanding this attack. I have only pretended this option solves a 
non-overlapping MAC/DAC issue with caveats. For instance, do I need to 
add a longer list of caveats in the Kconfig or Documentation so the 
users are careful, or are there options that either need to be enforced 
orthogonal, or additional caps (as noted above) that need to be checked 
if the mounter is adding this option?
> IOW, if mounter is a separate process and if mounter itself can not
> access a certain resource, then it should not allow other lower privileged
> processes access to that resource. (Linux SELinux context= mounts). And
> I am concerned that by taking away checks for mounter's creds later, how
> do we ensure that privlege escalation did not happen by tricking mounter.

I do not propose to remove mounter's cred check, only allow the option 
to, the default is to use mounter's creds (except if the Kconfig or 
module options override the default).

On 06/26/2018 07:21 AM, Vivek Goyal wrote:
> On Sat, Jun 23, 2018 at 09:46:07AM +0300, Amir Goldstein wrote:
>> Mark,
>>
>> Thanks for the properly documented patch, but this documentation it
>> missing the caveats of this config option and there are severe caveats
>> as was discussed on earlier version of the patch.
>>
>> You should mention the not so minor detail that this option can result
>> in inability to delete files/directories from overlay and there me be other
>> side effects. This is one of those features that should be warning
>> unconditionally that user should really know what user is doing.
>>
>> You did not address my concern that the test for setting trusted xattr
>> on mount (ovl_make_workdir) should emit a different kind of warning
>> when override_creds=off. In fact, I think it should emit a warning
>> when override_creds=off unconditionally to indicate that weird things
>> can be expected and we "really hope you know what you are doing".
>>
>> A new security concern I just noticed - overlayfs calls some vfs
>> functions directly to perform operations that are typically not
>> allowed to unprivileged users without checking credentials.
>> In those cases your patch introduces a security vulnerability.
>>
>> Examples:
>> - overlayfs calls exportfs_decode_fh() on underlying
>> fs without checking CAP_DAC_READ_SEARCH
>> - overlayfs calls vfs_whiteout() which calls underlying fs mknod
>> without checking CAP_MKNOD
>>
I will have to work on that.
> This reminds me of another potential issue we discussed in the past.
>
> That is lookup() permissions inside a directory on lower and upper could
> be different. That is a process might be allowed to search in upper but
> not necessarily in lower and that lead to conflicts w.r.t what should be
> the semantics. Given overlay is providing merged directory view,
> should caller still be able to search in lower dir.
>
> https://lkml.org/lkml/2016/2/24/541
>
> I think initial approach was to create a variant where overlay ignored
> search permission checks on lower dir.
>
> commit 38b78a5f18584db6fa7441e0f4531b283b0e6725
> Author: Miklos Szeredi <mszeredi@redhat.com>
> Date:   Wed May 11 01:16:37 2016 +0200
>
>      ovl: ignore permissions on underlying lookup
>
> And later it we went back to using lookup_one_one() and this time we
> swithced to mounter's creds. So idea was that as long as mounter is
> allowed to search, caller gets to search in lower dir.
>
> commit c1b2cc1a765aff4df7b22abe6b66014236f73eba
> Author: Miklos Szeredi <mszeredi@redhat.com>
> Date:   Fri Jul 29 12:05:22 2016 +0200
>
>      ovl: check mounter creds on underlying lookup
>
>
> I think with this patch set, this issue will resurface. Caller might have
> permission to search in upper and not in lower.
I would hope that if a file is created in upper, that the directory has 
exactly the same priv's as lower, thus the restriction to search is the 
same. Yes, a privileged called could come in later and permit search and 
thus create a situation where updated content can be searched, but not 
static content in the lower. I believe this to be acceptable(tm)?
