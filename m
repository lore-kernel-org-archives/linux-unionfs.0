Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190118134519.3411-1-amir73il@gmail.com> <20190118144323.GA6420@redhat.com>
 <CAOQ4uxihLM_ztQ487SMiWr6w6646J0VfBpbNHyeybxX77COKsQ@mail.gmail.com> <20190118183446.GA2832@redhat.com>
In-Reply-To: <20190118183446.GA2832@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 18 Jan 2019 21:57:49 +0200
Message-ID: <CAOQ4uxgRwsnaiTY4a59-B3eR9gJ+a4ZewKTaKYAoOSRcmVDF2Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] ovl: lazy copy up of data on first write
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 18, 2019 at 8:34 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jan 18, 2019 at 05:33:36PM +0200, Amir Goldstein wrote:
> > On Fri, Jan 18, 2019 at 4:43 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Fri, Jan 18, 2019 at 03:45:19PM +0200, Amir Goldstein wrote:
> > > > When metacopy feature is enabled, copy up only metadata when
> > > > opening a file O_RDWR and defer copy up of data until the first
> > > > write operation.
> > > >
> > >
> > > Amir,
> > >
> > > What's the primary use case of lazy data copy up. Are there users who
> > > open file O_RDWR but never write to it.
> >
> > I don't know of all the cases, but AFAIK, MSOffice apps (over network share
> > and maybe also LibreOffice) open the document file O_RDWR just to check
> > if editing is allowed, but but they re-open the file read-only, because the
> > document file is never written to. A temp file is written and moved over it.
> > So copy up of an MSOffice document file data is never beneficial.
> >
> > > Or we want to transfer latency of copy up from open to write.
> >
> > Indeed. Chengguang reported that in their use case, the latency at open
> > time is an issue.
> >
> > >
> > > Should this behavior be an opt in with another mount option (and not
> > > be enabled automatically with metacopy=on).
> > >
> >
> > I can't think of one good reason for user to opt-in for copy up data on open.
> > Or on a use case where latency on open is desired over latency on write.
> > Can you?
>
> I can't. I am wondering why are we changing default. Why is it a better
> default to do copy up on first WRITE and not during open time. In his

Oh there are very good reasons to prefer latency on WRITE over latency
on open.

One reason is that traditionally, open is not an operation where long latency
are expected, so apps may behave badly with long latency on open.

Another reason, if application is latency sensitive, it can use aio,
but there is no async open, or is there??

> emails, Chengguang, just said their applications will benefit from it
> without giving further details. So if their application is not
> writing, they could easily solve this problem by opening file
> O_RDONLY as well?

My understanding is that latency on open() is an issue and latency on
first write is not an issue, which is something I am familiar with from
other apps, but I will let Chengguang elaborate.

Thanks,
Amir.
