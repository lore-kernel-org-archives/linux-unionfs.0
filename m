From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in string (2)
Date: Fri, 28 Sep 2018 20:39:15 +0300
Message-ID: <CAOQ4uxhxON4EeWqVLN68YF4v=hr5wfQk9wZEZLZLZu7B_XGuUw@mail.gmail.com>
References: <0000000000003852440576ef80b2@google.com> <CACT4Y+bR+9vy5ZKDN31gmvKk5hcoNojaBuD9Dz1wswfObyt0uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+bR+9vy5ZKDN31gmvKk5hcoNojaBuD9Dz1wswfObyt0uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dvyukov@google.com
Cc: syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, pmladek@suse.com, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, sergey.senozhatsky@gmail.com, syzkaller-bugs@googlegroups.com, Dan Carpenter <dan.carpenter@oracle.com>, Jan Harkes <jaharkes@cs.cmu.edu>, Jeff Layton <jlayton@kernel.org>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 28, 2018 at 5:55 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, Sep 28, 2018 at 4:45 PM, syzbot
> <syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com> wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    c127e59bee3e Merge tag 'for_v4.19-rc6' of git://git.kernel..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13b2f32a400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=dfb440e26f0a6f6f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=376cea2b0ef340db3dd4
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com
>
> I guess this is overlayfs rather than printk. +overlayfs maintainers
> In future syzbot will avoid attributing crashes to printk, because I
> think it's not the first time crashes are mis-attributed to printk:
> https://github.com/google/syzkaller/commit/41e4b32952f4590341ae872db0abf819b4004713
>
>
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000140
> > RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0e714a76d4
> > R13: 00000000004c32cb R14: 00000000004d4ef0 R15: 0000000000000004
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in string+0x298/0x2d0 lib/vsprintf.c:604
> > Read of size 1 at addr ffff8801c36c66ba by task syz-executor2/27811
> >
> > CPU: 0 PID: 27811 Comm: syz-executor2 Not tainted 4.19.0-rc5+ #36
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
> >  print_address_description.cold.8+0x9/0x1ff mm/kasan/report.c:256
> >  kasan_report_error mm/kasan/report.c:354 [inline]
> >  kasan_report.cold.9+0x242/0x309 mm/kasan/report.c:412
> >  __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
> >  string+0x298/0x2d0 lib/vsprintf.c:604
> >  vsnprintf+0x48e/0x1b60 lib/vsprintf.c:2293
> >  vscnprintf+0x2d/0x80 lib/vsprintf.c:2396
> >  vprintk_store+0x43/0x510 kernel/printk/printk.c:1847
> >  vprintk_emit+0x1c1/0x930 kernel/printk/printk.c:1905
> >  vprintk_default+0x28/0x30 kernel/printk/printk.c:1963
> >  vprintk_func+0x7e/0x181 kernel/printk/printk_safe.c:398
> >  printk+0xa7/0xcf kernel/printk/printk.c:1996
> >  ovl_lookup_index.cold.15+0xe8/0x1f8 fs/overlayfs/namei.c:689

Doh!
I used %*s instead of %.s
Look how common this mistake is! and I only checked under fs/

[CC: Dan Carpenter and other fs maintainers]
Idea for static code analyzers:
A variable named *len* is probably not what someone wants to describe
the width of %*s field and in most cases I found were %*s is used correctly
the string value is a compiler constant (often "").

Thanks,
Amir.

---
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 00876ddadb43..23ee5de8b4be 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -47,7 +47,7 @@ static struct dentry *coda_lookup(struct inode *dir,
struct dentry *entry, unsig
        int type = 0;

        if (length > CODA_MAXNAMLEN) {
-               pr_err("name too long: lookup, %s (%*s)\n",
+               pr_err("name too long: lookup, %s (%.*s)\n",
                       coda_i2s(dir), (int)length, name);
                return ERR_PTR(-ENAMETOOLONG);
        }
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index d35cd6be0675..93fb7cf0b92b 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -341,7 +341,7 @@ struct nlm_host *nlmsvc_lookup_host(const struct
svc_rqst *rqstp,
        };
        struct lockd_net *ln = net_generic(net, lockd_net_id);

-       dprintk("lockd: %s(host='%*s', vers=%u, proto=%s)\n", __func__,
+       dprintk("lockd: %s(host='%.*s', vers=%u, proto=%s)\n", __func__,
                        (int)hostname_len, hostname, rqstp->rq_vers,
                        (rqstp->rq_prot == IPPROTO_UDP ? "udp" : "tcp"));

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3415e0b09398..b74435dc85fd 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -259,7 +259,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb,
char *buf, int len)

        if (cconn) {
                out += snprintf(buf + out, len - out,
-                               "%10s => Stack: %s  Name: %*s  "
+                               "%10s => Stack: %s  Name: %.*s  "
                                "Version: %d.%d\n", "Cluster",
                                (*osb->osb_cluster_stack == '\0' ?
                                 "o2cb" : osb->osb_cluster_stack),
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f28711846dd6..9c0ca6a7becf 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -686,7 +686,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs
*ofs, struct dentry *upper,
                        index = NULL;
                        goto out;
                }
-               pr_warn_ratelimited("overlayfs: failed inode index
lookup (ino=%lu, key=%*s, err=%i);\n"
+               pr_warn_ratelimited("overlayfs: failed inode index
lookup (ino=%lu, key=%.*s, err=%i);\n"
                                    "overlayfs: mount with '-o
index=off' to disable inodes index.\n",
                                    d_inode(origin)->i_ino, name.len, name.name,
                                    err);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f61839e1054c..c096f12657cd 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -152,7 +152,7 @@ static inline int ovl_do_setxattr(struct dentry
*dentry, const char *name,
                                  const void *value, size_t size, int flags)
 {
        int err = vfs_setxattr(dentry, name, value, size, flags);
-       pr_debug("setxattr(%pd2, \"%s\", \"%*s\", 0x%x) = %i\n",
+       pr_debug("setxattr(%pd2, \"%s\", \"%.*s\", 0x%x) = %i\n",
                 dentry, name, (int) size, (char *) value, flags, err);
        return err;
 }
