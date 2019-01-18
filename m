Return-Path: <vgoyal@redhat.com>
Date: Fri, 18 Jan 2019 13:34:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] ovl: lazy copy up of data on first write
Message-ID: <20190118183446.GA2832@redhat.com>
References: <20190118134519.3411-1-amir73il@gmail.com>
 <20190118144323.GA6420@redhat.com>
 <CAOQ4uxihLM_ztQ487SMiWr6w6646J0VfBpbNHyeybxX77COKsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxihLM_ztQ487SMiWr6w6646J0VfBpbNHyeybxX77COKsQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 18, 2019 at 05:33:36PM +0200, Amir Goldstein wrote:
> On Fri, Jan 18, 2019 at 4:43 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Jan 18, 2019 at 03:45:19PM +0200, Amir Goldstein wrote:
> > > When metacopy feature is enabled, copy up only metadata when
> > > opening a file O_RDWR and defer copy up of data until the first
> > > write operation.
> > >
> >
> > Amir,
> >
> > What's the primary use case of lazy data copy up. Are there users who
> > open file O_RDWR but never write to it.
> 
> I don't know of all the cases, but AFAIK, MSOffice apps (over network share
> and maybe also LibreOffice) open the document file O_RDWR just to check
> if editing is allowed, but but they re-open the file read-only, because the
> document file is never written to. A temp file is written and moved over it.
> So copy up of an MSOffice document file data is never beneficial.
> 
> > Or we want to transfer latency of copy up from open to write.
> 
> Indeed. Chengguang reported that in their use case, the latency at open
> time is an issue.
> 
> >
> > Should this behavior be an opt in with another mount option (and not
> > be enabled automatically with metacopy=on).
> >
> 
> I can't think of one good reason for user to opt-in for copy up data on open.
> Or on a use case where latency on open is desired over latency on write.
> Can you?

I can't. I am wondering why are we changing default. Why is it a better
default to do copy up on first WRITE and not during open time. In his
emails, Chengguang, just said their applications will benefit from it
without giving further details. So if their application is not
writing, they could easily solve this problem by opening file
O_RDONLY as well?

Or is it the case that they don't know in advance whether file will
actually be written or not. So they open O_RDWR and after
that it could be written or not written?

Thanks
Vivek
