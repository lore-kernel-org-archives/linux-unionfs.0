From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [RFC PATCH 00/35] overlayfs: stack file operations
Date: Wed, 25 Apr 2018 21:44:36 +0200
Message-ID: <CAOssrKfeopc43SbHKOL9TL82U57_9Z2TaLwH5kqh7-3PuE3MBQ@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <5342.1524667789@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5342.1524667789@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 25, 2018 at 4:49 PM, J. R. Okajima <hooanon05g@gmail.com> wrote:
> Miklos Szeredi:
>> This patch series reverts the VFS hacks (with the exception of d_path) and
>
> I totally agree with removing d_real things.
> It must be good to the world.
>
> If I understand correctly, this series affects file_inode() too.
> So there may exist more commits to revert such as
>         fea6d2a6 2017-02-14 vfs: Use upper filesystem inode in bprm_fill_uid()


Yep.

>
> Here is another question.
> Does overlayfs support atomic_open?

No.  Overlayfs doesn't support network filesystems as modifiable
(upper) layer, and that's where atomic_open makes sense.  I think
actually no filesystem that defines atomic_open() can be used as upper
layer.   So that's currently not a worry.  If it turns out to be a
requirement to use such filesystem as upper, then I'll worry about
atomic_open().

Thanks,
Miklos
