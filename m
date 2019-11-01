Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <ae928bd7-001a-061e-01f0-43b53a0adcd1@linux.alibaba.com> <88f09a1e-2481-ac16-9754-77e21296b03a@gmail.com>
In-Reply-To: <88f09a1e-2481-ac16-9754-77e21296b03a@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Nov 2019 16:25:40 +0200
Message-ID: <CAOQ4uxgHrtbCk+FMi5VOmQ+XUxGKmb5y--zgOQAz5_jx0ZuG8Q@mail.gmail.com>
Subject: Re: Performance regression caused by stack operation of regular file
Content-Type: text/plain; charset="UTF-8"
To: Joseph Qi <jiangqi903@gmail.com>
Cc: JeffleXu <jefflexu@linux.alibaba.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Nov 1, 2019 at 9:27 AM Joseph Qi <jiangqi903@gmail.com> wrote:
>
> Hi Miklos & Amir,
> Could you please take a look at this?
> It behaves different between the latest kernel and an old one, e.g. 4.9.

Not surprisingly.
Stacked file operations in 4.19 shuffled the cards.
See below.

>
> Thanks,
> Joseph
>
> On 19/10/28 14:21, JeffleXu wrote:
> > Hi, Miklos,
> >
> > I noticed a performance regression of reading/writing files in mergeddir caused by commit a6518f73e60e5044656d1ba587e7463479a9381a (vfs: don't open real), using unixbench fstime.
> >
> >
> > Reproduce Steps:
> >
> > 1. cd /mnt/lower/ && git clone https://github.com/kdlucas/byte-unixbench.git
> >
> > 2. mount -t overlay overlay -olowerdir=/mnt/lower,upperdir=/mnt/upper,workdir=/mnt/work /mnt/merge
> >
> > 3. cd /mnt/merge/byte-unixbench/UnixBench && ./Run -c 1 -i 1 fstime
> >
> >
> > The score is 2870 before applying the patch, while it is 1780 after applying the patch, causing a 40% performance regression.
> >
> > The testcase repeatedly reads 1024 bytes from one file and writes the readed data into another file, while both these two files
> >
> > are created under /mnt/merge/tmp.  I have testsed the latest kernel 5.4.0-rc4+, same results.
> >

Is this really a workload that you are interested in or just a random
micro benchmark?
If kernel changes behavior for the better in some workloads and for the worst
in other workloads, it is important to distinguish between the case of real
life workloads and less meaningful micro benchmarks that do not really have
that much effect on real world.

> >
> > The perf shows that there's extra one call of file_remove_privs(), override_creds() and revert_creds() every write() syscall,
> >
> > among which file_remove_privs() is pretty expensive.
> >

Interesting.
If this is indeed the reasons for the perf regression
then it boils down to performance vs. security, because if kernel
4.9 is truly faster due to skipped file_remove_privs() and override_creds()
then it is not really enforcing security in a consistent manner.
It's true that in the common case, mounter credentials are a super set of
user credentials, so file_remove_privs() and  security_file_permission()
with user credentials are most of the time practically enough, but that is
not universally true.

If the workload is truly important to you, please try to figure out
why the extra calls are so expensive.
Do you have any LSMs enabled?

Thanks,
Amir.
