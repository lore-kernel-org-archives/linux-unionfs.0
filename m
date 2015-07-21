From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] ovl: free stack of paths in ovl_fill_super
Date: Tue, 21 Jul 2015 08:27:49 -0700
Message-ID: <20150721152749.GA2833@kroah.com>
References: <20150721145843.11975.3849.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150721145843.11975.3849.stgit@buzz>
Sender: stable-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 21, 2015 at 05:58:43PM +0300, Konstantin Khlebnikov wrote:
> This fixes small memory leak after each successful mount.
> Kmemleak report:
> 
> unreferenced object 0xffff88003683fe00 (size 16):
>   comm "mount", pid 2029, jiffies 4294909563 (age 33.380s)
>   hex dump (first 16 bytes):
>     20 27 1f bb 00 88 ff ff 40 4b 0f 36 02 88 ff ff   '......@K.6....
>   backtrace:
>     [<ffffffff811f8cd4>] create_object+0x124/0x2c0
>     [<ffffffff817a059b>] kmemleak_alloc+0x7b/0xc0
>     [<ffffffff811dffe6>] __kmalloc+0x106/0x340
>     [<ffffffffa01b7a29>] ovl_fill_super+0x389/0x9a0 [overlay]
>     [<ffffffff81200ac4>] mount_nodev+0x54/0xa0
>     [<ffffffffa01b7118>] ovl_mount+0x18/0x20 [overlay]
>     [<ffffffff81201ab3>] mount_fs+0x43/0x170
>     [<ffffffff81220d34>] vfs_kern_mount+0x74/0x170
>     [<ffffffff812233ad>] do_mount+0x22d/0xdf0
>     [<ffffffff812242cb>] SyS_mount+0x7b/0xc0
>     [<ffffffff817b6bee>] entry_SYSCALL_64_fastpath+0x12/0x76
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: a78d9f0d5d5c ("ovl: support multiple lower layers")
> ---
>  fs/overlayfs/super.c |    1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
