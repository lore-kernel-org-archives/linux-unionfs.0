From: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH 3/3] nfs: Store and use inode in nfs_open_context
Date: Tue, 1 Mar 2016 15:46:48 -0500
Message-ID: <CAHQdGtRu2nd54+tKQLPp2tvf1MpKw4-X8ESqx-8W4_zAov7hFA@mail.gmail.com>
References: <1456855928-29913-1-git-send-email-rgoldwyn@suse.de>
	<1456855928-29913-4-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456855928-29913-4-git-send-email-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org, linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Mar 1, 2016 at 1:12 PM, Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org> wrote:
>
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
>
> NFS translates the inode from the dentry and uses sb from the dentry
> parameters. However, using NFS in conjunction with overlayfs, the inodes
> associated with dentries may be associated with overlayfs as opposed
> to NFS. So, store inode in nfs_open_context and use d_select_inode()
> to translate dentry to inode.

I don't see how this helps. The dentry and dentry->d_sb that are
associated with the open context need to be NFS namespace objects,
otherwise all sorts of things, ranging from inode lookup to NFSv4
state recovery are going to break.

Trond
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
