From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in string (2)
Date: Wed, 24 Oct 2018 12:35:21 +0300
Message-ID: <CAOQ4uxi84ywY4BXJ1ZYDOQHZhbYr+GjJTrkGZvBbH4XUqR0nPw@mail.gmail.com>
References: <0000000000003852440576ef80b2@google.com> <CACT4Y+bR+9vy5ZKDN31gmvKk5hcoNojaBuD9Dz1wswfObyt0uw@mail.gmail.com>
 <CAOQ4uxhxON4EeWqVLN68YF4v=hr5wfQk9wZEZLZLZu7B_XGuUw@mail.gmail.com> <20181024090959.s5y3azpsmtswjyn5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181024090959.s5y3azpsmtswjyn5@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, syzkaller-bugs@googlegroups.com, Jan Harkes <jaharkes@cs.cmu.edu>, Jeff Layton <jlayton@kernel.org>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

> > diff --git a/fs/lockd/host.c b/fs/lockd/host.c
> > index d35cd6be0675..93fb7cf0b92b 100644
> > --- a/fs/lockd/host.c
> > +++ b/fs/lockd/host.c
> > @@ -341,7 +341,7 @@ struct nlm_host *nlmsvc_lookup_host(const struct
> > svc_rqst *rqstp,
> >         };
> >         struct lockd_net *ln = net_generic(net, lockd_net_id);
> >
> > -       dprintk("lockd: %s(host='%*s', vers=%u, proto=%s)\n", __func__,
> > +       dprintk("lockd: %s(host='%.*s', vers=%u, proto=%s)\n", __func__,
> >                         (int)hostname_len, hostname, rqstp->rq_vers,
> >                         (rqstp->rq_prot == IPPROTO_UDP ? "udp" : "tcp"));
> >
>
> Why wasn't this one applied?  It looks correct to me.  The rest seem to
> have been fixed already.
>

I did not send this patch to Jeff.
Jeff was CC'ed on the patch I sent to Miklos
and Miklos decided to only take the overlayfs bits:
https://marc.info/?l=linux-unionfs&m=153847248625015&w=2

So I guess it has fallen between the cracks.
Feel free to send a patch to Jeff.

Thanks,
Amir.
