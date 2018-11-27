From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in ovl_write_iter
Date: Tue, 27 Nov 2018 18:13:03 +0200
Message-ID: <CAOQ4uxhjFjeQ6m6c84Hv9V73brMKEOFNsg3Q1Kjb3resSdDjyA@mail.gmail.com>
References: <00000000000074e10d0576cc48f1@google.com> <0000000000001ec857057ba01589@google.com>
 <CAOQ4uxgiERNAyX4PDHf1DQLBg56rBANWLe575TGkz_WpbxaoCg@mail.gmail.com> <CACT4Y+bkAcCcy3p-iKe4jAzA=ZOk-WmbZrD0yOG96sjA7o-cXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+bkAcCcy3p-iKe4jAzA=ZOk-WmbZrD0yOG96sjA7o-cXA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

> > This looks like a false positive because lockdep is not aware of
> > s_stack_depth of the file (fs) associated with the pipe.
>
> There must be some annotation to tell lockdep about this.
>

It's a long story that can be summed up as "not simple":
https://lkml.org/lkml/2017/9/21/63

Overlayfs annotates inode mutex in lockdep friendly manner.
This is why you see:
 (&ovl_i_mutex_key[depth]){+.+.}, at: inode_lock

But this does not extend to other locks that may be associated
with filesystem or blockdev objects (e.g. pipe_lock()) and does
not cover the case of stacked blockdev (e.g. loop).

Thanks,
Amir.
