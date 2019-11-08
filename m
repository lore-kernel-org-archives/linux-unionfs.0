MIME-Version: 1.0
Date: Fri, 8 Nov 2019 10:02:26 +0100
References: <1573202522019.97305@axis.com>
In-Reply-To: <1573202522019.97305@axis.com>
Message-ID: <CAJfpegs2Hj9rqUiF+jmi5VK2XT_BV1+nNzKv140kLPPMaQgv2g@mail.gmail.com>
Subject: Re: [Help] Problem when using overlayfs with LoadPin
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Anders Dellien <anders.dellien@axis.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Nov 8, 2019 at 9:42 AM Anders Dellien <anders.dellien@axis.com> wrote:
>
> Hi all,
>
> I have previously successfully used LoadPin [https://www.kernel.org/doc/html/latest/admin-guide/LSM/LoadPin.html]
> together with overlayfs, however commit a6518f "vfs: don't open real" introduces a regression.
>
> (from loadpin.c):
>
>         /* file_dentry sees through overlays */
>         load_root = file_dentry(file)->d_sb;  (here, load_root->s_bdev is NULL and not the actual block device from the lower layer)

Umm, where does the above line come from?

Mainline looks like this:

    load_root = file->f_path.mnt->mnt_sb;

What is the expected behavior?   Should loadpin see through overlayfs or not?

Thanks.
Miklos
