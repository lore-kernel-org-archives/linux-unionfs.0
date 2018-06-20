Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvqk3SDWA-GDTworPdgfV=jqeWMUviR5AhYxk+Tc-bUjnw@mail.gmail.com>
References: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
 <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
 <CALLuPvpEzczsFCD_u6+XOxUHY8EWaczYhH-sd=amJGgXsrnd4w@mail.gmail.com> <CALLuPvqk3SDWA-GDTworPdgfV=jqeWMUviR5AhYxk+Tc-bUjnw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 Jun 2018 15:25:29 +0300
Message-ID: <CAOQ4uxgt41iTTfEgDtYSG=iGLSK9LPR1znBKg_LQYVDwzAG21g@mail.gmail.com>
Subject: Re: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jun 20, 2018 at 10:03 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>>> I would check the change (from v4.14):
>>> 8db6c34f1dbc Introduce v3 namespaced file capabilities
>>>
>>> I suggest that you continue down the rabbit hole to see
>>> which check returns -EINVAL, whether inside ovl_xattr_get()
>>> or deeper inside nested vfs_getxattr().
>>>
>>> Other than that, you can try this overlayfs backport branch:
>>> https://github.com/amir73il/linux/commits/overlayfs-4.9.y-17
>>> It contains backported overlayfs patches up to v4.17 based
>>> off of v4.9.102.
>>>
>>> If problem is not reproduced on the backported branch then
>>> chances are the problem has to do with interaction between
>>> overlayfs and a change to another subsystem (e.g. v3
>>> namespaced file capabilities).
>>>
>
> First of all, the problem is NOT reproduced with overlayfs-4.9.y-17.
>
> Then I switch back to 4.17.0 to trace, here is the stack (with my printk):
> [  918.069392] cap_inode_getsecurity, !dentry
> [  918.069404] security_inode_getsecurity EINVAL,
> f=cap_inode_getsecurity+0x0/0x230 capability, ino: 87041043, alloc=1
> [  918.069406] vfs_getxattr: !strncmp: security.capability
> .libs/lt-g-ir-compiler , err=-22
> [  918.069408] __vfs_getxattr, handler->get , ino=3283670,
> name=security.capability, err=-22
> [  918.069419] get_vfs_caps_from_disk, size < 0, err=-22
> [  918.069420] Invalid argument reading file caps for
> /mnt/m_1/build/tmp/work/x86_64-linux/gobject-introspection-native/1.50.0-r0/build/.libs/lt-g-ir-compiler
> [  918.072495] cap_inode_getsecurity, !dentry
> [  918.072505] security_inode_getsecurity EINVAL,
> f=cap_inode_getsecurity+0x0/0x230 capability, ino: 87041045, alloc=1
> [  918.072507] vfs_getxattr: !strncmp: security.capability
> .libs/lt-g-ir-compiler , err=-22
> [  918.072509] __vfs_getxattr, handler->get , ino=3310656,
> name=security.capability, err=-22
> [  918.072519] get_vfs_caps_from_disk, size < 0, err=-22
> [  918.072520] Invalid argument reading file caps for
> /mnt/m_1/build/tmp/work/x86_64-linux/gobject-introspection-native/1.50.0-r0/build/.libs/lt-g-ir-compiler
>
> -EINVAL is actually returned by,
> cap_inode_getsecurity( ) {
>   dentry = d_find_alias(inode);
>   if (!dentry)
>     return -EINVAL;
>

Interesting... I don't fully understand how we get to a state where
d_find_alias() fails to find a real hashed dentry, but here are a few
observations:

- I was right about the patch that introduced the regression
  (v3 namespaced file capabilities)
- I think code in cap_inode_getsecurity() should use d_find_any_alias()
  instead of d_find_alias().  For example, if execveat() in called with an
  open but unlinked file d_find_alias() won't find the dentry
- execveat() of unlinked file is probably NOT the case here, because
  d_find_alias() fails to find real dentry, but does find the overlay dentry
- AFAICT, there is no requirement for dentry passed to vfs_getxattr_alloc()
  to be hashed. Note that in your case the underlying real handler->get()
  ext4_xattr_security_get() completely ignored the dentry argument

Please try if to replace d_find_alias/d_find_any_alias and see if that
fixes the problem.

If you can, please create a small reproducer that opens an executable,
unlink the executable and execute it with execveat().
I estimate this should fail with file capabilities enabled over any file
system, not just overlayfs.


> It appears that ino of "lt-g-ir-compiler" is changing (2 access error
> to the file as above log), and after the build stops,
> use "ls -i" to check ino, it become 87041047. Not sure it related to the cause.
>

This may indicate that the build is creating a temp file for execusion
and unlinks it. Can you check what build is doing with this file.
Which syscalls?

BTW, the reason that your trace prints a different ino for real and
overlayfs (i.e. ovl ino=3310656, real ino=87041045) is because
overlayfs only tries to keep overlay i_ino in sync for NFS
export. Fixed by commit 695b46e76b62 ("ovl: set i_ino to the
value of st_ino for NFS export") following your bug report.

You may try to repeat you reproducer with nfs_export=on, but
I doubt it will make a difference.

Thanks,
Amir.
