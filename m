From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular file
 using O_TMPFILE") breaks ubifs
Date: Tue, 28 Mar 2017 05:27:03 -0400
Message-ID: <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
References: <20170328100107.25095af6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170328100107.25095af6@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info
List-Id: linux-unionfs@vger.kernel.org

On Tue, Mar 28, 2017 at 4:01 AM, Ralph Sennhauser
<ralph.sennhauser@gmail.com> wrote:
> Hi Amir
>
> Commit d8514d8edb5b ("ovl: copy up regular file using O_TMPFILE")
> breaks squashfs with an ubifs overlay (both ubi volumes of the same
> container).
>

Hi Ralph,

I am confused by the description above. Which are the 'both ubi volumes'?

Can you provide exact command of overlayfs mount, preferably
also a script to generate the lower/upper images and mount them
to remove any mkfs option doubts from test setup.

> Renaming a file results in an error "UBIFS error (ubi0:1 pid 1394):
> ubifs_add_orphan: orphaned twice". This corrupts the the filesystem and
> the next attempt to mount the overlay will fail.
>

Does that happen on any attempt to rename a file?
A file that was only is lower I suppose?
Can you provide a simple script with your test, setting up the lower/upper
files and triggering the bug.

Thanks,
Amir.


>
>
> Bisect log:
>
>   git bisect start
>   # bad: [c02ed2e75ef4c74e41e421acb4ef1494671585e8] Linux 4.11-rc4
>   git bisect bad c02ed2e75ef4c74e41e421acb4ef1494671585e8
>   # good: [c470abd4fde40ea6a0846a2beab642a578c0b8cd] Linux 4.10
>   git bisect good c470abd4fde40ea6a0846a2beab642a578c0b8cd
>   # good: [bc49a7831b1137ce1c2dda1c57e3631655f5d2ae] Merge branch 'akpm' (patches from Andrew)
>   git bisect good bc49a7831b1137ce1c2dda1c57e3631655f5d2ae
>   # good: [738bc38d49e017fe7acb3596712518e22c225816] kernel/ksysfs.c: add __ro_after_init to bin_attribute structure
>   git bisect good 738bc38d49e017fe7acb3596712518e22c225816
>   # good: [3f80dd67c367878aaad16e458eebc3c8980bb841] Merge tag 'acpi-extra-4.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
>   git bisect good 3f80dd67c367878aaad16e458eebc3c8980bb841
>   # bad: [4495c08e84729385774601b5146d51d9e5849f81] Linux 4.11-rc2
>   git bisect bad 4495c08e84729385774601b5146d51d9e5849f81
>   # bad: [2d62e0768d3c28536d4cfe4c40ba1e5e8e442a93] Merge tag 'kvm-4.11-2' of git://git.kernel.org/pub/scm/virt/kvm/kvm
>   git bisect bad 2d62e0768d3c28536d4cfe4c40ba1e5e8e442a93
>   # good: [1827adb11ad26b2290dc9fe2aaf54976b2439865] Merge branch 'WIP.sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>   git bisect good 1827adb11ad26b2290dc9fe2aaf54976b2439865
>   # bad: [0b94da8dfc26ec2eb3e6640726e434abf8c53e49] Merge branch 'libnvdimm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
>   git bisect bad 0b94da8dfc26ec2eb3e6640726e434abf8c53e49
>   # bad: [0a040b2113ec226bcf56fcbe02d035bb5b30c35e] Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
>   git bisect bad 0a040b2113ec226bcf56fcbe02d035bb5b30c35e
>   # good: [590dce2d4934fb909b112cd80c80486362337744] Merge branch 'rebased-statx' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
>   git bisect good 590dce2d4934fb909b112cd80c80486362337744
>   # bad: [4e66c42c60fdf9be81837857454a41b39bf1b773] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse
>   git bisect bad 4e66c42c60fdf9be81837857454a41b39bf1b773
>   # bad: [e593b2bf513dd4d3fbfa0f435392eea2c7f776f0] ovl: properly implement sync_filesystem()
>   git bisect bad e593b2bf513dd4d3fbfa0f435392eea2c7f776f0
>   # bad: [d8514d8edb5b045cf7f708e14f888ce760d60f0b] ovl: copy up regular file using O_TMPFILE
>   git bisect bad d8514d8edb5b045cf7f708e14f888ce760d60f0b
>   # good: [42f269b925405d9dd45014823e5057786d6ca452] ovl: rearrange code in ovl_copy_up_locked()
>   git bisect good 42f269b925405d9dd45014823e5057786d6ca452
>   # first bad commit: [d8514d8edb5b045cf7f708e14f888ce760d60f0b] ovl: copy up regular file using O_TMPFILE
