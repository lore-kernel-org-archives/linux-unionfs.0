From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in ovl_copy_up_start
Date: Thu, 18 Oct 2018 09:26:11 +0300
Message-ID: <CAOQ4uxjY1LpVKv1id6W-1nHaKC=RbG8HUkTvgGTdGo8MKwzSTw@mail.gmail.com>
References: <00000000000058404b0578797a9d@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000058404b0578797a9d@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot+3ef5c0d1a5cb0b21e6be@syzkaller.appspotmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 18, 2018 at 7:48 AM syzbot
<syzbot+3ef5c0d1a5cb0b21e6be@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    c343db455eb3 Merge branch 'parisc-4.19-3' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=167d08ee400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f55cb3dfcc6c33
> dashboard link: https://syzkaller.appspot.com/bug?extid=3ef5c0d1a5cb0b21e6be
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.

Reproducer is simple:
link a non-copied-up file into a non-copied-up parent:

~/unionmount-testsuite# ./run --ov -s
~/unionmount-testsuite# ln /mnt/a/foo100 /mnt/a/dir100/

>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3ef5c0d1a5cb0b21e6be@syzkaller.appspotmail.com
>

FYI, this is the fix:
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 276914ae3c60..e1a55ecb7aba 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -663,6 +663,10 @@ static int ovl_link(struct dentry *old, struct
inode *newdir,
        if (err)
                goto out_drop_write;

+       err = ovl_copy_up(new->d_parent);
+       if (err)
+               goto out_drop_write;
+
        if (ovl_is_metacopy_dentry(old)) {
                err = ovl_set_redirect(old, false);
                if (err)

> overlayfs: filesystem on './file0' not supported as upperdir
> XFS (loop3): unknown mount option [uid<00000000000000000000].
>
> kobject: 'loop2' (00000000ce85f3f9): kobject_uevent_env
> ============================================
> WARNING: possible recursive locking detected
> kobject: 'loop2' (00000000ce85f3f9): fill_kobj_path: path
> = '/devices/virtual/block/loop2'
> 4.19.0-rc8+ #65 Not tainted
> --------------------------------------------
> syz-executor2/8184 is trying to acquire lock:
> 00000000d7157f3f (&ovl_i_lock_key[depth]){+.+.}, at:
> ovl_copy_up_start+0x9c/0x2e0 fs/overlayfs/util.c:528
>
> but task is already holding lock:
> 000000006f802695 (&ovl_i_lock_key[depth]){+.+.}, at:
> ovl_nlink_start+0xe0/0x350 fs/overlayfs/util.c:771
>
> other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock(&ovl_i_lock_key[depth]);
>    lock(&ovl_i_lock_key[depth]);
>
>   *** DEADLOCK ***
>

Can someone tell me what the expected behavior of a nested
mutex_lock_interruptible(&lock); ?

Why does the reproducer only warn and not really deadlock.
It is because that is considered the lesser evil?
and obviously, then inner unlock releases the outer lock?

Thanks,
Amir.
