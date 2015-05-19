From: Bastian Bittorf <bittorf@bluebottle.com>
Subject: Re: linux / overlay / OpenWrt / problems with full
	working dir
Date: Tue, 19 May 2015 14:00:18 +0200
Message-ID: <20150519120018.GM28644@medion.lan>
References: <20150519075120.GL28644@medion.lan> <20150519090339.GB9960@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <openwrt-devel-bounces@lists.openwrt.org>
Content-Disposition: inline
In-Reply-To: <20150519090339.GB9960@tucsk>
List-Unsubscribe: <https://lists.openwrt.org/cgi-bin/mailman/options/openwrt-devel>,
 <mailto:openwrt-devel-request@lists.openwrt.org?subject=unsubscribe>
List-Archive: <http://lists.openwrt.org/pipermail/openwrt-devel/>
List-Post: <mailto:openwrt-devel@lists.openwrt.org>
List-Help: <mailto:openwrt-devel-request@lists.openwrt.org?subject=help>
List-Subscribe: <https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel>,
 <mailto:openwrt-devel-request@lists.openwrt.org?subject=subscribe>
Errors-To: openwrt-devel-bounces@lists.openwrt.org
Sender: "openwrt-devel" <openwrt-devel-bounces@lists.openwrt.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: openwrt-devel@lists.openwrt.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

* Miklos Szeredi <miklos@szeredi.hu> [19.05.2015 11:19]:
> The work directory is needed for atomic copy-up and similar.  It is not actually
> necessary to mount a read-only overlay.  Post 4.0 it is possible to mount the
> overlay without workdir (but even then it won't happen automatically in case the
> upper fs is full, so this should be fixed in the latest kernel too).
> 
> Could you please try the following patch?  If the workdir can't be created it
> will fall back to mounting the overlay read-only.

Thank you!
I applied it on top of 3.18 and it works.
Here some output with full 'work-dir'/jffs2:

...
[    8.800000] jffs2: notice: (323) jffs2_build_xattr_subsystem: complete building xattr subsystem, 2 of xdatum (2 unc hecked, 0 orphan) and 2 of xref (0 dead, 0 orphan) found.
[    8.820000] mount_root: switching to jffs2 overlay
[    9.030000] overlayfs: failed to work directory (EROFS), mounting read-only
...
 
root@box:~ df -h
Filesystem                Size      Used Available Use% Mounted on
rootfs                  576.0K    532.0K     44.0K  92% /
/dev/root                 2.3M      2.3M         0 100% /rom
tmpfs                    14.0M      1.2M     12.8M   8% /tmp
/dev/mtdblock3          576.0K    532.0K     44.0K  92% /overlay
overlayfs:/overlay      576.0K    532.0K     44.0K  92% /
tmpfs                   512.0K         0    512.0K   0% /dev

root@box:~ mount
rootfs on / type rootfs (rw)
/dev/root on /rom type squashfs (ro,relatime)
proc on /proc type proc (rw,noatime)
sysfs on /sys type sysfs (rw,noatime)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noatime)
/dev/mtdblock3 on /overlay type jffs2 (rw,noatime)
overlayfs:/overlay on / type overlay (ro,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)
tmpfs on /dev type tmpfs (rw,relatime,size=512k,mode=755)
devpts on /dev/pts type devpts (rw,relatime,mode=600)
debugfs on /sys/kernel/debug type debugfs (rw,noatime)

please apply it on your git, and we will cherrypick/backport it for OpenWrt.
(and close ticket https://dev.openwrt.org/ticket/19564)

bye, bastian
