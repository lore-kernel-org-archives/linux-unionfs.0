Return-Path: <vgoyal@redhat.com>
Date: Fri, 23 Mar 2018 10:00:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Message-ID: <20180323140040.GA4954@redhat.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
 <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
 <CAOQ4uxiGQqGQy_te6PU7h1C_i1-JMEvfsG5B63GmLJDGrhNYLA@mail.gmail.com>
 <CAJfpegu6knx6oZ7-GKpeG0AtOT3MgtT_F+QBY7EeHj1cg-hb6g@mail.gmail.com>
 <CAOQ4uxg65nMyqAcyT5dW7A2ef9PDx1MKzFO-W2nV=XoT+=m0Ew@mail.gmail.com>
 <CAJfpegs5ee14Mrdzzmd4T24Hfsvqqt6X=AiU4wk=fv2F1b3BvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs5ee14Mrdzzmd4T24Hfsvqqt6X=AiU4wk=fv2F1b3BvQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eddie Horng <eddiehorng.tw@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 04:36:25PM +0100, Miklos Szeredi wrote:
> On Thu, Mar 22, 2018 at 4:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Thu, Mar 22, 2018 at 4:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Sat, Mar 17, 2018 at 9:29 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>> On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>>> On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>> [...]
> >>>
> >>>> The -oxino patches are interesting, but maybe we should leave them
> >>>> brewing for another cycle.  Do you agree?
> >>>>
> >>>
> >>> Miklos,
> >>>
> >>> FYI, I pushed ovl-xino branch that is rebased on v4.16-rc5 and on top
> >>> of a few fixes in branch ovl-fixes:
> >>> * 5668064a61f6 - ovl: set i_ino to the value of st_ino for NFS export
> >>> * 579515ad5c75 - ovl: opaque xattr should overrule redirect xattr
> >>> * 0161362aeab7 - ovl: fix lookup with middle layer opaque dir and
> >>> absolute path redirects
> >>
> >> I'm a bit confused about this last one.  It's in Vivek's lookup fixes
> >> series as well but in a slightly different form.  Which one should I
> >> be looking at?
> >>
> >
> > Vivek's patch is the later version (so v2).
> > There are 2 differences between v1 and v2:
> > 1. Vivek's commit message is more elaborate, so should take it.
> > 2. Vivek's patch sets only d->stop and not d->opaque
> > This difference is purely semantic, because d->opaque is
> > ignored in ovl_lookup() for anything but the upper layer.
> >
> > I am fine with the semantic change, but wasn't sure if you
> > had other meaning in mind w.r.t d->opaque and metadata
> > going forward.
> 
> I think clearing opaque it is the correct thing to do even if it
> doesn't have any effect.

Hi Miklos,

I am fine with anything. I was just trying to make it semantically
more clear. That is when ovl_lookup_layer() is called, what do fields
in ovl_data{} reflect. I felt that "->opaque" should reflect the
property of last element of the path. And if we stick to it, then we
should not clear d->opauque when absolute redirect is found.

But I am not particular about it and it should not affect existing
metacopy patches I am working on. So I am fine with whatever you think
is better thing to do.

Vivek
