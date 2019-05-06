MIME-Version: 1.0
Date: Mon, 6 May 2019 08:02:04 -0400
References: <20190506115719.123863-1-jiufei.xue@linux.alibaba.com>
In-Reply-To: <20190506115719.123863-1-jiufei.xue@linux.alibaba.com>
Message-ID: <CAJfpegs=a0m8reKeMb7EFH+UgpsZ-RJeMWzshRUBOO5-j_rA-w@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs: check the capability before cred overridden
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, joseph.qi@linux.alibaba.com
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 6, 2019 at 7:57 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>
> We found that it return success when we set IMMUTABLE_FL flag to a
> file in docker even though the docker didn't have the capability
> CAP_LINUX_IMMUTABLE.
>
> The commit d1d04ef8572b ("ovl: stack file ops") and
> dab5ca8fd9dd ("ovl: add lsattr/chattr support") implemented chattr
> operations on a regular overlay file. ovl_real_ioctl() overridden the
> current process's subjective credentials with ofs->creator_cred which
> have the capability CAP_LINUX_IMMUTABLE so that it will return success
> in vfs_ioctl()->cap_capable().
>
> Fix this by checking the capability before cred overriden. And here we
> only care about APPEND_FL and IMMUTABLE_FL, so get these information from
> inode.
>
> Changes since v1:
>  - remove S_DIRSYNC since ovl_copyflags() does not copy FS_DIRSYNC_FL,
>    pointed out by Amir Goldstein.
>
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>

Thanks.  Applied with modification, please see my vfs.git#overlayfs-next tree.

Miklos
