Return-Path: <vgoyal@redhat.com>
Date: Mon, 7 May 2018 15:14:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 00/30] overlayfs: Delayed copy up of data
Message-ID: <20180507191444.GA2945@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <CAOQ4uxjuY-AFCEJcL=ib4viq6mC2DGhv014EqG-Vsd2RAy=DZw@mail.gmail.com>
 <20180507182428.GA3463@redhat.com>
 <CAOQ4uxg-cGGu6mTf11vRM5PzcGy5T=w29_+TFt6bHk9gNkUGQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg-cGGu6mTf11vRM5PzcGy5T=w29_+TFt6bHk9gNkUGQA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 07, 2018 at 09:33:32PM +0300, Amir Goldstein wrote:
> On Mon, May 7, 2018 at 9:24 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, May 07, 2018 at 09:10:25PM +0300, Amir Goldstein wrote:
> >> On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Hi,
> >> >
> >> > This is V15 of overlayfs metadata only copy-up feature. These patches I
> >> > have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.
> >> >
> >> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
> >> >
> >> > Patches are also available here.
> >> >
> >> > https://github.com/rhvgoyal/linux/commits/metacopy-v15
> >> >
> >> > I have run unionmount-testsuite and "./check -overlay -g quick" and that
> >> > works. Only 4 overlay tests fail, which fail on vanilla kernel too.
> >>
> >> I wonder which tests failed? My -g quick as well as -s auto runs got
> >> no fails.
> >
> > Hi Amir,
> >
> > overlay/16, overlay/41, overlay/43, overlay/44 fail for me, even with
> > vanilla kernel. I never debugged these to figure out what's happening.
> >
> > Vivek
> >
> >
> > overlay/016      - output mismatch (see /root/git/xfstests-dev/results//overlay/016.out.bad)
> >     --- tests/overlay/016.out   2017-04-19 08:18:17.658511331 -0400
> >     +++ /root/git/xfstests-dev/results//overlay/016.out.bad     2018-05-07 13:31:09.137091967 -0400
> >     @@ -8,4 +8,4 @@
> >      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >      wrote 16/16 bytes at offset 0
> >      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >     -00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
> >     +00000000:  54 68 69 73 20 69 73 20 6f 6c 64 20 6e 65 77 73  This.is.old.news
> >     ...
> >     (Run 'diff -u tests/overlay/016.out /root/git/xfstests-dev/results//overlay/016.out.bad'  to see the entire diff)
> >
> >
> 
> This will pass if you set OVERLAY_MOUNT_OPTIONS="-o copy_up_shared=on"
> after rorw patches are merge, we can make the test enable this option.

Thanks for the suggestions. All 4 failing tests are passing now (both
with vanilla kernel and with metacopy patches).

Vivek
