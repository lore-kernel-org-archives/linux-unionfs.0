Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190612172408.22671-1-amir73il@gmail.com> <2851a6b983ed8b5b858b3b336e70296204349762.camel@kernel.org>
 <CAOQ4uxi-uEhAbqVeYbeqAR=TXpthZHdUKkaZJB7fy1TgdZObjQ@mail.gmail.com> <20190613140804.GA2145@fieldses.org>
In-Reply-To: <20190613140804.GA2145@fieldses.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Jul 2019 19:09:31 +0300
Message-ID: <CAOQ4uxjBGHh9cU7EX7X3F-iVFZkD+kax2x+Hj8YX83HMiwLqSw@mail.gmail.com>
Subject: Re: [PATCH v2] locks: eliminate false positive conflicts for write lease
Content-Type: text/plain; charset="UTF-8"
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jun 13, 2019 at 5:08 PM J . Bruce Fields <bfields@fieldses.org> wrote:
>
> On Thu, Jun 13, 2019 at 04:28:49PM +0300, Amir Goldstein wrote:
> > On Thu, Jun 13, 2019 at 4:22 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Looks good to me. Aside from the minor nit above:
> > >
> > >     Reviewed-by: Jeff Layton <jlayton@kernel.org>
> > >
> > > I have one file locking patch queued up for v5.3 so far, but nothing for
> > > v5.2. Miklos or Bruce, if either of you have anything to send to Linus
> > > for v5.2 would you mind taking this one too?
> > >
> >
> > Well. I did send a fix patch to Miklos for a bug introduced in v5.2-rc4,
> > so...
>
> I could take it.  I've modified it as below.
>
> I'm very happy with the patch, but not so much with the idea of 5.2 and
> stable.
>
> It seems like a subtle change with some possibility of unintended side
> effects.  (E.g. I don't think this is true any more, but my memory is
> that for a long time the only thing stopping nfsd from giving out
> (probably broken) write delegations was an extra reference that it held
> during processing.) And if the overlayfs bug's been there since 4.19,
> then waiting a little longer seems OK?
>

Getting back to this now that the patch is on its way to Linus.
Bruce, I was fine with waiting to 5.3 and I also removed CC: stable,
but did you mean that patch is not appropriate for stable or just that
we'd better wait a bit and let it soak in master before forwarding it to stable?

Thanks,
Amir.
