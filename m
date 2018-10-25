From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: KASAN: slab-out-of-bounds Read in string (2)
Date: Thu, 25 Oct 2018 12:19:27 -0400
Message-ID: <20181025161927.GD5539@fieldses.org>
References: <0000000000003852440576ef80b2@google.com>
 <CACT4Y+bR+9vy5ZKDN31gmvKk5hcoNojaBuD9Dz1wswfObyt0uw@mail.gmail.com>
 <CAOQ4uxhxON4EeWqVLN68YF4v=hr5wfQk9wZEZLZLZu7B_XGuUw@mail.gmail.com>
 <20181024090959.s5y3azpsmtswjyn5@mwanda>
 <CAOQ4uxi84ywY4BXJ1ZYDOQHZhbYr+GjJTrkGZvBbH4XUqR0nPw@mail.gmail.com>
 <09f6038b7642f425eba162ea2239552e12da2045.camel@kernel.org>
 <20181025150219.GA5539@fieldses.org>
 <CAOQ4uxh_WLVPnLt=r5j5wm7gET=C64RKGexGVdNyJK0d0aMr5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh_WLVPnLt=r5j5wm7gET=C64RKGexGVdNyJK0d0aMr5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Dmitry Vyukov <dvyukov@google.com>, syzbot+376cea2b0ef340db3dd4@syzkaller.appspotmail.com, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, syzkaller-bugs@googlegroups.com, Jan Harkes <jaharkes@cs.cmu.edu>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 25, 2018 at 06:17:25PM +0300, Amir Goldstein wrote:
> On Thu, Oct 25, 2018 at 6:02 PM Bruce Fields <bfields@fieldses.org> wrote:
> 
> > > > So I guess it has fallen between the cracks.
> > > > Feel free to send a patch to Jeff.
> > > >
> > > > Thanks,
> > > > Amir.
> > >
> > > Actually, this should probably go to Bruce, as he mostly takes care of
> > > lockd. Patch looks correct though.
> >
> > Yes, if you could resend I'd be happy to handle it.--b.
> 
> Attached.

Thanks, queuing it up for 4.20 and stable.

--b.

> Thanks,
> Amir.

> From 40000f4dcbd5dd18a80efb6aef010f1164985583 Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Fri, 28 Sep 2018 20:41:48 +0300
> Subject: [PATCH] lockd: fix access beyond unterminated strings in prints
> 
> printk format used %*s instead of %.*s, so hostname_len does not limit
> the number of bytes accessed from hostname.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/lockd/host.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/lockd/host.c b/fs/lockd/host.c
> index d35cd6be0675..93fb7cf0b92b 100644
> --- a/fs/lockd/host.c
> +++ b/fs/lockd/host.c
> @@ -341,7 +341,7 @@ struct nlm_host *nlmsvc_lookup_host(const struct svc_rqst *rqstp,
>  	};
>  	struct lockd_net *ln = net_generic(net, lockd_net_id);
>  
> -	dprintk("lockd: %s(host='%*s', vers=%u, proto=%s)\n", __func__,
> +	dprintk("lockd: %s(host='%.*s', vers=%u, proto=%s)\n", __func__,
>  			(int)hostname_len, hostname, rqstp->rq_vers,
>  			(rqstp->rq_prot == IPPROTO_UDP ? "udp" : "tcp"));
>  
> -- 
> 2.17.1
> 
