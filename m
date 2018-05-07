Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507182428.GA3463@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <CAOQ4uxjuY-AFCEJcL=ib4viq6mC2DGhv014EqG-Vsd2RAy=DZw@mail.gmail.com>
 <20180507182428.GA3463@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 21:33:32 +0300
Message-ID: <CAOQ4uxg-cGGu6mTf11vRM5PzcGy5T=w29_+TFt6bHk9gNkUGQA@mail.gmail.com>
Subject: Re: [PATCH v15 00/30] overlayfs: Delayed copy up of data
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 9:24 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, May 07, 2018 at 09:10:25PM +0300, Amir Goldstein wrote:
>> On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi,
>> >
>> > This is V15 of overlayfs metadata only copy-up feature. These patches I
>> > have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
>> >
>> > Patches are also available here.
>> >
>> > https://github.com/rhvgoyal/linux/commits/metacopy-v15
>> >
>> > I have run unionmount-testsuite and "./check -overlay -g quick" and that
>> > works. Only 4 overlay tests fail, which fail on vanilla kernel too.
>>
>> I wonder which tests failed? My -g quick as well as -s auto runs got
>> no fails.
>
> Hi Amir,
>
> overlay/16, overlay/41, overlay/43, overlay/44 fail for me, even with
> vanilla kernel. I never debugged these to figure out what's happening.
>
> Vivek
>
>
> overlay/016      - output mismatch (see /root/git/xfstests-dev/results//overlay/016.out.bad)
>     --- tests/overlay/016.out   2017-04-19 08:18:17.658511331 -0400
>     +++ /root/git/xfstests-dev/results//overlay/016.out.bad     2018-05-07 13:31:09.137091967 -0400
>     @@ -8,4 +8,4 @@
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>      wrote 16/16 bytes at offset 0
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     -00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
>     +00000000:  54 68 69 73 20 69 73 20 6f 6c 64 20 6e 65 77 73  This.is.old.news
>     ...
>     (Run 'diff -u tests/overlay/016.out /root/git/xfstests-dev/results//overlay/016.out.bad'  to see the entire diff)
>
>

This will pass if you set OVERLAY_MOUNT_OPTIONS="-o copy_up_shared=on"
after rorw patches are merge, we can make the test enable this option.

>
> overlay/041      - output mismatch (see /root/git/xfstests-dev/results//overlay/041.out.bad)
>     --- tests/overlay/041.out   2017-11-20 13:35:17.024529298 -0500
>     +++ /root/git/xfstests-dev/results//overlay/041.out.bad     2018-05-07 13:31:46.124091967 -0400
>     @@ -1,2 +1,19 @@
>      QA output created by 041
>     +Pure upper dir: Invalid d_ino reported for ..
>     +Pure upper dir: Invalid d_ino reported for .
>     +Pure upper dir: Invalid d_ino reported for subdir
>     +Impure dir: Invalid d_ino reported for ..
>     +Impure dir: Invalid d_ino reported for .
>     +Impure dir: Invalid d_ino reported for subdir
>     ...
> overlay/043      - output mismatch (see /root/git/xfstests-dev/results//overlay/043.out.bad)
>     --- tests/overlay/043.out   2017-11-27 14:48:31.704797612 -0500
>     +++ /root/git/xfstests-dev/results//overlay/043.out.bad     2018-05-07 13:31:48.293091967 -0400
>     @@ -1,2 +1,39 @@
>      QA output created by 043
>     +dir not found by ino 232521 (from /tmp/15394.before)
>     +file not found by ino 50367463 (from /tmp/15394.before)
>     +symlink not found by ino 50367464 (from /tmp/15394.before)
>     +chrdev not found by ino 50367465 (from /tmp/15394.before)
>     +blkdev not found by ino 50367466 (from /tmp/15394.before)
>     +fifo not found by ino 50367467 (from /tmp/15394.before)
>     ...
>
> overlay/044      - output mismatch (see /root/git/xfstests-dev/results//overlay/044.out.bad)
>     --- tests/overlay/044.out   2017-11-27 14:48:31.704797612 -0500
>     +++ /root/git/xfstests-dev/results//overlay/044.out.bad     2018-05-07 13:31:49.462091967 -0400
>     @@ -7,11 +7,13 @@
>      one
>      zero
>      one
>     +bar not found by ino 33592805 (from /tmp/15776.before)
>      == After mount cycle ==
>      zero
>      one
>

These 3 tests have been fixed in xfstest master to enable xino last Sunday.

Thanks,
Amir.
