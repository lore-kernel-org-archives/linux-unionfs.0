Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 21:10:25 +0300
Message-ID: <CAOQ4uxjuY-AFCEJcL=ib4viq6mC2DGhv014EqG-Vsd2RAy=DZw@mail.gmail.com>
Subject: Re: [PATCH v15 00/30] overlayfs: Delayed copy up of data
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> This is V15 of overlayfs metadata only copy-up feature. These patches I
> have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
>
> Patches are also available here.
>
> https://github.com/rhvgoyal/linux/commits/metacopy-v15
>
> I have run unionmount-testsuite and "./check -overlay -g quick" and that
> works. Only 4 overlay tests fail, which fail on vanilla kernel too.

I wonder which tests failed? My -g quick as well as -s auto runs got
no fails.

Thanks,
Amir.
