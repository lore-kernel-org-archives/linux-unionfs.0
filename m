From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH 3/3] nfs: Store and use inode in nfs_open_context
Date: Thu, 3 Mar 2016 09:16:33 +0100
Message-ID: <CAJfpegtwDD4Qaect-5qzvG80vnn44iKawYCeTqQKneSK-FU3Lg@mail.gmail.com>
References: <1456855928-29913-1-git-send-email-rgoldwyn@suse.de>
	<1456855928-29913-4-git-send-email-rgoldwyn@suse.de>
	<CAHQdGtRu2nd54+tKQLPp2tvf1MpKw4-X8ESqx-8W4_zAov7hFA@mail.gmail.com>
	<56D6F84B.5040301@suse.de>
	<CAHQdGtSd8Sg-X7vGOJoVZZZZQFxfsdeOsHUcS5z09BOVwQ1pUw@mail.gmail.com>
	<CAHQdGtR1Ywp9JnO7mD5-tOy5wngsgp2OZBJyQx1hyaXpTNc54g@mail.gmail.com>
	<CAJfpegvm_E_K6_wwvuWnnm-D=tBEY=dq_frp8UObUysS4_Pixg@mail.gmail.com>
	<56D70D64.9010705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D70D64.9010705-l3A5Bk7waGM@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 2, 2016 at 4:57 PM, Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org> wrote:
> On 03/02/2016 08:43 AM, Miklos Szeredi wrote:

>> Not sure how any dentry seen by NFS became associated with overlayfs.
>> Through ->f_path by any chance?
>>
>
> Yes, NFS extracts dentry from filp->f_path.dentry in fs/nfs/inode.c
> nfs_open(). What can it use to evaluate dentry?

Commit 4bacc9c9234c ("overlayfs: Make f_path always point to the
overlay and f_inode to the underlay") broke this.  Breakage only
affects regular files.  Accessing file->f_path.dentry->d_name (and
"%pD" format etc) is OK for everything.   ->d_fsdata is not OK.

I have no idea what the plan was with filesystems that use
f_path.dentry a separate open file for them.  David?  Al?

My plan was to introduce a file_dentry() helper that MUST be used by
filesystems to get the dentry from the file and that makes sure it's
the right one (check against file_inode()).   If not, then we could
call into overlayfs to return the right one, similar to
->d_select_inode(), except we want to have a dentry and we want to
have *a particular dentry* matching file_inode() (the file could have
been copied up in the mean time).

Thanks,
Miklos

Thanks,
Miklos
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
