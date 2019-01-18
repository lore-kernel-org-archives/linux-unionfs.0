Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190118134519.3411-1-amir73il@gmail.com> <20190118144323.GA6420@redhat.com>
In-Reply-To: <20190118144323.GA6420@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 18 Jan 2019 17:33:36 +0200
Message-ID: <CAOQ4uxihLM_ztQ487SMiWr6w6646J0VfBpbNHyeybxX77COKsQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] ovl: lazy copy up of data on first write
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 18, 2019 at 4:43 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jan 18, 2019 at 03:45:19PM +0200, Amir Goldstein wrote:
> > When metacopy feature is enabled, copy up only metadata when
> > opening a file O_RDWR and defer copy up of data until the first
> > write operation.
> >
>
> Amir,
>
> What's the primary use case of lazy data copy up. Are there users who
> open file O_RDWR but never write to it.

I don't know of all the cases, but AFAIK, MSOffice apps (over network share
and maybe also LibreOffice) open the document file O_RDWR just to check
if editing is allowed, but but they re-open the file read-only, because the
document file is never written to. A temp file is written and moved over it.
So copy up of an MSOffice document file data is never beneficial.

> Or we want to transfer latency of copy up from open to write.

Indeed. Chengguang reported that in their use case, the latency at open
time is an issue.

>
> Should this behavior be an opt in with another mount option (and not
> be enabled automatically with metacopy=on).
>

I can't think of one good reason for user to opt-in for copy up data on open.
Or on a use case where latency on open is desired over latency on write.
Can you?

There is no contract with metacopy=on that states when a file is
copied up as meta and when it is copied up as data.
If there was a contract, it would probably state that only data modification
operations SHOULD copy up data and open is not a data modification
operation (it was just the last opportunity to do anything before stacked
file ops).

Thanks,
Amir.
