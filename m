MIME-Version: 1.0
Date: Mon, 16 Dec 2019 12:58:44 +0100
References: <20191101123551.8849-1-cgxu519@mykernel.net>
	<CAOQ4uxi6g=UmfCjtZiyfgPhHc9+NCOQBQ++YeBTWmJaXjDNX_g@mail.gmail.com>
In-Reply-To: <CAOQ4uxi6g=UmfCjtZiyfgPhHc9+NCOQBQ++YeBTWmJaXjDNX_g@mail.gmail.com>
Message-ID: <CAJfpegv39gDaVwLXx4+Vzb75Bv2fOfCHX8-bjS0N9QRkXo=G1Q@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: improving copy-up efficiency for big sparse file
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@mykernel.net>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Dec 12, 2019 at 4:43 PM Amir Goldstein <amir73il@gmail.com> wrote:

> It's the same old story that was fixed in commit:
> 6d0a8a90a5bb ovl: take lower dir inode mutex outside upper sb_writers lock
>
> The lower overlay inode mutex is taken inside ovl_llseek() while upper fs
> sb_writers is held since ovl_maybe_copy_up() of nested overlay.
>
> Since the lower overlay uses same real fs as nested overlay upper,
> this could really deadlock if the lower overlay inode is being modified
> (took inode mutex and trying to take real fs sb_writers).
>
> Not a very common case, but still a possible deadlock.
>
> The only way to avoid this deadlock is probably a bit too hacky for your taste:
>
>         /* Skip copy hole optimization for nested overlay */
>         if (old->mnt->mnt_sb->s_stack_depth)
>                 skip_hole = false;
>
> The other way is to use ovl_inode_lock() in ovl_llseek().
>
> Have any preference? Something else?
>
> Should we maybe use ovl_inode_lock() also in ovl_write_iter() and
> ovl_ioctl_set_flags()? In all those cases, we are not protecting the overlay
> inode members, but the real inode members from concurrent modification
> through overlay.

Possibly.   I think this whole thing needs a good analysis of i_rwsem
use in overlayfs.

Thanks,
Miklos
