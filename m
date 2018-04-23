From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 16/35] ovl: readd lsattr/chattr support
Date: Mon, 23 Apr 2018 12:21:43 +0200
Message-ID: <CAJfpegt_i78O_sswFucHf8ZhD8BPkLVXAWFdxE6YkvU6v=SyTw@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-17-mszeredi@redhat.com>
 <CAOQ4uxhw+B_BqMjojSSrvnCYOLgc7J1TR_eOvPkfo=Gb0vcW8Q@mail.gmail.com> <CAOQ4uxhzsV=9PaJF3uPpMMrkKAmysFuOqmPzjhRCzmWjNC8S+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhzsV=9PaJF3uPpMMrkKAmysFuOqmPzjhRCzmWjNC8S+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Apr 22, 2018 at 10:35 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Apr 17, 2018 at 10:51 PM, Amir Goldstein <amir73il@gmail.com> wrote:

[snip]

> Is there a reason why the real file can't get the real path?

It could, except for vma->vm_file.

Now, we could have a separate realfile for mmap (with overlay path)
and one for everything else (with real path).  Maybe that's the way to
go, to minimize the chance of trouble caused by this irregularity.

> For current kernels, can you say what else can go wrong when filesystems
> call mnt_want_write_file() on an overlay file on ioctl with filesystem
> inode and why I couldn't reproduce readonly/freeze bypass?

mnt_want_write_file() is overlayfs-aware in current kernels.

We could fix it to use file_inode()->i_sb instead of
f_path.dentry->d_sb after reverting the overlay specific hack, and
that would fix the freeze bypass bug and would be correct for all
filesystems.   But I wonder how many such issues we have where
discrepancy between f_path.dentry and file_inode() matters.

Thanks,
Miklos
