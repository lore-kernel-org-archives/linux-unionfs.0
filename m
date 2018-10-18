From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: possible deadlock in ovl_copy_up_start
Date: Thu, 18 Oct 2018 10:41:17 +0200
Message-ID: <CAJfpegsDfJMsT8OJVYuUFpNz94ex0fm5Z-e2Gp=cUgXsb_L-Jg@mail.gmail.com>
References: <00000000000058404b0578797a9d@google.com> <CAOQ4uxjY1LpVKv1id6W-1nHaKC=RbG8HUkTvgGTdGo8MKwzSTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjY1LpVKv1id6W-1nHaKC=RbG8HUkTvgGTdGo8MKwzSTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: syzbot+3ef5c0d1a5cb0b21e6be@syzkaller.appspotmail.com, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 18, 2018 at 8:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> Can someone tell me what the expected behavior of a nested
> mutex_lock_interruptible(&lock); ?
>
> Why does the reproducer only warn and not really deadlock.
> It is because that is considered the lesser evil?
> and obviously, then inner unlock releases the outer lock?

No, it's not the same lock, just the same lock class (first one is
OVL_I(d_inode(old))->lock, the other is
OVL_I(d_inode(new->d_parent)))->lock).

So we could possibly get away with annotating with
mutex_lock_nested().  Is this the only place that ovl_i_lock is
nested?

Thanks,
Miklos
