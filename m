MIME-Version: 1.0
In-Reply-To: <20180913073715.2205-1-jencce.kernel@gmail.com>
References: <20180913073715.2205-1-jencce.kernel@gmail.com>
Date: Thu, 13 Sep 2018 10:00:51 +0200
Message-ID: <CAJfpegt+CrqNzj6bho_bqO1CG8-cB0D41X+yeTEbNtm2Gx6dAg@mail.gmail.com>
Subject: Re: [PATCH] Revert "vfs: don't open real"
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Xiong Zhou <xzhou@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Sep 13, 2018 at 9:37 AM, Murphy Zhou <jencce.kernel@gmail.com> wrote:
> From: Xiong Murphy Zhou <jencce.kernel@gmail.com>
>
> This reverts commit a6518f73e60e5044656d1ba587e7463479a9381a.
>
> swapon a file in overlayfs causes kernel panic since 4.19-rc1.
> 4.18 works fine. Bisect points to
>
> commit a6518f73e60e5044656d1ba587e7463479a9381a
> Author: Miklos Szeredi <mszeredi@redhat.com>
> Date:   Fri Jul 6 23:57:06 2018 +0200
>
>     vfs: don't open real
>
> as first bad commit. Revert it and remove redundant parameters of
> d_real can fix this panic on top of 4.19-rc3.

Please try instead:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Will send pull request later today.

Thanks,
Miklos
