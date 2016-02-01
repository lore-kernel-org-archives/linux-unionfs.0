From: Rui Wang <rui.y.wang@intel.com>
Subject: Re: [PATCH] ovl: fix getcwd() failure after unsuccessful rmdir
Date: Mon,  1 Feb 2016 23:36:52 +0800
Message-ID: <1454341012-15062-1-git-send-email-rui.y.wang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: koct9i@gmail.com
Cc: rui.y.wang@intel.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com
List-Id: linux-unionfs@vger.kernel.org

On Sat, Jan 30, 2016 5:44 PM Konstantin Khlebnikov <koct9i@gmail.com> wrote: 
> On Fri, Jan 8, 2016 at 6:09 PM, Rui Wang <rui.y.wang@intel.com> wrote:
> ovl_remove_upper() should do d_drop() only after it successfully 
> removes the dir, otherwise a subsequent getcwd() system call will 
> fail, breaking userspace programs.
>
> This is to fix: https://bugzilla.kernel.org/show_bug.cgi?id=110491
>
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>
> 
> Reviewed-by: Konstantin Khlebnikov <koct9i@gmail.com>
> 
> The same problem also in ovl_remove_and_whiteout() - when we remove
> non-pure dentry. It checks that directory isn't empty before, but
> I'm sure that vfs_rename which exchanges dentry and whiteout could
> fail for some reason and we'll end with unhashed dentry when nothing
> actually has been changed.

Yes I had the same feeling. There's a "goto out_d_drop" which causes
d_drop() to be called if ovl_do_rename() fails. but I wasn't able to
find a way to reproduce this problem, so I only fixed the problem
described in bug110491. It's what I could reliably test.

Thanks
Rui
