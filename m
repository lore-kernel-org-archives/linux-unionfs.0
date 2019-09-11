Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190712122434.14809-1-amir73il@gmail.com> <CAOQ4uxg+equ2vt3xqsC_v=m=YMFSAj2ywk2pga=BGZWgOQcVoA@mail.gmail.com>
 <CAOQ4uxhC_=oPcjwpzgq7YvZuFL=HWJ=9hXwcY=EupcAnLobcsA@mail.gmail.com> <CAJfpegvQzAmDHhoXh-aSPjmkqLSpP_KWOf08YED4H7uwqa-oVg@mail.gmail.com>
In-Reply-To: <CAJfpegvQzAmDHhoXh-aSPjmkqLSpP_KWOf08YED4H7uwqa-oVg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Sep 2019 16:04:37 +0300
Message-ID: <CAOQ4uxjwwxosfzkjjxUhBjizHGOx1wJ9zzFPmxVzLJx-ZFud+w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression caused by overlapping layers detection
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Colin Walters <walters@verbum.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Sep 11, 2019 at 2:50 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Sep 10, 2019 at 3:53 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > This patch got stuck in overlayfs-next.
> > Could you push it to Linus please?
>
> Just tested applied on top of -linus, and it fails overlayfs/065 with this:
>
> --- /root/xfstests-dev/tests/overlay/065.out    2019-06-18
> 15:12:19.147000000 +0200
> +++ /root/xfstests-dev/results//overlay/065.out.bad    2019-09-11
> 13:22:34.612000000 +0200
> @@ -1,8 +1,8 @@
>  QA output created by 065
>  Conflicting upperdir/lowerdir
> -mount: device already mounted or mount point busy
> +mount: /scratch/ovl-mnt: mount(2) system call failed: Too many levels
> of symbolic links
>  Conflicting workdir/lowerdir
> -mount: device already mounted or mount point busy
> +mount: /scratch/ovl-mnt: mount(2) system call failed: Too many levels
> of symbolic links
>  Overlapping upperdir/lowerdir
>  mount: Too many levels of symbolic links
>  Conflicting lower layers
>
> So the mount seems to fail, but with a different than expected error
> value.  Do you know what might be happening?
>

Yes, intentional. I have an update for  the test.
Was waiting with it until patch is merged upstream.

I also have a test for the regression, see:
https://github.com/amir73il/xfstests/commits/overlayfs-devel

Thanks,
Amir.
