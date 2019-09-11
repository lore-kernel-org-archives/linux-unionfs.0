MIME-Version: 1.0
Date: Wed, 11 Sep 2019 13:50:29 +0200
References: <20190712122434.14809-1-amir73il@gmail.com>
	<CAOQ4uxg+equ2vt3xqsC_v=m=YMFSAj2ywk2pga=BGZWgOQcVoA@mail.gmail.com>
	<CAOQ4uxhC_=oPcjwpzgq7YvZuFL=HWJ=9hXwcY=EupcAnLobcsA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhC_=oPcjwpzgq7YvZuFL=HWJ=9hXwcY=EupcAnLobcsA@mail.gmail.com>
Message-ID: <CAJfpegvQzAmDHhoXh-aSPjmkqLSpP_KWOf08YED4H7uwqa-oVg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression caused by overlapping layers detection
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Colin Walters <walters@verbum.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Sep 10, 2019 at 3:53 PM Amir Goldstein <amir73il@gmail.com> wrote:

> This patch got stuck in overlayfs-next.
> Could you push it to Linus please?

Just tested applied on top of -linus, and it fails overlayfs/065 with this:

--- /root/xfstests-dev/tests/overlay/065.out    2019-06-18
15:12:19.147000000 +0200
+++ /root/xfstests-dev/results//overlay/065.out.bad    2019-09-11
13:22:34.612000000 +0200
@@ -1,8 +1,8 @@
 QA output created by 065
 Conflicting upperdir/lowerdir
-mount: device already mounted or mount point busy
+mount: /scratch/ovl-mnt: mount(2) system call failed: Too many levels
of symbolic links
 Conflicting workdir/lowerdir
-mount: device already mounted or mount point busy
+mount: /scratch/ovl-mnt: mount(2) system call failed: Too many levels
of symbolic links
 Overlapping upperdir/lowerdir
 mount: Too many levels of symbolic links
 Conflicting lower layers

So the mount seems to fail, but with a different than expected error
value.  Do you know what might be happening?

Thanks,
Miklos
