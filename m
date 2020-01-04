Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20200104203946.27914-1-James.Bottomley@HansenPartnership.com> <20200104203946.27914-3-James.Bottomley@HansenPartnership.com>
In-Reply-To: <20200104203946.27914-3-James.Bottomley@HansenPartnership.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 5 Jan 2020 01:09:43 +0200
Message-ID: <CAOQ4uxiMJePVaXFiLw88rnr4qxCPN0dLQcXq_KCC831hZzM7rA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] fs: introduce uid/gid shifting bind mount
Content-Type: text/plain; charset="UTF-8"
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Christian Brauner <christian@brauner.io>, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Seth Forshee <seth.forshee@canonical.com>, overlayfs <linux-unionfs@vger.kernel.org>, =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>, Eric Biederman <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Linux Containers <containers@lists.linux-foundation.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jan 4, 2020 at 10:41 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> This implementation reverse shifts according to the user_ns belonging
> to the mnt_ns.  So if the vfsmount has the newly introduced flag
> MNT_SHIFT and the current user_ns is the same as the mount_ns->user_ns
> then we shift back using the user_ns before committing to the
> underlying filesystem.
>
> For example, if a user_ns is created where interior (fake root, uid 0)
> is mapped to kernel uid 100000 then writes from interior root normally
> go to the filesystem at the kernel uid.  However, if MNT_SHIFT is set,
> they will be shifted back to write at uid 0, meaning we can bind mount
> real image filesystems to user_ns protected faker root.
>
> In essence there are several things which have to be done for this to
> occur safely.  Firstly for all operations on the filesystem, new
> credentials have to be installed where fsuid and fsgid are set to the
> *interior* values.

Must we really install new creds?
Maybe we just need to set/clear a SHIFTED flag on current creds?

i.e. instead of change_userns_creds(path)/revert_userns_creds()
how about start_shifted_creds(mnt)/end_shifted_creds().

and then cred_is_shifted() only checks the flag and no need for
all the cached creds mechanism.

current_fsuid()/current_fsgid() will take care of the shifting based on
the creds flag.

Also, you should consider placing a call to start_shifted/end_shifted
inside __mnt_want_write()/__mnt_drop_write().
This should automatically cover all writable fs ops  - including some that
you missed (setxattr).

Taking this a step further, perhaps it would make sense to wrap all readonly
fs ops with mnt_want_read()/mnt_drop_read() flavors.
Note that inode level already has a similar i_readcount access counter.

This could be used, for example, to provide a facility that is stronger than
MNT_DETACH, and weaker than filesystem "shutdown" ioctl, for blocking
new file opens (with openat()) on a mounted filesystem.

The point is, you add gating to vfs that is generic and not for single use
case (i.e. cred shifting).

Apologies in advance if  some of these ideas are ill advised.

Thanks,
Amir.
