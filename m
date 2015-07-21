From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] ovl: free lower_mnt array in ovl_put_super
Date: Tue, 21 Jul 2015 08:27:59 -0700
Message-ID: <20150721152759.GB2833@kroah.com>
References: <20150721145843.11975.3849.stgit@buzz>
 <20150721145844.11975.16773.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150721145844.11975.16773.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 21, 2015 at 05:58:44PM +0300, Konstantin Khlebnikov wrote:
> This fixes memory leak after umount.
> Kmemleak report:
> 
> unreferenced object 0xffff8800ba791010 (size 8):
>   comm "mount", pid 2394, jiffies 4294996294 (age 53.920s)
>   hex dump (first 8 bytes):
>     20 1c 13 02 00 88 ff ff                           .......
>   backtrace:
>     [<ffffffff811f8cd4>] create_object+0x124/0x2c0
>     [<ffffffff817a059b>] kmemleak_alloc+0x7b/0xc0
>     [<ffffffff811dffe6>] __kmalloc+0x106/0x340
>     [<ffffffffa0152bfc>] ovl_fill_super+0x55c/0x9b0 [overlay]
>     [<ffffffff81200ac4>] mount_nodev+0x54/0xa0
>     [<ffffffffa0152118>] ovl_mount+0x18/0x20 [overlay]
>     [<ffffffff81201ab3>] mount_fs+0x43/0x170
>     [<ffffffff81220d34>] vfs_kern_mount+0x74/0x170
>     [<ffffffff812233ad>] do_mount+0x22d/0xdf0
>     [<ffffffff812242cb>] SyS_mount+0x7b/0xc0
>     [<ffffffff817b6bee>] entry_SYSCALL_64_fastpath+0x12/0x76
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: dd662667e6d3 ("ovl: add mutli-layer infrastructure")
> ---
>  fs/overlayfs/super.c |    1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
