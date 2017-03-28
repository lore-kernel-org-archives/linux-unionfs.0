From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular file
 using O_TMPFILE") breaks ubifs
Date: Tue, 28 Mar 2017 07:03:11 -0400
Message-ID: <CAOQ4uxgNfuLN93owdCUJ=9VcU4DKGVEKkEGT7siiem8quVwCsQ@mail.gmail.com>
References: <20170328100107.25095af6@gmail.com>
 <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
 <20170328124545.3c4b87ff@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20170328124545.3c4b87ff@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, regressions@leemhuis.info, linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Mar 28, 2017 at 6:45 AM, Ralph Sennhauser
<ralph.sennhauser@gmail.com> wrote:
> On Tue, 28 Mar 2017 05:27:03 -0400
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> On Tue, Mar 28, 2017 at 4:01 AM, Ralph Sennhauser
>> <ralph.sennhauser@gmail.com> wrote:
>> > Hi Amir
>> >
>> > Commit d8514d8edb5b ("ovl: copy up regular file using O_TMPFILE")
>> > breaks squashfs with an ubifs overlay (both ubi volumes of the same
>> > container).
>> >
>>
>> Hi Ralph,
>>
>> I am confused by the description above. Which are the 'both ubi
>> volumes'?
>
> The ubi container has two volumes, the first is a squashfs, the second
> volume an ubifs. The latter is mounted as an overlay.
>
>>
>> Can you provide exact command of overlayfs mount, preferably
>> also a script to generate the lower/upper images and mount them
>> to remove any mkfs option doubts from test setup.
>
> Both I mount from the initramfs as follows (rom / overlay are empty in
> the initramfs):
>
>   mount -o rw,nosuid,nodev,noexec,noatime -t proc proc /proc || rescue_shell "proc"
>   mount -o rw,nosuid,nodev,noexec,noatime -t sysfs sysfs /sys || rescue_shell "sys"
>   mount -o rw,nosuid -t devtmpfs devtmpfs /dev || rescue_shell "dev"
>
>   ubiattach -m $(get_mtd_from_root_arg) /dev/ubi_ctrl || rescue_shell "attach"
>   ubiblock --create /dev/ubi0_0 || rescue_shell || "block"
>
>   mount -o ro -t squashfs /dev/ubiblock0_0 /rom || rescue_shell "mount rootfs"
>   mount -o rw,noatime -t ubifs /dev/ubi0_1 /overlay || rescue_shell "mount rootfs_data"
>
>   mkdir -p /overlay/upper || rescue_shell "mkdir upper"
>   mkdir -p /overlay/work || rescue_shell "mkdir work"
>
>   mount -o rw,noatime,lowerdir=/rom,upperdir=/overlay/upper,workdir=/overlay/work \
>           -t overlay overlay /newroot || rescue_shell "mount overlay"
>
>   mount --move /rom /newroot/rom || rescue_shell "move rootfs"
>   mount --move /overlay /newroot/overlay || rescue_shell "move rootfs_data"
>
>   mount --move /dev /newroot/dev || rescue_shell "move dev"
>   mount --move /sys /newroot/sys || rescue_shell "move sys"
>   mount --move /proc /newroot/proc || rescue_shell "move proc"
>
>   exec switch_root /newroot /sbin/init
>
> I use OpenWrt as a basis, replacing the kernel with a vanilla one.
>
> The options used to generate the file systems are:
>
> Squashfs:  -p 128KiB -m 2048 -s 512 -O 2048
> Ubifs: -m 2048 -e 124KiB -c 4096 -F
>
>>
>> > Renaming a file results in an error "UBIFS error (ubi0:1 pid 1394):
>> > ubifs_add_orphan: orphaned twice". This corrupts the the filesystem
>> > and the next attempt to mount the overlay will fail.
>> >
>>
>> Does that happen on any attempt to rename a file?
>> A file that was only is lower I suppose?
>
> That's how I trigger it, yes. Can reproduce it on any attempt.
>
>> Can you provide a simple script with your test, setting up the
>> lower/upper files and triggering the bug.
>
> Any more you need than the above mount script? A call to "mv somefile
> somefile.back && reboot" on a fresh install is all I do.
>
> Thanks
> Ralph
>
> PS: Reverting 01ad3eb8a073 ("ovl: concurrent copy up of regular files")
> as a dependency and the commit mentioned in Subject fix the issue for
> me. Tested on v4.11-rc4 and next-20170327.

That is not surprising.
Overlayfs now uses O_TMPFILE for copy up and it works fine with all the
file systems I tested (tmpfs, xfs, ext4).
If I am right and O_TMPFILE is broken in ubifs, you are most likely the first
person to test it (indirectly by overlayfs).

Please try to reproduce the bug with following patch to disable ubifs
O_TMPFILE support:

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1685,7 +1685,7 @@ const struct inode_operations
ubifs_dir_inode_operations = {
 #ifdef CONFIG_UBIFS_ATIME_SUPPORT
        .update_time = ubifs_update_time,
 #endif
-       .tmpfile     = ubifs_tmpfile,
+       //.tmpfile     = ubifs_tmpfile,
 };

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
