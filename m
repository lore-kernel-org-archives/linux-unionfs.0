Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxgn=YNj8cJuccx2KqxEVGZy1z3DBVYXrD=Mc7Dc=Je+-w@mail.gmail.com>
 <20190416154513.GB13422@quack2.suse.cz>
In-Reply-To: <20190416154513.GB13422@quack2.suse.cz>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 16 Apr 2019 21:24:44 +0300
Message-ID: <CAOQ4uxh66kAozqseiEokqM3wDJws7=cnY-aFXH_0515nvsi2-A@mail.gmail.com>
Subject: Re: fanotify and LSM path hooks
Content-Type: text/plain; charset="UTF-8"
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Matthew Bobrowski <mbobrowski@mbobrowski.org>, LSM List <linux-security-module@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 16, 2019 at 6:45 PM Jan Kara <jack@suse.cz> wrote:
>
> Hi Amir!
>
> On Sun 14-04-19 19:04:14, Amir Goldstein wrote:
> > I started to look at directory pre-modification "permission" hooks
> > that were discussed on last year's LSFMM:
> > https://lwn.net/Articles/755277/
> >
> > The two existing fanotify_perm() hooks are called
> > from security_file_permission() and security_file_open()
> > and depend on build time CONFIG_SECURITY.
> > If you look at how the fsnotify_perm() hooks are planted inside the
> > generic security hooks, one might wonder, why are fanotify permission
> > hooks getting a special treatment and are not registering as LSM hooks?
> >
> > One benefit from an fanotify LSM, besides more generic code, would be
> > that fanotify permission hooks could be disabled with boot parameters.
> >
> > I only bring this up because security hooks seems like the most natural
> > place to add pre-modify fanotify events for the purpose of maintaining
> > a filesystem change journal. It would be ugly to spray more fsnotify hooks
> > inside security hooks instead of registering an fanotify LSM, but maybe
> > there are downsides of registering fanotify as LSM that I am not aware of?
>
> I kind of like the idea of generating fanotify permission events from
> special LSM hooks.
>

Cool, I think that all we really need to do is call security_add_hooks().
[reducing LSM CC list]

> I'm not so sure about directory pre-modification hooks. Given the amount of
> problems we face with applications using fanotify permission events and
> deadlocking the system, I'm not very fond of expanding that API... AFAIU
> you want to use such hooks for recording (and persisting) that some change
> is going to happen and provide crash-consistency guarantees for such
> journal?
>

That's the general idea.
I have two use cases for pre-modification hooks:
1. VFS level snapshots
2. persistent change tracking

TBH, I did not consider implementing any of the above in userspace,
so I do not have a specific interest in extending the fanotify API.
I am actually interested in pre-modify fsnotify hooks (not fanotify),
that a snapshot or change tracking subsystem can register with.
An in-kernel fsnotify event handler can set a flag in current task
struct to circumvent system deadlocks on nested filesystem access.

My current implementation of overlayfs snapshots [1] uses a stackable
filesystem (a.k.a. snapshot fs) as a means for pre-modify hooks.
This approach has some advantages and some disadvantages
compared to fsnotify pre-modify hooks.

With fsnotify pre-modify hooks it would be possible to protect
the underlying filesystem from un-monitored changes even when
filesystem is accessed from another mount point or another namespace.

As a matter of fact, the protection to underlying filesystem changes
needed for overlayfs snapshots is also useful for standard overlayfs -
Modification to underlying overlayfs layers are strongly discouraged,
but there is nothing preventing the user from making such modifications.
If overlayfs were to register for fsnotify pre-modify hooks on underlying
filesystem, it could prevent users from modifying underlying layers.

And not only that - because security_inode_rename() hook is called
with s_vfs_rename_mutex held, it is safe to use d_ancestor() to
prevent renames in and out of overlay layer subtrees.
With that protection in place, it is safe (?) to use is_subdir() in other
hooks to check if an object is under an overlayfs layer subtree,
because the entire ancestry below the layers roots is stable.

Will see if I can sketch a POC.

Thanks,
Amir.

[1] https://github.com/amir73il/overlayfs/wiki/Overlayfs-snapshots
