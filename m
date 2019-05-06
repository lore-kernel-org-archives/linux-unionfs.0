MIME-Version: 1.0
Date: Mon, 6 May 2019 07:56:33 -0400
References: <20190122050139.19701-1-amir73il@gmail.com>
	<CAOQ4uxhdgxtL3-tMDSegruCnNdvfLNDJ2p0OcnZrvXtPqiDf8A@mail.gmail.com>
	<CAOQ4uxjxOKXMviymoF6W7q1RPCht1z49N85S=ATGq5-oqfb1qQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjxOKXMviymoF6W7q1RPCht1z49N85S=ATGq5-oqfb1qQ@mail.gmail.com>
Message-ID: <CAJfpegv6HWXHvRLBkSpb0_TT=mmwgL873iw4LMMM_aU_tXnepg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix missing upper fs freeze protection on copy up
 for ioctl
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 27, 2019 at 2:37 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Mar 1, 2019 at 11:29 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jan 22, 2019 at 7:01 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Generalize the helper ovl_open_maybe_copy_up() and use it to copy up
> > > file with data before FS_IOC_SETFLAGS ioctl.
> > >
> > > Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
> > > Cc: <stable@vger.kernel.org> # v4.19
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks, applied.

Miklos
