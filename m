From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in ovl_copy_up_start
Date: Thu, 18 Oct 2018 13:40:14 +0300
Message-ID: <CAOQ4uxhw5ewvH6_x3oSU67Z+zLB28BUWijq7kM_h1+Jt66T1LA@mail.gmail.com>
References: <00000000000058404b0578797a9d@google.com> <CAOQ4uxjY1LpVKv1id6W-1nHaKC=RbG8HUkTvgGTdGo8MKwzSTw@mail.gmail.com>
 <CAJfpegsDfJMsT8OJVYuUFpNz94ex0fm5Z-e2Gp=cUgXsb_L-Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsDfJMsT8OJVYuUFpNz94ex0fm5Z-e2Gp=cUgXsb_L-Jg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: syzbot+3ef5c0d1a5cb0b21e6be@syzkaller.appspotmail.com, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 18, 2018 at 11:41 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Oct 18, 2018 at 8:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Can someone tell me what the expected behavior of a nested
> > mutex_lock_interruptible(&lock); ?
> >
> > Why does the reproducer only warn and not really deadlock.
> > It is because that is considered the lesser evil?
> > and obviously, then inner unlock releases the outer lock?
>
> No, it's not the same lock, just the same lock class (first one is
> OVL_I(d_inode(old))->lock, the other is
> OVL_I(d_inode(new->d_parent)))->lock).

Doh! of course.

>
> So we could possibly get away with annotating with
> mutex_lock_nested().  Is this the only place that ovl_i_lock is
> nested?
>

As far as I can see it is.
But how would we annotate it for consistent and clear locking order?
NLINK/COPYUP?
if we want this annotation to maintain locking order we need to patch
I posted (does copyup of new->parent prior to nlink_start), so then
we don't need nested annotations anymore.

Nah, I don't think we need to add nested annotations.

FYI, I am working on a small cleanup series for ovl_nlink_start/end
and ovl_inode_lock/unlock, but it is independent of the fix patch I posted
for this bug.

Thanks,
Amir.
