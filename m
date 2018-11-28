From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: overlayfs access checks on underlying layers
Date: Wed, 28 Nov 2018 14:34:42 -0500
Message-ID: <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com>
 <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181128170302.GA12405@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On 11/28/18 12:03 PM, Vivek Goyal wrote:
> On Wed, Nov 28, 2018 at 11:00:09AM +0100, Miklos Szeredi wrote:
>> On Tue, Nov 27, 2018 at 10:05 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>>
>>> On Tue, Nov 27, 2018 at 08:58:06PM +0100, Miklos Szeredi wrote:
>>>> [resending with fixed email address for Paul Moore]
>>>>
>>>> Moving discussion from github[1] to here.
>>>>
>>>> To summarize: commit 007ea44892e6 ("ovl: relax permission checking on
>>>> underlying layers") was added in 4.20-rc1 to make overlayfs access
>>>> checks on underlying "real" filesystems more consistent.  The
>>>> discussion leading up to this commit can be found at [2].  The commit
>>>> broke some selinux-testsuite cases, possibly indicating a security
>>>> hole opened by this commit.
>>>>
>>>> The model this patch tries to follow is that if "cp --preserve=all"
>>>> was allowed to the mounter from underlying layer to the overlay layer,
>>>> then operation is allowed.  That means even if mounter's creds doesn't
>>>> provide permission to for example execute underying file X, if
>>>> mounter's creds provide sufficient permission to perform "cp
>>>> --preserve=all X Y"  and original creds allow execute on Y, then the
>>>> operation is allowed.  This provides consistency in the face of
>>>> copy-ups.  Consistency is only provided in sane setups, where mounter
>>>> has sufficient privileges to access both the lower and upper layers.
>>>
>>> [cc daniel walsh]
>>>
>>> I think current selinux testsuite tests are written keeping these
>>> rules in mind.
>>>
>>> 1. Check overlay inode creds in the context of task and underlying
>>>     inode creds (lower/upper), in the context of mounter.
>>>
>>> 2. For a lower inode, if said file is being copied up, then only
>>>     check MAY_READ on lower. This is equivalent to mounter creating
>>>     a copy of file and providing caller access to it (context mount).
>>>
>>> For the case of special devices, we do not copy up these. So should
>>> we continue to do check on lower inode in the context of mounter
>>> (instead of not doing any check on lower at all).
>>
>> Hmm, I'm trying to understand the logic... If we follow the "cp
>> --preserve=all" thing, than mounter needs to have CREATE permission
>> for the special file, not READ or WRITE.  Does that make sense?  Would
>> that help with the context= mount use case?
> 
> Ok. If we follow "cp --preserve=all" methodology, then checking for
> mounter CREATE permission on upper for special files makes sense. Or
> change logic to copy up this special file during open. I am assuming
> we don't copy up special file during open as it is not necessary
> for things to work but copying up will work as well?
> 
> So rules will become.
> 
> - Two levels of checks.
> - For lower level inode, check MAY_READ for regular files. (including
>    exec).
> - For special files, only make sure mounter can CREATE object in upper.
> 
> - What about checks on files on upper/. As of now we seem to check
>    access in mounter's context if it is regular file. Skip the checks
>    completely for special files and for executables.
> 
> While non-context mount should still be ok, but this means lot of
> privilige granting to unprivileged process using context mounts. So
> unprivileged process which could not open a device/socket/fifo for
> read/write on host fs, can open it for those operations for context
> mounts.
> 
> IOW, for context mount case, an unprivileged user will gain lot of
> privileges. But that seems to be the point of context mount anyway
> on regular disks. If a disk is mounted using context mount option,
> then all real labels are ignored and all access checking happens
> using context label. We are doing similar thing. With one step extra
> and that is making sure if mounter itself can not do certain operation
> on host, that will still be denied.
> 
> This probably means that context= mounts should be used very carefully.
> It will grant lot of priviliges to the process (and allow operations
> which process could not do on host without overlayfs mount).
> 
> Case of device file still baffels me though. We don't do any mounter's
> checks on device files. So if a device file is on upper which mounter
> can't open for read but mounter is still granting priviliges to client
> to open that device file. That's unintutive to me and seems counter
> to the principle of that mounter can't give more priviliges than what
> it itself can't do on host.
> 
> Dan, stephen, paul moore, does this sound ok to you folks from selinux
> point of view.

It seems wrong to check CREATE when no file is being created, and doing 
so could lead to over-privileging of the mounter context, requiring one 
to allow a mounter context to create device nodes just to allow a client 
task context to read/write via already existing device nodes through an 
overlay.

Checking READ but not EXECUTE upon an execute check could permit a 
mounter to execute unauthorized code, if it can context mount from a 
readable-but-not-executable context to an executable context.

Note btw that cp --preserve=all doesn't quite operate as expected if 
dealing with a context mount.  You can't preserve the original security 
context if copying to a context mount unless the two contexts happen to 
already match.  So I'm not sure how that model applies in the case of a 
context mount.

Does the breaking commit (007ea44892e6) fix a real bug affecting users? 
  If not, I'd recommend just reverting it.
