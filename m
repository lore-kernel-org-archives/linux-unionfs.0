MIME-Version: 1.0
Date: Sat, 30 Mar 2019 20:44:59 +0100
References: <20190328153829.729-1-amir73il@gmail.com>
In-Reply-To: <20190328153829.729-1-amir73il@gmail.com>
Message-ID: <CAJfpegt08nTeDs4+3svOjGAF+mQEP+Dm-amLz9nDWOACqtAUMQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() for overlapping layers use case
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs@googlegroups.com
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 28, 2019 at 4:38 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> This nasty little syzbot repro:
> https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000
>
> Creates overlay mounts where the same directory is both in upper
> and lower layers. Simplified example:
>
>   mkdir foo work
>   mount -t overlay none foo -o"lowerdir=.,upperdir=foo,workdir=work"

Shouldn't the mount fail in this case?

Does it make any sense to allow overlapping layers?

If doing the check the dumb way, the number of d_ancestor() calls
would increase quadratically with the number of layers, but I think
it's possible to do it in linear time if necessary.

Thanks,
Miklos
